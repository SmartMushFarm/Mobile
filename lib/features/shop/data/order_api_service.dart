import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/config/api_config.dart';
import '../models/order_model.dart';

class OrderApiService {
  final Dio _dio = ApiClient.instance;

  Future<OrderModel> checkout({
    required String shippingAddress,
    String? paymentMethod = 'COD',
    int? promotionId,
  }) async {
    try {
      final response = await _dio.post(ApiConfig.checkout, data: {
        'shipping_address': shippingAddress,
        'payment_method': paymentMethod,
        if (promotionId != null) 'promotion_id': promotionId,
      });

      if (response.data['success'] == true) {
        return OrderModel.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Checkout failed');
    } catch (e) {
      debugPrint('OrderApiService checkout Error: $e');
      rethrow;
    }
  }

  Future<List<OrderModel>> getAdminOrders() async {
    try {
      final response = await _dio.get(ApiConfig.adminOrders);
      if (response.data['success'] == true) {
        final List data = response.data['data'] ?? [];
        return data.map((json) => OrderModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('OrderApiService getAdminOrders Error: $e');
      rethrow;
    }
  }
}
