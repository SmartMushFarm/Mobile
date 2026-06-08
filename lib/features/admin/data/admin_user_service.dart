import '../../../core/network/api_client.dart';
import '../../../core/config/api_config.dart';
import '../../auth/models/user_model.dart';

class AdminUserService {
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await ApiClient.instance.get(ApiConfig.authUsers);
      final List data = (response.data['data'] != null && response.data['data'] is List) 
          ? response.data['data'] 
          : (response.data is List ? response.data : []);
      
      return data.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
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
