import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/data/admin_alerts_data.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_alert_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_alert_filter_chip.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_alert_stats_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_notification_bell.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_bottom_nav.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_severity_badge.dart';
import 'package:smartmush_farmer/features/auth/models/user_model.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';

class AdminAlertsScreen extends StatefulWidget {
  const AdminAlertsScreen({super.key});

  @override
  State<AdminAlertsScreen> createState() => _AdminAlertsScreenState();
}

class _AdminAlertsScreenState extends State<AdminAlertsScreen> {
  String _selectedFilter = 'All';
  UserModel? _admin;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final user = await AuthService.fetchMe();
      setState(() {
        _admin = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredAlerts {
    final all = AdminAlertsData.alerts;
    switch (_selectedFilter) {
      case 'Critical':
        return all.where((a) => a['severity'] == 'critical').toList();
      case 'Warning':
        return all.where((a) => a['severity'] == 'warning').toList();
      case 'Resolved':
        return all.where((a) => a['severity'] == 'success').toList();
      default:
        return all;
    }
  }

  int get _unresolvedCount {
    return AdminAlertsData.alerts
        .where((a) => a['isResolved'] == false)
        .length;
  }

  void _showAssignTechDialog(String alertId, String device) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Create maintenance ticket?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'A technician will be assigned to investigate the issue on "$device".',
          style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showSnackBar('Maintenance ticket created');
              context.go('/admin/tickets');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildFilterChips(),
                    const SizedBox(height: 16),
                    _buildAlertList(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: -1),
    );
  }

  Widget _buildHeader() {
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
            child: Text(
              'Alerts Center',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ),
          AdminNotificationBell(badgeCount: _unresolvedCount),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textPrimary),
            onPressed: () async {
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

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: AdminAlertsData.filterOptions.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AdminAlertFilterChip(
              label: filter,
              isActive: _selectedFilter == filter,
              onTap: () => setState(() => _selectedFilter = filter),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAlertList() {
    final alerts = _filteredAlerts;
    final stats = AdminAlertsData.stats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AdminAlertStatsCard(
                title: '24H ALERT VOLUME',
                value: stats['alertVolumeChange'] as String,
                subtitle: '+12% vs yesterday',
                barHeights: const [0.4, 0.6, 0.5, 0.8, 0.7, 1.0, 0.9],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AdminAlertStatsCard(
                title: 'MEAN TIME TO RESOLVE',
                value: stats['meanTimeToResolve'] as String,
                subtitle: stats['meanTimeNote'] as String,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Alert List',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 12),
        if (alerts.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 48,
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No alerts',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...alerts.map((a) {
            return AdminAlertCard(
              device: a['device'] as String,
              time: a['time'] as String,
              title: a['title'] as String,
              description: a['description'] as String,
              severity: _severityFromString(a['severity'] as String),
              buttons: List<String>.from(a['buttons'] as List),
              onResolve: () => _showSnackBar('Alert marked as resolved'),
              onAssignTech: () => _showAssignTechDialog(
                a['id'] as String,
                a['device'] as String,
              ),
              onArchive: () => _showSnackBar('Notification archived'),
            );
          }),
      ],
    );
  }

  AlertSeverity _severityFromString(String s) {
    switch (s) {
      case 'critical':
        return AlertSeverity.critical;
      case 'warning':
        return AlertSeverity.warning;
      case 'success':
        return AlertSeverity.success;
      default:
        return AlertSeverity.warning;
    }
  }
}
