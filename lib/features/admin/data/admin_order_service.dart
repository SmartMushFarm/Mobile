import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/config/api_config.dart';
import '../../shop/models/order_model.dart';

class AdminOrderService {
  final Dio _dio = ApiClient.instance;

  Future<List<OrderModel>> getAllOrders() async {
    try {
      final response = await _dio.get(ApiConfig.adminOrders);
      final data = response.data['data'] ?? response.data;
      if (data is List) {
        return data.map((json) => OrderModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('AdminOrderService getAllOrders Error: $e');
      rethrow;
    }
  }

  Future<void> updateOrderStatus({
    required int orderId,
    required String status,
  }) async {
    try {
      final response = await _dio.put(
        ApiConfig.updateOrderStatus(orderId),
        data: {'status': status},
      );
      // Even if success is not present, if no error it's likely okay
    } catch (e) {
      debugPrint('AdminOrderService updateOrderStatus Error: $e');
      rethrow;
    }
  }
}
