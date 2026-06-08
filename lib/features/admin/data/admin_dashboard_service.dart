import '../../../core/network/api_client.dart';
import '../../../core/config/api_config.dart';
import '../../shop/models/order_model.dart';
import '../models/dashboard_stats_model.dart';

class AdminDashboardService {
  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      // Fetch admin orders to calculate Orders Today
      final response = await ApiClient.instance.get(ApiConfig.adminOrders);
      final List data = (response.data['data'] != null && response.data['data'] is List) 
          ? response.data['data'] 
          : (response.data is List ? response.data : []);
      
      final orders = data.map((json) => OrderModel.fromJson(json)).toList();
      
      final now = DateTime.now();
      final ordersToday = orders.where((order) {
        final date = order.orderDate ?? order.createdAt;
        if (date == null) return false;
        final localDate = date.toLocal();
        return localDate.year == now.year && 
               localDate.month == now.month && 
               localDate.day == now.day;
      }).length;

      // Note: If you have real device/ticket APIs, fetch them here.
      // For now, following instructions to show 0/NA if no real API exists.
      
      return DashboardStatsModel(
        activeDevices: 0, // Placeholder
        offlineDevices: 0, // Placeholder
        openTickets: 0, // Placeholder
        ordersToday: ordersToday,
      );
    } catch (e) {
      rethrow;
    }
  }
}
