import '../../../core/network/api_client.dart';
import '../../../core/config/api_config.dart';
import '../../auth/models/user_model.dart';

class AdminUserService {
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await ApiClient.instance.get(ApiConfig.authUsers);
      final List data = _extractList(response.data);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  List<dynamic> _extractList(dynamic responseData) {
    if (responseData is List) return responseData;
    if (responseData is Map) {
      if (responseData['data'] is List) return responseData['data'];
      if (responseData['data'] is Map) {
        final dataMap = responseData['data'] as Map;
        for (var value in dataMap.values) {
          if (value is List) return value;
        }
      }
      for (var value in responseData.values) {
        if (value is List) return value;
      }
    }
    return [];
  }

  Future<UserModel> updateUser({
    required int id,
    required String name,
    String? phone,
    String? address,
  }) async {
    try {
      final response = await ApiClient.instance.put(ApiConfig.authUserById(id), data: {
        'name': name,
        'phone': phone,
        'address': address,
      });
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserStatus({
    required int id,
    required String status,
  }) async {
    try {
      await ApiClient.instance.put(ApiConfig.authUserStatus(id), data: {
        'status': status,
      });
    } catch (e) {
      rethrow;
    }
  }
}
