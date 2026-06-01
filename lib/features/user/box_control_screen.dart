import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/box_tab_bar.dart';
import 'package:smartmush_farmer/core/widgets/device_control_card.dart';
import 'package:smartmush_farmer/features/user/data/mock_box_overview.dart';
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
  late final Map<String, bool> _deviceStates;
  late final Map<String, bool> _scheduleStates;
  bool _isManualOverride = false;

  @override
  void initState() {
    super.initState();
    final data = mockBoxOverviewFor(widget.boxId);
    final ledOn = data?.devices.ledOn ?? true;
    final fanOn = data?.devices.fanOn ?? true;
    _deviceStates = {
      'led': ledOn,
      'ventilationFan': fanOn,
      'mist': data?.devices.mistOn ?? false,
      'exhaustFan': false,
    };
    _scheduleStates = {
      'ledSchedule': true,
      'mistInterval': true,
      'fanAutoCycle': true,
    };
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

  void _toggleDevice(String key, bool value) {
    setState(() {
      _deviceStates[key] = value;
      if (value) {
        _isManualOverride = true;
      } else {
        final anyOn = _deviceStates.values.any((v) => v);
        _isManualOverride = anyOn;
      }
    });
  }

  void _toggleSchedule(String key, bool value) {
    setState(() {
      _scheduleStates[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = mockBoxOverviewFor(widget.boxId);

    if (data == null) {
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
      selectedTab: BoxTab.control,
      onTabSelected: (tab) => _onTabSelected(context, tab),
      header: BoxPageHeader(
        boxName: data.name,
        statusLabel: data.growStatusLabel,
      ),
      body: _ControlTabContent(
        deviceStates: _deviceStates,
        scheduleStates: _scheduleStates,
        isManualOverride: _isManualOverride,
        onToggleDevice: _toggleDevice,
        onToggleSchedule: _toggleSchedule,
        onOpenAutomation: () => context.push('/box/automation', extra: widget.boxId),
      ),
    );
  }
}

class _ControlTabContent extends StatelessWidget {
  const _ControlTabContent({
    required this.deviceStates,
    required this.scheduleStates,
    required this.isManualOverride,
    required this.onToggleDevice,
    required this.onToggleSchedule,
    required this.onOpenAutomation,
  });

  final Map<String, bool> deviceStates;
  final Map<String, bool> scheduleStates;
  final bool isManualOverride;
  final void Function(String, bool) onToggleDevice;
  final void Function(String, bool) onToggleSchedule;
  final VoidCallback onOpenAutomation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Điều khiển thiết bị',
          subtitle: 'Quản lý môi trường trồng thông minh',
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
              icon: Icons.wb_sunny,
              label: 'Đèn LED trồng',
              statusText: deviceStates['led']! ? 'BẬT' : 'TẮT',
              isOn: deviceStates['led']!,
              onToggle: (v) => onToggleDevice('led', v),
              subStatusText: deviceStates['led']! ? 'Độ sáng: 100%' : null,
            ),
            DeviceControlCard(
              icon: Icons.air,
              label: 'Quạt thông gió',
              statusText: deviceStates['ventilationFan']! ? 'BẬT' : 'TẮT',
              isOn: deviceStates['ventilationFan']!,
              onToggle: (v) => onToggleDevice('ventilationFan', v),
              subStatusText: deviceStates['ventilationFan']! ? 'Tốc độ: Trung bình' : null,
            ),
            DeviceControlCard(
              icon: Icons.water_drop,
              label: 'Hệ thống phun sương',
              statusText: deviceStates['mist']! ? 'BẬT' : 'TẮT',
              isOn: deviceStates['mist']!,
              onToggle: (v) => onToggleDevice('mist', v),
              subStatusText: deviceStates['mist']! ? null : 'Lần cuối: 12 phút trước',
            ),
            DeviceControlCard(
              icon: Icons.wind_power,
              label: 'Quạt hút',
              statusText: deviceStates['exhaustFan']! ? 'BẬT' : 'TẮT',
              isOn: deviceStates['exhaustFan']!,
              onToggle: (v) => onToggleDevice('exhaustFan', v),
              subStatusText: deviceStates['exhaustFan']! ? null : 'Chờ',
            ),
          ],
        ),
        const SizedBox(height: 24),
        _ManualOverrideNotice(isVisible: isManualOverride),
        const SizedBox(height: 24),
        _SectionHeader(
          title: 'Lịch trình',
          subtitle: null,
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.splashTrack),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A4CAF50),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _ScheduleItem(
                title: 'Lịch đèn LED',
                scheduleText: 'BẬT 06:00 \u2192 TẮT 18:00',
                isEnabled: scheduleStates['ledSchedule']!,
                onToggle: (v) => onToggleSchedule('ledSchedule', v),
                showDivider: true,
              ),
              _ScheduleItem(
                title: 'Khoảng phun sương',
                scheduleText: 'Mỗi 30 phút',
                isEnabled: scheduleStates['mistInterval']!,
                onToggle: (v) => onToggleSchedule('mistInterval', v),
                showDivider: true,
              ),
              _ScheduleItem(
                title: 'Chu kỳ quạt tự động',
                scheduleText: 'BẬT 5 phút mỗi giờ',
                isEnabled: scheduleStates['fanAutoCycle']!,
                onToggle: (v) => onToggleSchedule('fanAutoCycle', v),
                showDivider: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _OpenAutomationButton(onTap: onOpenAutomation),
      ],
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
              'Tự động hóa tạm dừng 30 phút do điều khiển thủ công.',
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

class _ScheduleItem extends StatelessWidget {
  const _ScheduleItem({
    required this.title,
    required this.scheduleText,
    required this.isEnabled,
    required this.onToggle,
    required this.showDivider,
  });

  final String title;
  final String scheduleText;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.splashTitle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scheduleText,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.loginLabel,
                      ),
                    ),
                  ],
                ),
              ),
              _InlineScheduleToggle(isOn: isEnabled, onToggle: onToggle),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.splashTrack,
          ),
      ],
    );
  }
}

class _InlineScheduleToggle extends StatelessWidget {
  const _InlineScheduleToggle({
    required this.isOn,
    required this.onToggle,
  });

  final bool isOn;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isOn),
      child: SizedBox(
        width: 52,
        height: 32,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: isOn
                      ? const Color(0xFF68D391)
                      : AppColors.splashTrack,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: isOn ? -4 : 0,
              right: isOn ? -4 : 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isOn ? AppColors.primary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isOn ? AppColors.primary : AppColors.splashTrack,
                    width: 4,
                  ),
                ),
                child: isOn
                    ? const Icon(
                        Icons.power_settings_new,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ],
        ),
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
