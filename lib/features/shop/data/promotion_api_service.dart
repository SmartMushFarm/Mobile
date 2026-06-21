import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../admin/models/promotion_model.dart';

class PromotionApiService {
  final Dio _dio = ApiClient.instance;

  Future<PromotionModel?> checkPromotion(String code) async {
    try {
      final response = await _dio.get('/promotions/code/$code');
      final dynamic responseData = response.data;
      
      if (responseData != null && responseData['success'] == true) {
        final data = responseData['data'] ?? responseData;
        return PromotionModel.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('PromotionApiService checkPromotion Error: $e');
      return null;
    }
  }
}
