import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/network/api_client.dart';
import '../../../core/config/api_config.dart';
import '../models/product.dart';
import '../models/category_model.dart';

class ShopApiService {
  final Dio _dio = ApiClient.instance;

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get(ApiConfig.products);
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        return data.map((json) {
          try {
            return ProductModel.fromJson(json);
          } catch (e) {
            debugPrint('Error parsing product: $e, json: $json');
            rethrow;
          }
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint('ShopApiService getProducts Error: $e');
      rethrow;
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _dio.get(ApiConfig.productById(id));
      if (response.data['success'] == true) {
        return ProductModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to load product');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(ApiConfig.categories);
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Admin methods for Products
  Future<void> createProduct(Map<String, dynamic> data, XFile? imageFile) async {
    try {
      FormData formData = FormData.fromMap(data);
      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        formData.files.add(MapEntry(
          'image',
          MultipartFile.fromBytes(bytes, filename: 'product.jpg'),
        ));
      }
      await _dio.post(ApiConfig.products, data: formData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(int id, Map<String, dynamic> data, XFile? imageFile) async {
    try {
      FormData formData = FormData.fromMap(data);
      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        formData.files.add(MapEntry(
          'image',
          MultipartFile.fromBytes(bytes, filename: 'product.jpg'),
        ));
      }
      await _dio.put(ApiConfig.productById(id), data: formData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _dio.delete(ApiConfig.productById(id));
    } catch (e) {
      rethrow;
    }
  }

  // Admin methods for Categories
  Future<void> createCategory(Map<String, dynamic> data) async {
    try {
      await _dio.post(ApiConfig.categories, data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCategory(int id, Map<String, dynamic> data) async {
    try {
      await _dio.put(ApiConfig.categoryById(id), data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _dio.delete(ApiConfig.categoryById(id));
    } catch (e) {
      rethrow;
    }
  }
}
