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

      final data = response.data['data'] ?? response.data;
      return OrderModel.fromJson(data);
    } catch (e) {
      debugPrint('OrderApiService checkout Error: $e');
      rethrow;
    }
  }

  Future<List<OrderModel>> getMyOrders() async {
    try {
      final response = await _dio.get(ApiConfig.myOrders);
      final data = response.data['data'] ?? response.data;
      if (data is List) {
        return data.map((json) => OrderModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('OrderApiService getMyOrders Error: $e');
      rethrow;
    }
  }

  Future<OrderModel> getOrderDetail(int id) async {
    try {
      final response = await _dio.get(ApiConfig.orderById(id));
      final data = response.data['data'] ?? response.data;
      return OrderModel.fromJson(data);
    } catch (e) {
      debugPrint('OrderApiService getOrderDetail Error: $e');
      rethrow;
    }
  }

  Future<void> cancelOrder(int id) async {
    try {
      await _dio.put(ApiConfig.cancelOrder(id));
    } catch (e) {
      debugPrint('OrderApiService cancelOrder Error: $e');
      rethrow;
    }
  }

  Future<void> updateOrderStatus({required int orderId, required String status}) async {
    try {
      await _dio.put(ApiConfig.updateOrderStatus(orderId), data: {'status': status});
    } catch (e) {
      debugPrint('OrderApiService updateOrderStatus Error: $e');
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
