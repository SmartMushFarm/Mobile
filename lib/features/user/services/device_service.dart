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

  Future<List<dynamic>> getAllDevices() async {
    try {
      final response = await ApiClient.instance.get('/devices');
      return _extractList(response.data);
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

  // --- New APIs ---

  /// Admin - Generate claim code for a device
  Future<String> generateClaimCode(int deviceId) async {
    try {
      final response = await ApiClient.instance.post('/devices/$deviceId/generate-claim-code');
      // Assume backend returns the code in response.data['claim_code'] or response.data['data']['claim_code']
      final data = response.data;
      if (data is Map) {
        if (data['claim_code'] != null) return data['claim_code'].toString();
        if (data['data'] != null && data['data']['claim_code'] != null) {
          return data['data']['claim_code'].toString();
        }
      }
      return "";
    } catch (e) {
      rethrow;
    }
  }

  /// User - Claim a device using claim code
  Future<void> claimDevice(String claimCode) async {
    try {
      await ApiClient.instance.post('/devices/claim', data: {
        'claimCode': claimCode,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Remove device owner (unbind device from account)
  Future<void> removeOwner(int deviceId) async {
    try {
      await ApiClient.instance.put('/devices/$deviceId/remove-owner');
    } catch (e) {
      rethrow;
    }
  }
}
