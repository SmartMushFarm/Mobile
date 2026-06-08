import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/config/api_config.dart';
import '../../shop/models/order_model.dart';
import '../models/dashboard_stats_model.dart';
import '../../user/services/device_service.dart';

class AdminDashboardService {
  final DeviceService _deviceService = DeviceService();

  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      // 1. Fetch admin orders to calculate Orders Today
      final ordersResponse = await ApiClient.instance.get(ApiConfig.adminOrders);
      List ordersList = _extractList(ordersResponse.data);
      
      final orders = ordersList.map((json) => OrderModel.fromJson(json)).toList();
      
      final now = DateTime.now();
      final ordersTodayCount = orders.where((order) {
        final date = order.orderDate ?? order.createdAt;
        if (date == null) return false;
        final localDate = date.toLocal();
        return localDate.year == now.year && 
               localDate.month == now.month && 
               localDate.day == now.day;
      }).length;

      // 2. Fetch all devices count
      int activeDevices = 0;
      int offlineDevices = 0;
      try {
        final response = await ApiClient.instance.get('/devices');
        final List devices = _extractList(response.data);
        
        for (var d in devices) {
          final status = d['status']?.toString().toLowerCase();
          if (status == 'online' || status == 'active' || status == 'warning' || status == '1' || status == 'true') {
            activeDevices++;
          } else {
            offlineDevices++;
          }
        }
      } catch (e) {
        debugPrint('Error fetching devices for stats: $e');
      }
      
      return DashboardStatsModel(
        activeDevices: activeDevices,
        offlineDevices: offlineDevices,
        openTickets: 0,
        ordersToday: ordersTodayCount,
      );
    } catch (e) {
      debugPrint('AdminDashboardService.getDashboardStats Error: $e');
      rethrow;
    }
  }

  List _extractList(dynamic responseData) {
    if (responseData is List) return responseData;
    if (responseData is Map) {
      if (responseData['data'] is List) return responseData['data'];
      if (responseData['data'] is Map) {
        // Handle cases like {"data": {"orders": [...]}}
        final dataMap = responseData['data'] as Map;
        for (var value in dataMap.values) {
          if (value is List) return value;
        }
      }
      if (responseData['orders'] is List) return responseData['orders'];
      if (responseData['devices'] is List) return responseData['devices'];
      
      // Fallback: search for any list in the top level
      for (var value in responseData.values) {
        if (value is List) return value;
      }
    }
    return [];
  }
}
