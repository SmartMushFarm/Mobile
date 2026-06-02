import '../../../core/network/api_client.dart';

class HistoryService {
  Future<List<dynamic>> getHistoryByDeviceId({
    required int deviceId,
    int limit = 20,
  }) async {
    try {
      final response = await ApiClient.instance.get(
        '/history/device/$deviceId',
        queryParameters: {'limit': limit},
      );
      return response.data['data'] as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getLatestHistoryByDeviceId(int deviceId) async {
    try {
      // Thử gọi API latest nếu có
      try {
        final response = await ApiClient.instance.get('/history/device/$deviceId/latest');
        if (response.data['data'] != null) {
          return response.data['data'] as Map<String, dynamic>;
        }
      } catch (_) {
        // Nếu không có API latest, lấy list limit 1
      }

      final history = await getHistoryByDeviceId(deviceId: deviceId, limit: 1);
      if (history.isNotEmpty) {
        return history.first as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
