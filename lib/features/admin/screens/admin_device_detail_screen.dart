import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/user/services/device_service.dart';

class AdminDeviceDetailScreen extends StatefulWidget {
  const AdminDeviceDetailScreen({super.key, required this.deviceId});

  final String deviceId;

  @override
  State<AdminDeviceDetailScreen> createState() => _AdminDeviceDetailScreenState();
}

class _AdminDeviceDetailScreenState extends State<AdminDeviceDetailScreen> {
  final DeviceService _deviceService = DeviceService();
  Map<String, dynamic>? _device;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() => _isLoading = true);
    try {
      final devices = await _deviceService.getAllDevices();
      final found = devices.firstWhere(
        (d) => d['id'].toString() == widget.deviceId,
        orElse: () => null,
      );
      setState(() {
        _device = found;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Chi tiết thiết bị (Admin)', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 18)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _device == null
              ? const Center(child: Text('Không tìm thấy thông tin thiết bị'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoSection(
                        title: 'Thông tin cơ bản',
                        icon: Icons.info_outline,
                        items: [
                          _InfoItem('ID hệ thống', _device!['id'].toString()),
                          _InfoItem('Tên thiết bị', _device!['device_name'] ?? 'Chưa đặt tên'),
                          _InfoItem('Trạng thái', _device!['status']?.toString().toUpperCase() ?? 'N/A'),
                          _InfoItem('Mã kích hoạt (Claim Code)', _device!['claim_code'] ?? 'Chưa tạo', isHighlight: true),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoSection(
                        title: 'Chủ sở hữu',
                        icon: Icons.person_outline,
                        items: [
                          _InfoItem('ID chủ sở hữu', _device!['user_id']?.toString() ?? 'Chưa có'),
                          _InfoItem('Tên chủ sở hữu', _device!['user_name'] ?? _device!['owner_name'] ?? 'Chưa có'),
                          _InfoItem('Email liên kết', _device!['user_email'] ?? 'N/A'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoSection(
                        title: 'Cấu hình vận hành',
                        icon: Icons.settings_outlined,
                        items: [
                          _InfoItem('Chế độ hoạt động', _device!['mode'] ?? 'Auto'),
                          _InfoItem('ID Preset đang dùng', _device!['preset_id']?.toString() ?? 'Không sử dụng'),
                          _InfoItem('Tên Preset', _device!['preset_name'] ?? 'N/A'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoSection(
                        title: 'Thông số kỹ thuật hiện tại',
                        icon: Icons.sensors,
                        items: [
                          _InfoItem('Nhiệt độ', '${_device!['current_temperature'] ?? 0}°C'),
                          _InfoItem('Độ ẩm', '${_device!['current_humidity'] ?? 0}%'),
                          _InfoItem('Trạng thái Quạt', _device!['fan_status']?.toString().toUpperCase() ?? 'OFF'),
                          _InfoItem('Trạng thái Phun sương', _device!['mist_status']?.toString().toUpperCase() ?? 'OFF'),
                          _InfoItem('Trạng thái Sưởi', _device!['heater_status']?.toString().toUpperCase() ?? 'OFF'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoSection(
                        title: 'Thời gian',
                        icon: Icons.access_time,
                        items: [
                          _InfoItem('Ngày tạo', _device!['created_at'] ?? 'N/A'),
                          _InfoItem('Cập nhật cuối', _device!['updated_at'] ?? 'N/A'),
                        ],
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoSection({required String title, required IconData icon, required List<Widget> items}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...items,
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _InfoItem(this.label, this.value, {this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.inter(
                color: isHighlight ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
