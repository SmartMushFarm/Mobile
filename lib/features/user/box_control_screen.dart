import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/box_tab_bar.dart';
import 'package:smartmush_farmer/core/widgets/device_control_card.dart';
import 'package:smartmush_farmer/features/user/services/device_service.dart';
import 'package:smartmush_farmer/features/user/widgets/box_page_header.dart';
import 'package:smartmush_farmer/features/user/widgets/box_screen_shell.dart';

class BoxControlScreen extends StatefulWidget {
  const BoxControlScreen({
    super.key,
    required this.boxId,
  });

  final String boxId;

  @override
  State<BoxControlScreen> createState() => _BoxControlScreenState();
}

class _BoxControlScreenState extends State<BoxControlScreen> {
  final DeviceService _deviceService = DeviceService();
  final Map<String, bool> _deviceStates = {
    'fan': false,
    'heater': false,
    'mist': false,
  };
  String _mode = 'Auto';
  String _boxName = 'Thiết bị';
  bool _isLoading = true;

  int? _presetId;

  @override
  void initState() {
    super.initState();
    _fetchDeviceStatus();
  }

  Future<void> _fetchDeviceStatus() async {
    setState(() => _isLoading = true);
    try {
      final List<dynamic> devices = await _deviceService.getMyDevices();
      final dynamic device = devices.firstWhere(
        (d) => d['id'].toString() == widget.boxId,
        orElse: () => null,
      );

      if (device != null) {
        setState(() {
          _boxName = device['device_name'] ?? 'Thiết bị';
          _mode = device['mode'] ?? 'Auto';
          
          final rawPresetId = device['preset_id'];
          _presetId = rawPresetId == null 
              ? null 
              : (rawPresetId is int ? rawPresetId : int.tryParse(rawPresetId.toString()));

          _deviceStates['fan'] = device['fan_status'] == 'on';
          _deviceStates['heater'] = device['heater_status'] == 'on';
          _deviceStates['mist'] = device['mist_status'] == 'on';
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  void _onTabSelected(BuildContext context, BoxTab tab) {
    switch (tab) {
      case BoxTab.overview:
        context.go('/box/overview', extra: widget.boxId);
      case BoxTab.control:
        break;
      case BoxTab.automation:
        context.push('/box/automation', extra: widget.boxId);
    }
  }

  Future<void> _toggleDevice(String key, bool value) async {
    if (_mode == 'Auto' && key != 'all') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chuyển sang chế độ Manual để điều khiển thủ công')),
      );
      return;
    }

    final String action = value ? 'on' : 'off';
    try {
      await _deviceService.controlDevice(
        deviceId: int.parse(widget.boxId),
        device: key,
        action: action,
      );
      setState(() {
        if (key == 'all') {
          _deviceStates.updateAll((k, v) => false);
        } else {
          _deviceStates[key] = value;
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã gửi lệnh điều khiển'), duration: Duration(seconds: 1)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  Future<void> _toggleMode() async {
    final newMode = _mode == 'Auto' ? 'Manual' : 'Auto';

    if (newMode == 'Auto' && _presetId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn một Preset trước khi sử dụng chế độ Auto'),
          backgroundColor: Colors.orange,
        ),
      );
      // Chuyển sang tab tự động để user chọn preset
      context.push('/box/automation', extra: widget.boxId);
      return;
    }

    try {
      await _deviceService.updateMode(
        deviceId: int.parse(widget.boxId),
        mode: newMode,
      );
      setState(() {
        _mode = newMode;
        if (newMode == 'Manual') {
          _presetId = null; // Backend tự động gán null khi sang Manual
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã chuyển sang chế độ $newMode')),
        );
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException && e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          errorMessage = data['message'];
        } else {
          errorMessage = data.toString();
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $errorMessage'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.loginBackground,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BoxScreenShell(
      boxId: widget.boxId,
      selectedTab: BoxTab.control,
      onTabSelected: (tab) => _onTabSelected(context, tab),
      header: BoxPageHeader(
        boxName: _boxName,
        statusLabel: 'Chế độ: $_mode',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionHeader(
                  title: 'Điều khiển thiết bị',
                  subtitle: _mode == 'Auto' ? 'Chế độ tự động đang chạy' : 'Quản lý thủ công',
                ),
                Switch(
                  value: _mode == 'Auto',
                  onChanged: (v) => _toggleMode(),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.05,
              children: [
                DeviceControlCard(
                  icon: Icons.air,
                  label: 'Quạt thông gió',
                  statusText: _deviceStates['fan']! ? 'BẬT' : 'TẮT',
                  isOn: _deviceStates['fan']!,
                  onToggle: (v) => _toggleDevice('fan', v),
                  subStatusText: _mode == 'Auto' ? 'Auto mode' : null,
                ),
                DeviceControlCard(
                  icon: Icons.water_drop,
                  label: 'Máy phun sương',
                  statusText: _deviceStates['mist']! ? 'BẬT' : 'TẮT',
                  isOn: _deviceStates['mist']!,
                  onToggle: (v) => _toggleDevice('mist', v),
                  subStatusText: _mode == 'Auto' ? 'Auto mode' : null,
                ),
                DeviceControlCard(
                  icon: Icons.wb_sunny,
                  label: 'Máy sưởi',
                  statusText: _deviceStates['heater']! ? 'BẬT' : 'TẮT',
                  isOn: _deviceStates['heater']!,
                  onToggle: (v) => _toggleDevice('heater', v),
                  subStatusText: _mode == 'Auto' ? 'Auto mode' : null,
                ),
                DeviceControlCard(
                  icon: Icons.power_off,
                  label: 'Tắt tất cả',
                  statusText: 'OFF',
                  isOn: false,
                  onToggle: (v) => _toggleDevice('all', false),
                  subStatusText: 'Chế độ an toàn',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _ManualOverrideNotice(isVisible: _mode == 'Manual'),
            const SizedBox(height: 24),
            _OpenAutomationButton(onTap: () => context.push('/box/automation', extra: widget.boxId)),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.splashTitle,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.loginLabel,
            ),
          ),
        ],
      ],
    );
  }
}

class _ManualOverrideNotice extends StatelessWidget {
  const _ManualOverrideNotice({required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFBDEFBE).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBDEFBE)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: 24,
            color: AppColors.loginLink,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Đang ở chế độ điều khiển thủ công. Tự động hóa sẽ không chạy.',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.loginLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OpenAutomationButton extends StatelessWidget {
  const _OpenAutomationButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x264CAF50),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          'Mở luật tự động hóa',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
