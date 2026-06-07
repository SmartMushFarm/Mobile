import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/data/admin_device_monitoring_data.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_device_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_device_filter_chip.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_bottom_nav.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_notification_bell.dart';

class AdminDeviceScreen extends StatefulWidget {
  const AdminDeviceScreen({super.key});

  @override
  State<AdminDeviceScreen> createState() => _AdminDeviceScreenState();
}

class _AdminDeviceScreenState extends State<AdminDeviceScreen> {
  String _selectedFilter = 'All Devices';

  List<Map<String, dynamic>> get _filteredDevices {
    final all = AdminDeviceMonitoringData.devices;
    switch (_selectedFilter) {
      case 'Online':
        return all.where((d) => d['status'] == 'online' || d['status'] == 'warning').toList();
      case 'Offline':
        return all.where((d) => d['status'] == 'offline').toList();
      case 'Warning':
        return all.where((d) => d['status'] == 'warning').toList();
      default:
        return all;
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
              child: SingleChildScrollView(
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
    final all = AdminDeviceMonitoringData.devices;
    final online = all.where((d) => d['status'] == 'online' || d['status'] == 'warning').length;
    final offline = all.where((d) => d['status'] == 'offline').length;
    final warning = all.where((d) => d['status'] == 'warning').length;

    return Row(
      children: [
        Expanded(child: _buildStatChip('Online', '$online', AppColors.success)),
        const SizedBox(width: 8),
        Expanded(child: _buildStatChip('Offline', '$offline', const Color(0xFF9CA3AF))),
        const SizedBox(width: 8),
        Expanded(child: _buildStatChip('Warning', '$warning', AppColors.warning)),
        const SizedBox(width: 8),
        Expanded(child: _buildStatChip('Total', '${all.length}', AppColors.primary)),
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
        ...devices.map((d) {
          final statusStr = d['status'] as String;
          final status = statusStr == 'offline'
              ? DeviceStatus.offline
              : statusStr == 'warning'
                  ? DeviceStatus.warning
                  : DeviceStatus.online;
          return AdminDeviceCard(
            name: d['name'] as String,
            status: status,
            lastSync: d['lastSync'] as String,
            alert: d['alert'] as String?,
            temperature: d['temperature'] as double?,
            humidity: d['humidity'] as double?,
            co2: d['co2'] as int?,
            actions: List<String>.from(d['actions'] as List),
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
