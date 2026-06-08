import 'package:dio/dio.dart';
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
        return data.map((json) => ProductModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
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

  // Admin methods
  Future<void> createProduct(Map<String, dynamic> data, dynamic imageFile) async {
    try {
      FormData formData = FormData.fromMap(data);
      if (imageFile != null) {
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(imageFile.path, filename: 'product.jpg'),
        ));
      }
      await _dio.post(ApiConfig.products, data: formData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(int id, Map<String, dynamic> data, dynamic imageFile) async {
    try {
      FormData formData = FormData.fromMap(data);
      if (imageFile != null) {
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(imageFile.path, filename: 'product.jpg'),
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
}
