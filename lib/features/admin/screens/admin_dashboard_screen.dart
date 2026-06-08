import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/data/admin_dashboard_data.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_stat_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_action_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_notification_bell.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_bottom_nav.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';

import 'package:smartmush_farmer/features/admin/data/admin_dashboard_service.dart';
import 'package:smartmush_farmer/features/admin/models/dashboard_stats_model.dart';
import 'package:smartmush_farmer/features/auth/models/user_model.dart';
import 'package:smartmush_farmer/features/user/services/device_service.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_device_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminDashboardService _dashboardService = AdminDashboardService();
  final DeviceService _deviceService = DeviceService();
  UserModel? _admin;
  DashboardStatsModel? _stats;
  List<dynamic> _realtimeDevices = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        AuthService.fetchMe(),
        _dashboardService.getDashboardStats(),
        _deviceService.getAllDevices(),
      ]);
      setState(() {
        _admin = results[0] as UserModel;
        _stats = results[1] as DashboardStatsModel;
        _realtimeDevices = results[2] as List<dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load dashboard data. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_error!, style: const TextStyle(color: Colors.red)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadDashboard,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadDashboard,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                _buildStatGrid(),
                                const SizedBox(height: 24),
                                _buildRealtimeDevices(),
                                const SizedBox(height: 24),
                                _buildCriticalAlerts(),
                                const SizedBox(height: 24),
                                _buildMaintenanceSummary(),
                                const SizedBox(height: 24),
                                _buildManagementActions(),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
    );
  }

  Widget _buildHeader(BuildContext context) {
    String initials = "A";
    if (_admin?.name != null && _admin!.name!.isNotEmpty) {
      initials = _admin!.name![0].toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.eco, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SmartFarm Admin',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          AdminNotificationBell(badgeCount: 3),
          const SizedBox(width: 8),
          _DashboardHeaderButton(
            icon: Icons.logout,
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Đăng xuất'),
                  content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await AuthService.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              }
            },
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.go('/admin/profile'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatGrid() {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      children: [
        AdminStatCard(
          label: 'Active Devices',
          value: '${_stats?.activeDevices ?? 0}',
          icon: Icons.sensors,
          color: const Color(0xFF10B981),
        ),
        AdminStatCard(
          label: 'Offline Devices',
          value: '${_stats?.offlineDevices ?? 0}',
          icon: Icons.sensors_off,
          color: const Color(0xFFEF4444),
        ),
        AdminStatCard(
          label: 'Open Tickets',
          value: '${_stats?.openTickets ?? 0}',
          icon: Icons.confirmation_number,
          color: const Color(0xFFF59E0B),
        ),
        AdminStatCard(
          label: 'Orders Today',
          value: '${_stats?.ordersToday ?? 0}',
          icon: Icons.shopping_cart,
          color: const Color(0xFF3B82F6),
        ),
      ],
    );
  }

  Widget _buildRealtimeDevices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Realtime Device Monitoring',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/admin/devices'),
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_realtimeDevices.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'No realtime devices available',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ..._realtimeDevices.take(3).map((d) {
            final statusStr = d['status']?.toString().toLowerCase();
            final status = (statusStr == 'online' || statusStr == 'active')
                ? DeviceStatus.online
                : statusStr == 'warning'
                    ? DeviceStatus.warning
                    : DeviceStatus.offline;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AdminDeviceCard(
                deviceId: int.tryParse(d['id'].toString()) ?? 0,
                name: d['device_name'] ?? d['name'] ?? 'Device',
                status: status,
                lastSync: d['last_sync'] ?? d['updated_at'] ?? 'Just now',
                temperature: (d['current_temperature'] ?? 0).toDouble(),
                humidity: (d['current_humidity'] ?? 0).toDouble(),
                alert: d['alert'],
                co2: d['co2'] != null ? (d['co2'] as num).toInt() : null,
                actions: const ['details'],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildCriticalAlerts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Critical Alerts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'No critical alerts',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaintenanceSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Maintenance Summary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              _buildMaintenanceItem(
                'Pending',
                '0',
                AppColors.warning,
              ),
              _buildMaintenanceDivider(),
              _buildMaintenanceItem(
                'Assigned',
                '0',
                const Color(0xFF0EA5E9),
              ),
              _buildMaintenanceDivider(),
              _buildMaintenanceItem(
                'Done Today',
                '0',
                AppColors.success,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMaintenanceItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceDivider() {
    return Container(
      width: 1,
      height: 50,
      color: AppColors.border,
    );
  }

  Widget _buildManagementActions() {
    final actions = AdminDashboardData.actions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Management Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.95,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return AdminActionCard(
              label: action['label'] as String,
              icon: _iconFromString(action['icon'] as String),
              route: action['route'] as String,
            );
          },
        ),
      ],
    );
  }

  IconData _iconFromString(String name) {
    switch (name) {
      case 'sensors':
        return Icons.sensors;
      case 'sensors_off':
        return Icons.sensors_off;
      case 'confirmation_number':
        return Icons.confirmation_number;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'inventory_2':
        return Icons.inventory_2;
      case 'category':
        return Icons.category;
      case 'receipt_long':
        return Icons.receipt_long;
      case 'people':
        return Icons.people;
      case 'system_update':
        return Icons.system_update;
      case 'notifications':
        return Icons.notifications;
      default:
        return Icons.circle;
    }
  }
}

class _DashboardHeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardHeaderButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.metricIconBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 22),
      ),
    );
  }
}
