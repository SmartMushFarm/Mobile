import '../../../core/network/api_client.dart';

class PresetService {
  Future<List<dynamic>> getPresets({int? userId}) async {
    try {
      final response = await ApiClient.instance.get(
        '/presets',
        queryParameters: userId != null ? {'userId': userId} : null,
      );
      return response.data['data'] as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createPreset(Map<String, dynamic> data) async {
    try {
      await ApiClient.instance.post('/presets', data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePreset({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await ApiClient.instance.put('/presets/$id', data: data);
    } catch (e) {
      rethrow;
    }
  }
}
