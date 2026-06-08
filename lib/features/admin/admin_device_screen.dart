import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/data/admin_device_monitoring_data.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_device_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_device_filter_chip.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_bottom_nav.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_notification_bell.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';
import 'package:smartmush_farmer/features/user/services/device_service.dart';

class AdminDeviceScreen extends StatefulWidget {
  const AdminDeviceScreen({super.key});

  @override
  State<AdminDeviceScreen> createState() => _AdminDeviceScreenState();
}

class _AdminDeviceScreenState extends State<AdminDeviceScreen> {
  final DeviceService _deviceService = DeviceService();
  String _selectedFilter = 'All Devices';
  List<dynamic> _allDevices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  Future<void> _fetchDevices() async {
    setState(() => _isLoading = true);
    try {
      final devices = await _deviceService.getAllDevices();
      setState(() {
        _allDevices = devices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải danh sách thiết bị: $e')),
        );
      }
    }
  }

  List<dynamic> get _filteredDevices {
    switch (_selectedFilter) {
      case 'Online':
        return _allDevices.where((d) => d['status'] == 'Online' || d['status'] == 'Active').toList();
      case 'Offline':
        return _allDevices.where((d) => d['status'] == 'Offline').toList();
      case 'Warning':
        return _allDevices.where((d) => d['status'] == 'Warning').toList();
      default:
        return _allDevices;
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
              child: RefreshIndicator(
                onRefresh: _fetchDevices,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _buildStats(),
                            const SizedBox(height: 16),
                            _buildFilterChips(),
                            const SizedBox(height: 16),
                            _buildDeviceList(),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Add device coming soon'),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 1),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                  'SmartMush Admin',
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
          _HeaderIconButton(
            icon: Icons.search,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _HeaderIconButton(
            icon: Icons.tune,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          AdminNotificationBell(badgeCount: 3),
          const SizedBox(width: 8),
          _HeaderIconButton(
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
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'A',
                  style: TextStyle(
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

  Widget _buildStats() {
    final online = _allDevices.where((d) => d['status'] == 'Online' || d['status'] == 'Active').length;
    final offline = _allDevices.where((d) => d['status'] == 'Offline').length;
    final warning = _allDevices.where((d) => d['status'] == 'Warning').length;

    return Row(
      children: [
        Expanded(child: _buildStatChip('Online', '$online', AppColors.success)),
        const SizedBox(width: 8),
        Expanded(child: _buildStatChip('Offline', '$offline', const Color(0xFF9CA3AF))),
        const SizedBox(width: 8),
        Expanded(child: _buildStatChip('Warning', '$warning', AppColors.warning)),
        const SizedBox(width: 8),
        Expanded(child: _buildStatChip('Total', '${_allDevices.length}', AppColors.primary)),
      ],
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: AdminDeviceMonitoringData.filterOptions.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AdminDeviceFilterChip(
              label: filter,
              isActive: _selectedFilter == filter,
              onTap: () => setState(() => _selectedFilter = filter),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDeviceList() {
    final devices = _filteredDevices;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Monitoring',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (devices.isEmpty)
          const Center(child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Không có thiết bị nào'),
          )),
        ...devices.map((d) {
          final statusStr = d['status']?.toString();
          final status = (statusStr == 'Online' || statusStr == 'Active')
              ? DeviceStatus.online
              : statusStr == 'Offline'
                  ? DeviceStatus.offline
                  : statusStr == 'Warning'
                      ? DeviceStatus.warning
                      : DeviceStatus.offline;
          
          return AdminDeviceCard(
            deviceId: int.tryParse(d['id'].toString()) ?? 0,
            name: d['device_name'] ?? d['name'] ?? 'Thiết bị',
            status: status,
            lastSync: d['last_sync'] ?? d['updated_at'] ?? 'Vừa xong',
            alert: d['alert'],
            temperature: (d['current_temperature'] ?? 0).toDouble(),
            humidity: (d['current_humidity'] ?? 0).toDouble(),
            co2: d['co2'] != null ? (d['co2'] as num).toInt() : null,
            actions: const ['claim_code', 'restart', 'details'],
          );
        }),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({
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
