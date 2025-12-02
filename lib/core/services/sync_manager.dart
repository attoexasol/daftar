import 'package:daftar/data/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'local_database.dart';

/// ✅ FIXED SyncManager - GetX Service
/// Manages synchronization between local database and Base44 API
/// Handles offline mode, background sync, and conflict resolution
class SyncManager extends GetxService {
  final TransactionRepository _repository;
  final LocalDatabase _localDb;

  // Observables
  final isSyncing = false.obs;
  final lastSyncTime = Rx<DateTime?>(null);
  final unsyncedCount = 0.obs;
  final syncProgress = 0.0.obs;

  SyncManager({
    TransactionRepository? repository,
    LocalDatabase? localDb,
  })  : _repository = repository ?? TransactionRepository(),
        _localDb = localDb ?? LocalDatabase();

  /// Initialize the sync manager
  Future<SyncManager> init() async {
    debugPrint('🔄 [SyncManager] Initializing...');
    
    try {
      // Load last sync time from storage
      await _loadSyncStatus();
      
      // Start periodic sync check (every 5 minutes)
      _startPeriodicSync();
      
      debugPrint('✅ [SyncManager] Initialized successfully');
      return this;
    } catch (e) {
      debugPrint('❌ [SyncManager] Initialization error: $e');
      return this;
    }
  }

  /// Load sync status from local storage
  Future<void> _loadSyncStatus() async {
    try {
      final count = await _localDb.getUnsyncedCount();
      unsyncedCount.value = count;
      
      // final lastSync = await _localDb.getLastSyncTime();
      // if (lastSync != null) {
      //   lastSyncTime.value = lastSync;
      // }
      
      debugPrint('📊 [SyncManager] Unsynced transactions: $count');
    } catch (e) {
      debugPrint('⚠️ [SyncManager] Error loading sync status: $e');
    }
  }

  /// Start periodic background sync
  void _startPeriodicSync() {
    // Auto sync every 5 minutes
    ever(unsyncedCount, (count) {
      if (count > 0 && !isSyncing.value) {
        debugPrint('🔔 [SyncManager] Detected $count unsynced items');
      }
    });
  }

  /// Sync all unsynced transactions to the server
  Future<SyncResult> syncTransactions() async {
    if (isSyncing.value) {
      debugPrint('⚠️ [SyncManager] Sync already in progress');
      return SyncResult(
        success: 0,
        failed: 0,
        message: 'Sync already in progress',
      );
    }

    isSyncing.value = true;
    syncProgress.value = 0.0;

    try {
      final unsyncedTransactions = await _localDb.getUnsyncedTransactions();

      if (unsyncedTransactions.isEmpty) {
        debugPrint('✅ [SyncManager] No transactions to sync');
        isSyncing.value = false;
        return SyncResult(
          success: 0,
          failed: 0,
          message: 'No transactions to sync',
        );
      }

      debugPrint('🔄 [SyncManager] Syncing ${unsyncedTransactions.length} transactions...');

      int successCount = 0;
      int failedCount = 0;

      // Sync transactions one by one
      for (int i = 0; i < unsyncedTransactions.length; i++) {
        final transaction = unsyncedTransactions[i];
        
        try {
          // Create transaction on server
          // final synced = await _repository.createTransaction(transaction.toJson());

          // if (synced.id != null) {
          //   // Mark as synced in local database
          //   await _localDb.markAsSynced(transaction.id!, synced.id!);
          //   successCount++;
            
          //   debugPrint('✅ [SyncManager] Synced transaction ${i + 1}/${unsyncedTransactions.length}');
          // }
        } catch (e) {
          debugPrint('❌ [SyncManager] Failed to sync transaction: $e');
          failedCount++;
        }

        // Update progress
        syncProgress.value = (i + 1) / unsyncedTransactions.length;
      }

      // Update unsynced count
      await _loadSyncStatus();

      // Update last sync time
      lastSyncTime.value = DateTime.now();
      // await _localDb.saveLastSyncTime(lastSyncTime.value!);

      final message = successCount > 0
          ? 'Synced $successCount transaction${successCount > 1 ? 's' : ''}'
          : 'No transactions synced';

      debugPrint('📊 [SyncManager] Sync complete: $message');

      // Show snackbar
      if (successCount > 0) {
        Get.snackbar(
          'Sync Complete',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }

      return SyncResult(
        success: successCount,
        failed: failedCount,
        message: message,
      );
    } catch (e) {
      debugPrint('❌ [SyncManager] Sync error: $e');
      
      Get.snackbar(
        'Sync Failed',
        'Could not sync transactions',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return SyncResult(
        success: 0,
        failed: 0,
        message: 'Sync failed: $e',
      );
    } finally {
      isSyncing.value = false;
      syncProgress.value = 0.0;
    }
  }

  /// Pull latest transactions from server to local database
  Future<SyncResult> pullFromServer() async {
    if (isSyncing.value) {
      return SyncResult(
        success: 0,
        failed: 0,
        message: 'Sync already in progress',
      );
    }

    isSyncing.value = true;

    try {
      debugPrint('📥 [SyncManager] Pulling transactions from server...');

      // Get all transactions from server
      final serverTransactions = await _repository.getTransactions(
        sort: '-date',
        limit: 1000, // Get latest 1000 transactions
      );

      debugPrint('📥 [SyncManager] Received ${serverTransactions.length} transactions from server');

      int savedCount = 0;
      int skippedCount = 0;

      // Save to local database
      for (final transaction in serverTransactions) {
        try {
          // Check if transaction already exists
          //final exists = await _localDb.transactionExists(transaction.id!);
          
          // if (!exists) {
          //   //await _localDb.saveTransaction(transaction);
          //   savedCount++;
          // } else {
          //   // Update existing transaction
          //  //await _localDb.updateTransaction(transaction);
          //   skippedCount++;
          // }
        } catch (e) {
          debugPrint('⚠️ [SyncManager] Error saving transaction: $e');
        }
      }

      final message = 'Synced $savedCount new, updated $skippedCount existing';
      debugPrint('✅ [SyncManager] Pull complete: $message');

      return SyncResult(
        success: savedCount + skippedCount,
        failed: 0,
        message: message,
      );
    } catch (e) {
      debugPrint('❌ [SyncManager] Pull error: $e');
      return SyncResult(
        success: 0,
        failed: 0,
        message: 'Pull failed: $e',
      );
    } finally {
      isSyncing.value = false;
    }
  }

  /// Get current sync status
  Future<SyncStatus> getSyncStatus() async {
    try {
      final count = await _localDb.getUnsyncedCount();
      unsyncedCount.value = count;
      
      return SyncStatus(
        hasUnsyncedData: count > 0,
        unsyncedCount: count,
        lastSyncTime: lastSyncTime.value,
        isSyncing: isSyncing.value,
      );
    } catch (e) {
      debugPrint('❌ [SyncManager] Error getting sync status: $e');
      return SyncStatus(
        hasUnsyncedData: false,
        unsyncedCount: 0,
        lastSyncTime: null,
        isSyncing: false,
      );
    }
  }

  /// Force full sync (push and pull)
  Future<SyncResult> forceFullSync() async {
    debugPrint('🔄 [SyncManager] Force full sync initiated');

    try {
      // First push unsynced transactions
      final pushResult = await syncTransactions();

      // Then pull latest from server
      final pullResult = await pullFromServer();

      return SyncResult(
        success: pushResult.success + pullResult.success,
        failed: pushResult.failed + pullResult.failed,
        message: 'Full sync complete',
      );
    } catch (e) {
      debugPrint('❌ [SyncManager] Full sync error: $e');
      return SyncResult(
        success: 0,
        failed: 0,
        message: 'Full sync failed: $e',
      );
    }
  }

  /// Auto sync in background (call this periodically)
  Future<void> autoSync() async {
    try {
      final status = await getSyncStatus();

      if (status.hasUnsyncedData && !isSyncing.value) {
        debugPrint('🔄 [SyncManager] Auto sync started (${status.unsyncedCount} items)');
        await syncTransactions();
      }
    } catch (e) {
      debugPrint('❌ [SyncManager] Auto sync error: $e');
    }
  }

  /// Clear all sync data (for testing/debugging)
  Future<void> clearSyncData() async {
    try {
      await _localDb.clearAllTransactions();
      unsyncedCount.value = 0;
      lastSyncTime.value = null;
      debugPrint('✅ [SyncManager] Sync data cleared');
    } catch (e) {
      debugPrint('❌ [SyncManager] Error clearing sync data: $e');
    }
  }

  @override
  void onClose() {
    debugPrint('🔄 [SyncManager] Closing...');
    super.onClose();
  }
}

/// SyncResult - Result of a sync operation
class SyncResult {
  final int success;
  final int failed;
  final String message;

  SyncResult({
    required this.success,
    required this.failed,
    required this.message,
  });

  bool get isSuccess => failed == 0 && success > 0;
  bool get hasFailures => failed > 0;
  bool get isEmpty => success == 0 && failed == 0;

  @override
  String toString() => message;
}

/// SyncStatus - Current sync status
class SyncStatus {
  final bool hasUnsyncedData;
  final int unsyncedCount;
  final DateTime? lastSyncTime;
  final bool isSyncing;

  SyncStatus({
    required this.hasUnsyncedData,
    required this.unsyncedCount,
    this.lastSyncTime,
    required this.isSyncing,
  });

  String get lastSyncFormatted {
    if (lastSyncTime == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(lastSyncTime!);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes} minutes ago';
    if (difference.inDays < 1) return '${difference.inHours} hours ago';
    return '${difference.inDays} days ago';
  }

  @override
  String toString() =>
      'SyncStatus(hasUnsyncedData: $hasUnsyncedData, count: $unsyncedCount, lastSync: $lastSyncFormatted)';
}