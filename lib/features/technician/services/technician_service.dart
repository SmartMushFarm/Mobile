import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../user/models/maintenance_ticket.dart';

class TechnicianService {
  final Dio _dio = ApiClient.instance;

  Future<List<MaintenanceTicket>> getMyTasks() async {
    try {
      final response = await _dio.get('/technician/maintenance-tasks');
      final dynamic data = response.data;
      
      List list = [];
      if (data is List) {
        list = data;
      } else if (data is Map && data['data'] is List) {
        list = data['data'];
      } else if (data is Map) {
        // Fallback for different response structures
        for (var value in data.values) {
          if (value is List) {
            list = value;
            break;
          }
        }
      }
      
      return list.map((json) => MaintenanceTicket.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> requestCompletion({
    required int id,
    required String technicianNote,
  }) async {
    try {
      await _dio.put('/technician/maintenance-tasks/$id/request-completion', data: {
        'technician_note': technicianNote,
      });
    } catch (e) {
      rethrow;
    }
  }
}
