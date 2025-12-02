import 'package:daftar/core/services/api_client.dart';
import 'package:dio/dio.dart';

/// EmailService - Handles sending emails via Base44
class EmailService {
  final Base44Client _client;

  EmailService(this._client);

  /// Send an email
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String body,
    String? from,
    List<String>? cc,
    List<String>? bcc,
    List<String>? attachments,
  }) async {
    try {
      final response = await _client.dio.post(
        '/api/integrations/Core/SendEmail',
        data: {
          'to': to,
          'subject': subject,
          'body': body,
          if (from != null) 'from': from,
          if (cc != null) 'cc': cc,
          if (bcc != null) 'bcc': bcc,
          if (attachments != null) 'attachments': attachments,
        },
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Failed to send email: ${e.message}');
    }
  }

  /// Send invoice via email
  Future<bool> sendInvoiceEmail({
    required String to,
    required String invoiceId,
    String? message,
  }) async {
    try {
      final response = await _client.dio.post(
        '/api/integrations/Core/SendEmail',
        data: {
          'to': to,
          'subject': 'Invoice #$invoiceId',
          'body': message ?? 'Please find your invoice attached.',
          'template': 'invoice',
          'invoice_id': invoiceId,
        },
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Failed to send invoice email: ${e.message}');
    }
  }

  /// Send report via email
  Future<bool> sendReportEmail({
    required String to,
    required String reportType,
    required String reportUrl,
    String? message,
  }) async {
    try {
      final response = await _client.dio.post(
        '/api/integrations/Core/SendEmail',
        data: {
          'to': to,
          'subject': 'Financial Report - $reportType',
          'body': message ?? 'Your financial report is attached.',
          'attachments': [reportUrl],
        },
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Failed to send report email: ${e.message}');
    }
  }
}
