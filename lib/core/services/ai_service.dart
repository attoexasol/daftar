import 'package:daftar/core/services/api_client.dart';
import 'package:dio/dio.dart';

/// AIService - Handles AI-powered features via Base44
class AIService {
  final Base44Client _client;

  AIService(this._client);

  /// Invoke LLM (Large Language Model) for AI text generation
  Future<String> invokeLLM({
    required String prompt,
    Map<String, dynamic>? context,
    int maxTokens = 500,
    double temperature = 0.7,
  }) async {
    try {
      final response = await _client.dio.post(
        '/api/integrations/Core/InvokeLLM',
        data: {
          'prompt': prompt,
          if (context != null) 'context': context,
          'max_tokens': maxTokens,
          'temperature': temperature,
        },
      );

      return response.data['response'];
    } on DioException catch (e) {
      throw Exception('Failed to invoke LLM: ${e.message}');
    }
  }

  /// Generate image using AI
  Future<String> generateImage({
    required String prompt,
    String style = 'professional',
    String size = '1024x1024',
  }) async {
    try {
      final response = await _client.dio.post(
        '/api/integrations/Core/GenerateImage',
        data: {
          'prompt': prompt,
          'style': style,
          'size': size,
        },
      );

      return response.data['image_url'];
    } on DioException catch (e) {
      throw Exception('Failed to generate image: ${e.message}');
    }
  }

  /// Get AI insights for financial data
  Future<Map<String, dynamic>> getFinancialInsights({
    required List<Map<String, dynamic>> transactions,
    String? dateRange,
  }) async {
    try {
      final response = await _client.dio.post(
        '/api/integrations/Core/InvokeLLM',
        data: {
          'prompt': '''
Analyze these financial transactions and provide insights:
${transactions.map((t) => '- ${t['type']}: ${t['amount']} AED on ${t['date']}').join('\n')}

Provide:
1. Spending trends
2. Budget recommendations
3. Potential savings
4. Financial health score (0-100)
''',
          'context': {
            'transactions': transactions,
            'date_range': dateRange,
          },
          'max_tokens': 1000,
          'temperature': 0.3, // Lower temperature for more factual responses
        },
      );

      return {
        'insights': response.data['response'],
        'raw_response': response.data,
      };
    } on DioException catch (e) {
      throw Exception('Failed to get financial insights: ${e.message}');
    }
  }
}
