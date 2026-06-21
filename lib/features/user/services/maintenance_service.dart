import '../../../core/network/api_client.dart';
import '../models/maintenance_ticket.dart';

class MaintenanceService {
  Future<List<MaintenanceTicket>> getMyRequests() async {
    try {
      final response = await ApiClient.instance.get('/maintenance-requests/my-requests');
      final dynamic data = response.data;
      
      List list = [];
      if (data is List) {
        list = data;
      } else if (data is Map && data['data'] is List) {
        list = data['data'];
      }
      
      return list.map((json) => MaintenanceTicket.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createRequest({
    required int deviceId,
    required String title,
    required String description,
  }) async {
    try {
      await ApiClient.instance.post('/maintenance-requests', data: {
        'device_id': deviceId,
        'title': title,
        'description': description,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelRequest(int id) async {
    try {
      await ApiClient.instance.put('/maintenance-requests/$id/cancel');
    } catch (e) {
      rethrow;
    }
  }
}
