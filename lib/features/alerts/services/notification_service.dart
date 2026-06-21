import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';

class NotificationService {
  final Dio _dio = ApiClient.instance;

  Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int limit = 10,
    bool unreadOnly = false,
  }) async {
    try {
      final response = await _dio.get('/notifications', queryParameters: {
        'page': page,
        'limit': limit,
        'unreadOnly': unreadOnly,
      });
      return response.data;
    } catch (e) {
      debugPrint('NotificationService getNotifications Error: $e');
      rethrow;
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get('/notifications/unread-count');
      final data = response.data;
      
      if (data is Map) {
        if (data.containsKey('unreadCount')) return int.tryParse(data['unreadCount'].toString()) ?? 0;
        if (data['data'] is Map && data['data'].containsKey('unreadCount')) {
          return int.tryParse(data['data']['unreadCount'].toString()) ?? 0;
        }
        if (data.containsKey('count')) return int.tryParse(data['count'].toString()) ?? 0;
      }
      return 0;
    } catch (e) {
      debugPrint('NotificationService getUnreadCount Error: $e');
      return 0;
    }
  }

  Future<Map<String, dynamic>> getNotificationById(int id) async {
    try {
      final response = await _dio.get('/notifications/$id');
      if (response.data is Map && response.data.containsKey('data')) {
        return response.data['data'];
      }
      return response.data;
    } catch (e) {
      debugPrint('NotificationService getNotificationById Error: $e');
      rethrow;
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _dio.put('/notifications/$id/read');
    } catch (e) {
      debugPrint('NotificationService markAsRead Error: $e');
      rethrow;
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _dio.put('/notifications/read-all');
    } catch (e) {
      debugPrint('NotificationService markAllAsRead Error: $e');
      rethrow;
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      await _dio.delete('/notifications/$id');
    } catch (e) {
      debugPrint('NotificationService deleteNotification Error: $e');
      rethrow;
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      await _dio.delete('/notifications/delete-all');
    } catch (e) {
      debugPrint('NotificationService deleteAllNotifications Error: $e');
      rethrow;
    }
  }

  Future<void> createNotification({
    required int userId,
    int? deviceId,
    required String type,
    required String title,
    required String message,
  }) async {
    try {
      await _dio.post('/notifications', data: {
        'user_id': userId,
        'device_id': deviceId,
        'type': type,
        'title': title,
        'message': message,
      });
    } catch (e) {
      debugPrint('NotificationService createNotification Error: $e');
      rethrow;
    }
  }

  Future<void> batchCreateNotifications({
    required List<int> userIds,
    int? deviceId,
    required String type,
    required String title,
    required String message,
  }) async {
    try {
      await _dio.post('/notifications/batch-create', data: {
        'user_ids': userIds,
        'device_id': deviceId,
        'type': type,
        'title': title,
        'message': message,
      });
    } catch (e) {
      debugPrint('NotificationService batchCreateNotifications Error: $e');
      rethrow;
    }
  }
}
