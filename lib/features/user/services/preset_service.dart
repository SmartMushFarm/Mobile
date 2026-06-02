import '../../../core/network/api_client.dart';

class PresetService {
  Future<List<dynamic>> getPresets() async {
    try {
      final response = await ApiClient.instance.get('/presets');
      final data = response.data;
      if (data is List) {
        return data;
      } else if (data is Map && data['data'] is List) {
        return data['data'];
      }
      return [];
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

  Future<void> deletePreset(int id) async {
    try {
      await ApiClient.instance.delete('/presets/$id');
    } catch (e) {
      rethrow;
    }
  }
}
