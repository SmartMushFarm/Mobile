import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/config/api_config.dart';
import '../models/promotion_model.dart';

class AdminPromotionService {
  final Dio _dio = ApiClient.instance;

  Future<List<PromotionModel>> getAllPromotions() async {
    try {
      final response = await _dio.get(ApiConfig.promotions);
      debugPrint('Promotions Response: ${response.data}');
      final List data = _extractList(response.data);
      return data.map((json) => PromotionModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('AdminPromotionService getAllPromotions Error: $e');
      rethrow;
    }
  }

  Future<PromotionModel> createPromotion(PromotionModel promotion) async {
    try {
      final response = await _dio.post(ApiConfig.promotions, data: promotion.toJson());
      return PromotionModel.fromJson(response.data);
    } catch (e) {
      debugPrint('AdminPromotionService createPromotion Error: $e');
      rethrow;
    }
  }

  Future<PromotionModel> updatePromotion(int id, PromotionModel promotion) async {
    try {
      final response = await _dio.put(ApiConfig.promotionById(id), data: promotion.toJson());
      return PromotionModel.fromJson(response.data);
    } catch (e) {
      debugPrint('AdminPromotionService updatePromotion Error: $e');
      rethrow;
    }
  }

  Future<void> deletePromotion(int id) async {
    try {
      await _dio.delete(ApiConfig.promotionById(id));
    } catch (e) {
      debugPrint('AdminPromotionService deletePromotion Error: $e');
      rethrow;
    }
  }

  List _extractList(dynamic responseData) {
    if (responseData is List) return responseData;
    if (responseData is Map) {
      if (responseData['data'] is List) return responseData['data'];
      if (responseData['promotions'] is List) return responseData['promotions'];
      for (var value in responseData.values) {
        if (value is List) return value;
      }
    }
    return [];
  }
}
