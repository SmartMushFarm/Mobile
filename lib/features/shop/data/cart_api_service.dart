import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/config/api_config.dart';
import '../models/cart_model.dart';

class CartApiService {
  final Dio _dio = ApiClient.instance;

  Future<CartModel?> getCart() async {
    try {
      final response = await _dio.get(ApiConfig.cart);
      if (response.data['success'] == true) {
        return CartModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      debugPrint('CartApiService getCart Error: $e');
      rethrow;
    }
  }

  Future<void> addItemToCart({required int productId, required int quantity}) async {
    try {
      await _dio.post(ApiConfig.cartItems, data: {
        'product_id': productId,
        'quantity': quantity,
      });
    } catch (e) {
      debugPrint('CartApiService addItemToCart Error: $e');
      rethrow;
    }
  }

  Future<void> updateCartItemQuantity({required int cartItemId, required int quantity}) async {
    try {
      await _dio.put(ApiConfig.cartItemById(cartItemId), data: {
        'quantity': quantity,
      });
    } catch (e) {
      debugPrint('CartApiService updateCartItemQuantity Error: $e');
      rethrow;
    }
  }

  Future<void> removeCartItem(int cartItemId) async {
    try {
      await _dio.delete(ApiConfig.cartItemById(cartItemId));
    } catch (e) {
      debugPrint('CartApiService removeCartItem Error: $e');
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      await _dio.delete(ApiConfig.clearCart);
    } catch (e) {
      debugPrint('CartApiService clearCart Error: $e');
      rethrow;
    }
  }
}
