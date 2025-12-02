/// ApiResponse - Generic response wrapper for API responses
/// Handles both single items and list responses
class ApiResponse<T> {
  final List<T>? data;
  final T? singleData;
  final int? total;
  final int? limit;
  final int? offset;
  final bool? hasMore;

  ApiResponse({
    this.data,
    this.singleData,
    this.total,
    this.limit,
    this.offset,
    this.hasMore,
  });

  /// Create from JSON response
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    if (json.containsKey('data') && json['data'] is List) {
      // List response
      return ApiResponse<T>(
        data: (json['data'] as List)
            .map((item) => fromJsonT(item as Map<String, dynamic>))
            .toList(),
        total: json['total'],
        limit: json['limit'],
        offset: json['offset'],
        hasMore: json['has_more'],
      );
    } else {
      // Single item response
      return ApiResponse<T>(
        singleData: fromJsonT(json),
      );
    }
  }

  /// Check if response has data
  bool get hasData => (data != null && data!.isNotEmpty) || singleData != null;

  /// Get the count of items
  int get count => data?.length ?? (singleData != null ? 1 : 0);
}

/// ApiError - Error response model
class ApiError {
  final String error;
  final String message;
  final int code;
  final Map<String, dynamic>? details;

  ApiError({
    required this.error,
    required this.message,
    required this.code,
    this.details,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      error: json['error'] ?? 'UnknownError',
      message: json['message'] ?? 'An unknown error occurred',
      code: json['code'] ?? 500,
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'code': code,
      if (details != null) 'details': details,
    };
  }

  @override
  String toString() => 'ApiError: $message (Code: $code)';
}

/// PaginatedResponse - For paginated API responses
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      items: (json['items'] as List)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['page_size'] ?? 10,
      hasMore: json['has_more'] ?? false,
    );
  }

  /// Calculate total pages
  int get totalPages => (total / pageSize).ceil();

  /// Check if there is a next page
  bool get hasNextPage => hasMore || page < totalPages;

  /// Check if there is a previous page
  bool get hasPreviousPage => page > 1;
}
