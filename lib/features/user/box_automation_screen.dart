import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/box_tab_bar.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';
import 'package:smartmush_farmer/features/user/services/device_service.dart';
import 'package:smartmush_farmer/features/user/services/preset_service.dart';
import 'package:smartmush_farmer/features/user/widgets/box_page_header.dart';
import 'package:smartmush_farmer/features/user/widgets/box_screen_shell.dart';
import 'package:smartmush_farmer/features/user/create_preset_screen.dart';

class BoxAutomationScreen extends StatefulWidget {
  const BoxAutomationScreen({
    super.key,
    required this.boxId,
  });

  final String boxId;

  @override
  State<BoxAutomationScreen> createState() => _BoxAutomationScreenState();
}

class _BoxAutomationScreenState extends State<BoxAutomationScreen> {
  final PresetService _presetService = PresetService();
  final DeviceService _deviceService = DeviceService();

  List<dynamic> _presets = [];
  bool _isLoadingPresets = true;
  String _boxName = 'Thiết bị';
  String _growStatus = 'Đang hoạt động';
  int? _activePresetId;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Khởi tạo timer load data mỗi 5s
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _loadData(showLoading: false);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData({bool showLoading = true}) async {
    if (!mounted) return;
    if (showLoading) {
      setState(() => _isLoadingPresets = true);
    }
    try {
      final user = await AuthService.getCurrentUser();
      final role = user?['role']?.toString().toLowerCase();

      final presets = await _presetService.getPresets();
      
      List<dynamic> devices;
      if (role == 'admin') {
        devices = await _deviceService.getAllDevices();
      } else {
        devices = await _deviceService.getMyDevices();
      }

      final device = devices.firstWhere((d) => d['id'].toString() == widget.boxId, orElse: () => null);

      if (mounted) {
        setState(() {
          _presets = presets;
          if (device != null) {
            _boxName = device['device_name'] ?? 'Thiết bị';
            _growStatus = 'Chế độ: ${device['mode'] ?? 'Auto'}';
            
            final rawActivePresetId = device['preset_id'];
            _activePresetId = rawActivePresetId == null 
                ? null 
                : (rawActivePresetId is int ? rawActivePresetId : int.tryParse(rawActivePresetId.toString()));
          }
          _isLoadingPresets = false;
        });
      }
    } catch (e) {
      if (mounted) {
        if (showLoading) {
          setState(() => _isLoadingPresets = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
          );
        }
      }
    }
  }

  Future<void> _applyPreset(int presetId) async {
    final oldActivePresetId = _activePresetId;
    final oldGrowStatus = _growStatus;

    // Optimistic UI update
    setState(() {
      _activePresetId = presetId;
      _growStatus = 'Chế độ: Auto'; // Applying preset usually forces Auto mode
    });

    try {
      await _deviceService.applyPreset(
        deviceId: int.parse(widget.boxId),
        presetId: presetId,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã áp dụng Preset thành công!'),
            backgroundColor: AppColors.primary,
          ),
        );
        // Silent refresh to sync data
        _loadData(showLoading: false);
      }
    } catch (e) {
      if (mounted) {
        // Rollback
        setState(() {
          _activePresetId = oldActivePresetId;
          _growStatus = oldGrowStatus;
        });

        String errorMessage = e.toString();
        if (e is DioException && e.response != null && e.response?.data != null) {
          final data = e.response?.data;
          if (data is Map && data.containsKey('message')) {
            errorMessage = data['message'];
          } else {
            errorMessage = data.toString();
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi áp dụng preset: $errorMessage'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _onTabSelected(BuildContext context, BoxTab tab) {
    switch (tab) {
      case BoxTab.overview:
        context.go('/box/overview', extra: widget.boxId);
      case BoxTab.control:
        context.push('/box/control', extra: widget.boxId);
      case BoxTab.automation:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BoxScreenShell(
      boxId: widget.boxId,
      selectedTab: BoxTab.automation,
      onTabSelected: (tab) => _onTabSelected(context, tab),
      header: BoxPageHeader(
        boxName: _boxName,
        statusLabel: _growStatus,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _PresetSection(
              presets: _presets,
              activePresetId: _activePresetId,
              isLoading: _isLoadingPresets,
              onApply: _applyPreset,
              onCreateNew: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePresetScreen()),
              ).then((value) {
                if (value == true) _loadData();
              }),
              onEditPreset: (preset) => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePresetScreen(preset: preset)),
              ).then((value) {
                if (value == true) _loadData();
              }),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _PresetSection extends StatelessWidget {
  const _PresetSection({
    required this.presets,
    this.activePresetId,
    required this.isLoading,
    required this.onApply,
    required this.onCreateNew,
    required this.onEditPreset,
  });

  final List<dynamic> presets;
  final int? activePresetId;
  final bool isLoading;
  final Function(int) onApply;
  final VoidCallback onCreateNew;
  final Function(Map<String, dynamic>) onEditPreset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cấu hình nuôi trồng (Presets)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.splashTitle,
                  ),
                ),
                Text(
                  'Chọn cấu hình tối ưu cho từng loại nấm',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.loginLabel,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: onCreateNew,
              icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 32),
              tooltip: 'Tạo Preset mới',
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (presets.isEmpty)
          const Text('Chưa có preset nào.')
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: presets.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final preset = presets[index];
              final rawPresetId = preset['id'];
              final presetId = rawPresetId is int ? rawPresetId : int.tryParse(rawPresetId.toString()) ?? 0;
              
              return _PresetCard(
                preset: preset,
                isActive: activePresetId == presetId,
                onApply: () => onApply(presetId),
                onEdit: () => onEditPreset(Map<String, dynamic>.from(preset)),
              );
            },
          ),
      ],
    );
  }
}

class _PresetCard extends StatelessWidget {
  const _PresetCard({required this.preset, required this.isActive, required this.onApply, required this.onEdit});

  final dynamic preset;
  final bool isActive;
  final VoidCallback onApply;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final bool isRecommended = preset['is_recommended'] == true || preset['is_recommended'] == 1;

    return GestureDetector(
      onTap: onEdit,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.primary : (isRecommended ? AppColors.primary.withOpacity(0.5) : AppColors.loginInputBorder),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    preset['preset_name'] ?? 'Không tên',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isRecommended)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Gợi ý',
                      style: TextStyle(color: AppColors.primary, fontSize: 10),
                    ),
                  ),
                if (isActive)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                  ),
                const SizedBox(width: 8),
                const Icon(Icons.edit_outlined, size: 20, color: AppColors.loginHint),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Loại nấm: ${preset['mushroom_type'] ?? 'Chưa xác định'}',
              style: const TextStyle(color: AppColors.loginLabel, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _ThresholdBadge(label: 'Ẩm', value: '${preset['mist_on_humidity']}-${preset['mist_off_humidity']}%', icon: Icons.water_drop),
                _ThresholdBadge(label: 'Nhiệt', value: '${preset['heater_on_temp']}-${preset['heater_off_temp']}°C', icon: Icons.thermostat),
              ],
            ),
            if (preset['description'] != null && preset['description'].toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                preset['description'],
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isActive)
                  ElevatedButton(
                    onPressed: onApply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Áp dụng'),
                  )
                else
                  const Text('Đang áp dụng', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ThresholdBadge extends StatelessWidget {
  const _ThresholdBadge({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.loginLabel),
          const SizedBox(width: 4),
          Text('$label: $value', style: const TextStyle(fontSize: 11, color: AppColors.loginLabel)),
        ],
      ),
    );
  }
}
