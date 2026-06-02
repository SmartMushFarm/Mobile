import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

class DeviceService {
  Future<List<dynamic>> getMyDevices() async {
    try {
      final response = await ApiClient.instance.get('/devices/my-devices');
      return response.data['data'] as List<dynamic>;
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

  Future<void> updatePreset({
    required int deviceId,
    required int presetId,
  }) async {
    try {
      await ApiClient.instance.put('/devices/$deviceId/preset', data: {
        'presetId': presetId,
      });
    } catch (e) {
      rethrow;
    }
  }
}
