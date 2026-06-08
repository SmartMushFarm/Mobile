import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/auth_storage.dart';
import '../../../core/config/api_config.dart';
import '../models/user_model.dart';

class AuthService {
  static Future<Response> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await ApiClient.instance.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'address': address,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.instance.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final data = response.data;
      String? token;
      
      // Linh hoạt tìm token với mọi biến thể
      final Map<String, dynamic> searchSource = (data is Map && data.containsKey('data')) ? data['data'] : data;
      
      token = searchSource['token'] ?? 
              searchSource['accessToken'] ?? 
              searchSource['access_token'] ??
              data['token'] ?? 
              data['accessToken'] ?? 
              data['access_token'];

      if (token != null) {
        await AuthStorage.saveToken(token);
      }

      // Linh hoạt tìm user
      Map<String, dynamic>? user;
      if (data['user'] != null && data['user'] is Map) {
        user = Map<String, dynamic>.from(data['user']);
      } else if (data['data'] != null && data['data'] is Map) {
        if (data['data']['user'] != null && data['data']['user'] is Map) {
          user = Map<String, dynamic>.from(data['data']['user']);
        } else {
          // Trường hợp data['data'] chính là user object
          user = Map<String, dynamic>.from(data['data']);
        }
      }

      if (user != null) {
        await AuthStorage.saveUser(user);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> logout() async {
    await AuthStorage.clear();
  }

  static Future<Map<String, dynamic>?> getCurrentUser() async {
    return await AuthStorage.getUser();
  }

  static Future<UserModel> fetchMe() async {
    try {
      final response = await ApiClient.instance.get(ApiConfig.authMe);
      final user = UserModel.fromJson(response.data);
      await AuthStorage.saveUser(user.toJson());
      return user;
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserModel> updateMe({
    required String name,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await ApiClient.instance.put(ApiConfig.authMe, data: {
        'name': name,
        'phone': phone,
        'address': address,
      });
      final user = UserModel.fromJson(response.data);
      await AuthStorage.saveUser(user.toJson());
      return user;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await ApiClient.instance.put(ApiConfig.authChangePassword, data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> isLoggedIn() async {
    final token = await AuthStorage.getToken();
    return token != null && token.isNotEmpty;
  }
}
