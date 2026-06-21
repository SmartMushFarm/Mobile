import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../user/models/maintenance_ticket.dart';

class AdminMaintenanceService {
  final Dio _dio = ApiClient.instance;

  Future<List<MaintenanceTicket>> getAllRequests({String? status}) async {
    try {
      final response = await _dio.get('/admin/maintenance-requests', queryParameters: {
        if (status != null) 'status': status,
      });
      final List data = _extractList(response.data);
      return data.map((json) => MaintenanceTicket.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> approveRequest(int id) async {
    try {
      await _dio.put('/admin/maintenance-requests/$id/approve');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> scheduleRequest({
    required int id,
    required DateTime scheduledDate,
    required String adminNote,
    required int technicianId,
  }) async {
    try {
      await _dio.put('/admin/maintenance-requests/$id/schedule', data: {
        'scheduled_date': scheduledDate.toIso8601String(),
        'admin_note': adminNote,
        'technician_id': technicianId,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelRequest(int id, String adminNote) async {
    try {
      await _dio.put('/admin/maintenance-requests/$id/cancel', data: {
        'admin_note': adminNote,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmCompleted(int id) async {
    try {
      await _dio.put('/admin/maintenance-requests/$id/confirm-completed');
    } catch (e) {
      rethrow;
    }
  }

  List _extractList(dynamic responseData) {
    if (responseData is List) return responseData;
    if (responseData is Map) {
      if (responseData['data'] is List) return responseData['data'];
      for (var value in responseData.values) {
        if (value is List) return value;
      }
    }
    return [];
  }
}
