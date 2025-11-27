/// User Model
/// Represents authenticated user data from Base44 API
class UserModel {
  final String? id;
  final String? email;
  final String? fullName;
  final String? role;
  final String? organizationId;
  final String? organizationName;
  final String? phone;
  final String? avatar;
  final bool? isActive;
  final bool? emailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;

  UserModel({
    this.id,
    this.email,
    this.fullName,
    this.role,
    this.organizationId,
    this.organizationName,
    this.phone,
    this.avatar,
    this.isActive,
    this.emailVerified,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? json['_id'] as String?,
      email: json['email'] as String?,
      fullName: json['full_name'] as String? ??
          json['fullName'] as String? ??
          json['name'] as String?,
      role: json['role'] as String?,
      organizationId: json['organization_id'] as String? ??
          json['organizationId'] as String?,
      organizationName: json['organization_name'] as String? ??
          json['organizationName'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String? ?? json['avatar_url'] as String?,
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool? ?? true,
      emailVerified: json['email_verified'] as bool? ??
          json['emailVerified'] as bool? ??
          false,
      createdAt: _parseDateTime(json['created_at'] ?? json['createdAt']),
      updatedAt: _parseDateTime(json['updated_at'] ?? json['updatedAt']),
      lastLoginAt: _parseDateTime(
          json['last_login_at'] ?? json['lastLoginAt'] ?? json['last_login']),
    );
  }

  /// Parse DateTime from various formats
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    try {
      if (value is String) {
        return DateTime.parse(value);
      } else if (value is int) {
        // Unix timestamp
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role,
      'organization_id': organizationId,
      'organization_name': organizationName,
      'phone': phone,
      'avatar': avatar,
      'is_active': isActive,
      'email_verified': emailVerified,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  /// Create copy with modified fields
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? role,
    String? organizationId,
    String? organizationName,
    String? phone,
    String? avatar,
    bool? isActive,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      organizationId: organizationId ?? this.organizationId,
      organizationName: organizationName ?? this.organizationName,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      isActive: isActive ?? this.isActive,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  /// Check if user is super admin
  bool get isSuperAdmin =>
      role?.toLowerCase() == 'super_admin' ||
      role?.toLowerCase() == 'superadmin';

  /// Check if user is admin (admin or super_admin)
  bool get isAdmin =>
      role?.toLowerCase() == 'admin' ||
      role?.toLowerCase() == 'super_admin' ||
      role?.toLowerCase() == 'superadmin';

  /// Check if user is owner
  bool get isOwner => role?.toLowerCase() == 'owner';

  /// Check if user is manager
  bool get isManager => role?.toLowerCase() == 'manager';

  /// Check if user is accountant
  bool get isAccountant => role?.toLowerCase() == 'accountant';

  /// Check if user has administrative privileges
  bool get hasAdminPrivileges => isAdmin || isOwner;

  /// Get user display name (fullName or email)
  String get displayName => fullName ?? email ?? 'User';

  /// Get first name from full name
  String? get firstName {
    if (fullName == null || fullName!.isEmpty) return null;
    final names = fullName!.split(' ');
    return names.isNotEmpty ? names.first : null;
  }

  /// Get last name from full name
  String? get lastName {
    if (fullName == null || fullName!.isEmpty) return null;
    final names = fullName!.split(' ');
    return names.length > 1 ? names.last : null;
  }

  /// Get user initials for avatar (1-2 characters)
  String get initials {
    if (fullName != null && fullName!.isNotEmpty) {
      final names = fullName!.trim().split(' ');
      if (names.length >= 2) {
        return '${names[0][0]}${names[1][0]}'.toUpperCase();
      }
      return fullName![0].toUpperCase();
    }

    if (email != null && email!.isNotEmpty) {
      return email![0].toUpperCase();
    }

    return 'D'; // Default to 'D' for Daftar
  }

  /// Get avatar URL or placeholder
  String get avatarUrl {
    if (avatar != null && avatar!.isNotEmpty) {
      return avatar!;
    }

    // Return a placeholder avatar URL (you can use a service like ui-avatars.com)
    final name = (fullName ?? email ?? 'User').replaceAll(' ', '+');
    return 'https://ui-avatars.com/api/?name=$name&background=random&size=200';
  }

  /// Check if user account is complete (has all required info)
  bool get isProfileComplete {
    return email != null &&
        fullName != null &&
        phone != null &&
        organizationName != null;
  }

  /// Get user age in days
  int? get accountAgeInDays {
    if (createdAt == null) return null;
    return DateTime.now().difference(createdAt!).inDays;
  }

  /// Check if user is new (less than 7 days old)
  bool get isNewUser {
    final age = accountAgeInDays;
    return age != null && age < 7;
  }

  /// Get formatted last login time
  String? get formattedLastLogin {
    if (lastLoginAt == null) return null;

    final now = DateTime.now();
    final difference = now.difference(lastLoginAt!);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return lastLoginAt!.toString().split(' ')[0]; // Return date only
    }
  }

  /// Check if user is valid
  bool get isValid {
    return id != null && email != null && isActive == true;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, fullName: $fullName, role: $role, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
