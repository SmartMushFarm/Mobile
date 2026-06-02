import '../../../core/network/api_client.dart';

class DeviceService {
  Future<List<dynamic>> getMyDevices() async {
    try {
      final response = await ApiClient.instance.get('/devices/my-devices');
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

  Future<void> controlDevice({
    required int deviceId,
    required String device,
    required String action,
  }) async {
    try {
      await ApiClient.instance.post('/devices/$deviceId/control', data: {
        'device': device,
        'action': action,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMode({
    required int deviceId,
    required String mode,
  }) async {
    try {
      // mode: "Auto" | "Manual"
      await ApiClient.instance.put('/devices/$deviceId/mode', data: {
        'mode': mode,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> applyPreset({
    required int deviceId,
    required int presetId,
  }) async {
    try {
      await ApiClient.instance.put('/devices/$deviceId/apply-preset/$presetId');
    } catch (e) {
      rethrow;
    }
  }
}
