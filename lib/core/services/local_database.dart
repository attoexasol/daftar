import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/models/transaction_model.dart';

/// LocalDatabase - Manages local SQLite database for offline functionality
/// Stores transactions locally when offline and syncs when back online
class LocalDatabase {
  static Database? _database;

  /// Get database instance (singleton pattern)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'daftar_local.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        payment_method TEXT NOT NULL,
        customer_supplier TEXT,
        description TEXT,
        receipt_url TEXT,
        branch_id TEXT,
        organization_id TEXT NOT NULL,
        is_synced INTEGER DEFAULT 0,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    // Create indices for better query performance
    await db.execute(
        'CREATE INDEX idx_transactions_date ON transactions(date DESC)');
    await db
        .execute('CREATE INDEX idx_transactions_type ON transactions(type)');
    await db.execute(
        'CREATE INDEX idx_transactions_synced ON transactions(is_synced)');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future schema changes
    if (oldVersion < 2) {
      // Example: Add new column in version 2
      // await db.execute('ALTER TABLE transactions ADD COLUMN new_field TEXT');
    }
  }

  /// Insert a transaction into local database
  Future<void> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    await db.insert(
      'transactions',
      {
        ...transaction.toJson(),
        'is_synced': 0, // Mark as not synced
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all unsynced transactions
  Future<List<TransactionModel>> getUnsyncedTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'is_synced = ?',
      whereArgs: [0],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return TransactionModel.fromJson(maps[i]);
    });
  }

  /// Get all transactions from local database
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return TransactionModel.fromJson(maps[i]);
    });
  }

  /// Mark a transaction as synced
  Future<void> markAsSynced(String id) async {
    final db = await database;
    await db.update(
      'transactions',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete a transaction from local database
  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Clear all transactions from local database
  Future<void> clearAllTransactions() async {
    final db = await database;
    await db.delete('transactions');
  }

  /// Get count of unsynced transactions
  Future<int> getUnsyncedCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM transactions WHERE is_synced = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
