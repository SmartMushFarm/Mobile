import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/config/api_config.dart';
import '../models/payment_model.dart';

class PaymentApiService {
  final Dio _dio = ApiClient.instance;

  Future<PaymentModel> createPayment({
    required int orderId,
    required String paymentMethod,
  }) async {
    try {
      final response = await _dio.post(ApiConfig.paymentsCreate, data: {
        'order_id': orderId,
        'payment_method': paymentMethod,
      });

      final data = response.data['data'] ?? response.data;
      return PaymentModel.fromJson(data);
    } catch (e) {
      debugPrint('PaymentApiService createPayment Error: $e');
      rethrow;
    }
  }

  Future<PaymentModel?> getPaymentByOrderId(int orderId) async {
    try {
      final response = await _dio.get(ApiConfig.paymentByOrderId(orderId));
      final data = response.data['data'] ?? response.data;
      if (data != null && data is Map<String, dynamic>) {
        return PaymentModel.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('PaymentApiService getPaymentByOrderId Error: $e');
      return null;
    }
  }

  Future<PaymentModel> confirmPayment(int paymentId) async {
    try {
      final response = await _dio.put(ApiConfig.paymentConfirm(paymentId));
      final data = response.data['data'] ?? response.data;
      return PaymentModel.fromJson(data);
    } catch (e) {
      debugPrint('PaymentApiService confirmPayment Error: $e');
      rethrow;
    }
  }
}
