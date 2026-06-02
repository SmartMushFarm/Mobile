import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/auth_storage.dart';

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
      
      // Linh hoạt tìm token
      if (data['token'] != null) {
        token = data['token'];
      } else if (data['accessToken'] != null) {
        token = data['accessToken'];
      } else if (data['data'] != null) {
        if (data['data']['token'] != null) {
          token = data['data']['token'];
        } else if (data['data']['accessToken'] != null) {
          token = data['data']['accessToken'];
        }
      }

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

  static Future<bool> isLoggedIn() async {
    final token = await AuthStorage.getToken();
    return token != null && token.isNotEmpty;
  }
}
