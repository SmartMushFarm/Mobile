import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/box_tab_bar.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';
import 'package:smartmush_farmer/features/user/models/box_overview_data.dart';
import 'package:smartmush_farmer/features/user/services/device_service.dart';
import 'package:smartmush_farmer/features/user/services/history_service.dart';
import 'package:smartmush_farmer/features/user/widgets/box_overview_tab_content.dart';
import 'package:smartmush_farmer/features/user/widgets/box_page_header.dart';
import 'package:smartmush_farmer/features/user/widgets/box_screen_shell.dart';

class BoxOverviewScreen extends StatefulWidget {
  const BoxOverviewScreen({
    super.key,
    required this.boxId,
  });

  final String boxId;

  @override
  State<BoxOverviewScreen> createState() => _BoxOverviewScreenState();
}

class _BoxOverviewScreenState extends State<BoxOverviewScreen> {
  final DeviceService _deviceService = DeviceService();
  final HistoryService _historyService = HistoryService();
  BoxOverviewData? _data;
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchBoxData();
    // Khởi tạo timer load data mỗi 5s
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchBoxData(showLoading: false);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  bool _isStatusOn(dynamic value) {
    if (value == null) return false;
    final s = value.toString().toLowerCase();
    return s == 'on' || s == '1' || s == 'true' || s == 'active';
  }

  Future<void> _fetchBoxData({bool showLoading = true}) async {
    if (!mounted) return;
    if (showLoading) {
      setState(() => _isLoading = true);
    }
    try {
      final user = await AuthService.getCurrentUser();
      final role = user?['role']?.toString().toLowerCase();
      
      List<dynamic> devices;
      if (role == 'admin') {
        devices = await _deviceService.getAllDevices();
      } else {
        devices = await _deviceService.getMyDevices();
      }

      final dynamic device = devices.firstWhere(
        (d) => d['id'].toString() == widget.boxId,
        orElse: () => null,
      );

      if (device != null) {
        // Fetch history for chart
        final List<dynamic> historyData = await _historyService.getHistoryByDeviceId(
          deviceId: int.parse(widget.boxId),
          limit: 20,
        );

        final List<double> tempTrend = historyData
            .map((h) => (h['temperature'] ?? 0.0).toDouble())
            .toList()
            .cast<double>()
            .toList();
        final List<double> humTrend = historyData
            .map((h) => (h['humidity'] ?? 0.0).toDouble())
            .toList()
            .cast<double>()
            .toList();

        // Lấy 5 cái mới nhất (nằm ở cuối list) để hiện lên đầu danh sách logs
        final List<ActivityLogEntry> logs = historyData.reversed.take(5).map((h) {
          final time = DateTime.tryParse(h['created_at'] ?? '') ?? DateTime.now();
          return ActivityLogEntry(
            timeLabel: '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
            message: 'Nhiệt độ: ${h['temperature']}°C, Độ ẩm: ${h['humidity']}%',
          );
        }).toList();

        if (mounted) {
          setState(() {
            _data = BoxOverviewData(
              id: device['id'].toString(),
              name: device['device_name'] ?? 'Thiết bị',
              growStatusLabel: 'Đang hoạt động - ${device['mode'] ?? 'Auto'}',
              sensors: BoxSensorReading(
                temperatureCelsius: (device['current_temperature'] ?? 0).toInt(),
                temperatureTrend: tempTrend.isNotEmpty ? tempTrend.last - (tempTrend.length > 1 ? tempTrend[tempTrend.length - 2] : tempTrend.last) : 0.0,
                humidityPercent: (device['current_humidity'] ?? 0).toInt(),
                co2Ppm: 450,
                co2LevelProgress: 0.45,
                substrateMoisturePercent: 65,
              ),
              devices: BoxDeviceState(
                ledOn: false,
                fanOn: _isStatusOn(device['fan_status']),
                mistOn: _isStatusOn(device['mist_status']),
                heaterOn: _isStatusOn(device['heater_status']),
              ),
              temperatureTrend: tempTrend,
              humidityTrend: humTrend,
              activityLogs: logs,
            );
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
        );
      }
    }
  }

  void _onTabSelected(BuildContext context, BoxTab tab) {
    switch (tab) {
      case BoxTab.overview:
        break;
      case BoxTab.control:
        context.push('/box/control', extra: widget.boxId);
      case BoxTab.automation:
        context.push('/box/automation', extra: widget.boxId);
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

    if (_data == null) {
      return Scaffold(
        backgroundColor: AppColors.loginBackground,
        appBar: AppBar(
          backgroundColor: AppColors.loginBackground,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.loginLabel),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Text(
            'Không tìm thấy hộp',
            style: GoogleFonts.inter(textStyle: AppTextStyles.loginSubtitle),
          ),
        ),
      );
    }

    return BoxScreenShell(
      boxId: widget.boxId,
      selectedTab: BoxTab.overview,
      onTabSelected: (tab) => _onTabSelected(context, tab),
      header: BoxPageHeader(
        boxName: _data!.name,
        statusLabel: _data!.growStatusLabel,
      ),
      body: BoxOverviewTabContent(data: _data!),
    );
  }
}
