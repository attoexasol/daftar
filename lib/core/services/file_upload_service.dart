import 'dart:io';
import 'package:daftar/core/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

/// FileUploadService - Handles file uploads to Base44
class FileUploadService {
  final Base44Client _client;

  FileUploadService(this._client);

  /// Upload a file and return the URL
  Future<String> uploadFile(File file) async {
    try {
      String fileName = file.path.split('/').last;
      String? mimeType = lookupMimeType(file.path);

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ),
      });

      final response = await _client.dio.post(
        '/api/integrations/Core/UploadFile',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
        onSendProgress: (sent, total) {
          final progress = (sent / total * 100).toStringAsFixed(0);
          print('📤 Upload progress: $progress%');
        },
      );

      return response.data['file_url'];
    } on DioException catch (e) {
      throw Exception('Failed to upload file: ${e.message}');
    }
  }

  /// Extract data from uploaded file
  Future<Map<String, dynamic>> extractDataFromFile({
    required String fileUrl,
    required String dataType,
    Map<String, dynamic>? schema,
  }) async {
    try {
      final response = await _client.dio.post(
        '/api/integrations/Core/ExtractDataFromUploadedFile',
        data: {
          'file_url': fileUrl,
          'data_type': dataType,
          if (schema != null) 'schema': schema,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to extract data: ${e.message}');
    }
  }
}
