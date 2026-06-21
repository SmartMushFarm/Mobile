import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/rule_dropdown_field.dart';
import 'package:smartmush_farmer/core/widgets/rule_preview_card.dart';
import 'package:smartmush_farmer/core/widgets/selectable_device_chip.dart';

enum SensorType { humidity, temperature, co2, time }

enum LogicType { dropsBelow, risesAbove, equals }

enum TargetDevice { mister, exhaustFan, ledGrowLight, ventilationFan }

class AddAutomationRuleScreen extends StatefulWidget {
  const AddAutomationRuleScreen({
    super.key,
    required this.boxId,
  });

  final String boxId;

  @override
  State<AddAutomationRuleScreen> createState() => _AddAutomationRuleScreenState();
}

class _AddAutomationRuleScreenState extends State<AddAutomationRuleScreen> {
  SensorType _sensorType = SensorType.humidity;
  LogicType _logicType = LogicType.dropsBelow;
  final _thresholdController = TextEditingController(text: '75');
  TargetDevice _targetDevice = TargetDevice.mister;
  bool _deviceStateOn = false;

  String get _logicLabel {
    switch (_logicType) {
      case LogicType.dropsBelow:
        return '<';
      case LogicType.risesAbove:
        return '>';
      case LogicType.equals:
        return '=';
    }
  }

  String get _thresholdUnit {
    switch (_sensorType) {
      case SensorType.humidity:
        return '%';
      case SensorType.temperature:
        return '\u00B0C';
      case SensorType.co2:
        return ' ppm';
      case SensorType.time:
        return '';
    }
  }

  String get _sensorLabelVi {
    switch (_sensorType) {
      case SensorType.humidity:
        return 'Độ ẩm';
      case SensorType.temperature:
        return 'Nhiệt độ';
      case SensorType.co2:
        return 'CO2';
      case SensorType.time:
        return 'Giờ';
    }
  }

  String get _ifPreview {
    final threshold = _thresholdController.text.trim();
    if (_sensorType == SensorType.time) {
      return 'Lúc $threshold';
    }
    return '$_sensorLabelVi $_logicLabel $threshold$_thresholdUnit';
  }

  String _deviceLabelVi(TargetDevice d) {
    switch (d) {
      case TargetDevice.mister:
        return 'Phun sương';
      case TargetDevice.exhaustFan:
        return 'Quạt hút';
      case TargetDevice.ledGrowLight:
        return 'Đèn LED';
      case TargetDevice.ventilationFan:
        return 'Quạt thông gió';
    }
  }

  String get _thenPreview {
    final deviceName = _deviceLabelVi(_targetDevice);
    final state = _deviceStateOn ? 'Bật' : 'Tắt';
    return '$state $deviceName';
  }

  void _onSave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onBack: () => context.go('/box/automation', extra: widget.boxId)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ScreenHeader(),
                      const SizedBox(height: 28),
                      _ConditionSection(
                        sensorType: _sensorType,
                        logicType: _logicType,
                        thresholdController: _thresholdController,
                        onSensorChanged: (v) => setState(() => _sensorType = v!),
                        onLogicChanged: (v) => setState(() => _logicType = v!),
                        onThresholdChanged: () => setState(() {}),
                      ),
                      const SizedBox(height: 28),
                      _ActionSection(
                        targetDevice: _targetDevice,
                        deviceStateOn: _deviceStateOn,
                        onDeviceSelected: (d) => setState(() => _targetDevice = d),
                        onDeviceStateChanged: (v) => setState(() => _deviceStateOn = v),
                      ),
                      const SizedBox(height: 24),
                      RulePreviewCard(
                        ifLine: _ifPreview,
                        thenLine: _thenPreview,
                      ),
                      const SizedBox(height: 32),
                      _SaveButton(onSave: _onSave),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.loginBackground,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.loginLabel),
            onPressed: onBack,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _ScreenHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Luật tự động hóa mới',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.splashTitle,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Cấu hình kích hoạt thông minh để quản lý môi trường trồng tự động.',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.loginLabel,
          ),
        ),
      ],
    );
  }
}

class _ConditionSection extends StatelessWidget {
  const _ConditionSection({
    required this.sensorType,
    required this.logicType,
    required this.thresholdController,
    required this.onSensorChanged,
    required this.onLogicChanged,
    required this.onThresholdChanged,
  });

  final SensorType sensorType;
  final LogicType logicType;
  final TextEditingController thresholdController;
  final ValueChanged<SensorType?> onSensorChanged;
  final ValueChanged<LogicType?> onLogicChanged;
  final VoidCallback onThresholdChanged;

  @override
  Widget build(BuildContext context) {
    return _FormSection(
      title: 'Điều kiện NẾU',
      children: [
        RuleDropdownField<SensorType>(
          label: 'Cảm biến',
          value: sensorType,
          items: const [
            DropdownMenuItem(value: SensorType.humidity, child: Text('Độ ẩm')),
            DropdownMenuItem(value: SensorType.temperature, child: Text('Nhiệt độ')),
            DropdownMenuItem(value: SensorType.co2, child: Text('CO2')),
            DropdownMenuItem(value: SensorType.time, child: Text('Giờ')),
          ],
          onChanged: onSensorChanged,
        ),
        const SizedBox(height: 16),
        RuleDropdownField<LogicType>(
          label: 'So sánh',
          value: logicType,
          items: const [
            DropdownMenuItem(value: LogicType.dropsBelow, child: Text('Giảm xuống dưới (<)')),
            DropdownMenuItem(value: LogicType.risesAbove, child: Text('Tăng lên trên (>)')),
            DropdownMenuItem(value: LogicType.equals, child: Text('Bằng (=)')),
          ],
          onChanged: onLogicChanged,
        ),
        const SizedBox(height: 16),
        _ThresholdField(
          controller: thresholdController,
          unit: _getUnit(sensorType),
          onChanged: (_) => onThresholdChanged(),
        ),
      ],
    );
  }

  String _getUnit(SensorType s) {
    switch (s) {
      case SensorType.humidity:
        return '%';
      case SensorType.temperature:
        return '\u00B0C';
      case SensorType.co2:
        return 'ppm';
      case SensorType.time:
        return '';
    }
  }
}

class _ThresholdField extends StatelessWidget {
  const _ThresholdField({
    required this.controller,
    required this.unit,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String unit;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ngưỡng',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: AppColors.loginLabel,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.loginInputBorder),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(5),
                  ],
                  onChanged: onChanged,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.splashTitle,
                  ),
                  decoration: InputDecoration(
                    hintText: '75',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.loginHint,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.metricIconBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  unit,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.loginLabel,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({
    required this.targetDevice,
    required this.deviceStateOn,
    required this.onDeviceSelected,
    required this.onDeviceStateChanged,
  });

  final TargetDevice targetDevice;
  final bool deviceStateOn;
  final ValueChanged<TargetDevice> onDeviceSelected;
  final ValueChanged<bool> onDeviceStateChanged;

  @override
  Widget build(BuildContext context) {
    return _FormSection(
      title: 'Hành động THÌ',
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thiết bị đích',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
                color: AppColors.loginLabel,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SelectableDeviceChip(
                  label: 'Phun sương',
                  isSelected: targetDevice == TargetDevice.mister,
                  onTap: () => onDeviceSelected(TargetDevice.mister),
                ),
                SelectableDeviceChip(
                  label: 'Quạt hút',
                  isSelected: targetDevice == TargetDevice.exhaustFan,
                  onTap: () => onDeviceSelected(TargetDevice.exhaustFan),
                ),
                SelectableDeviceChip(
                  label: 'Đèn LED trồng',
                  isSelected: targetDevice == TargetDevice.ledGrowLight,
                  onTap: () => onDeviceSelected(TargetDevice.ledGrowLight),
                ),
                SelectableDeviceChip(
                  label: 'Quạt thông gió',
                  isSelected: targetDevice == TargetDevice.ventilationFan,
                  onTap: () => onDeviceSelected(TargetDevice.ventilationFan),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _DeviceStateToggle(
          isOn: deviceStateOn,
          onChanged: onDeviceStateChanged,
        ),
      ],
    );
  }
}

class _DeviceStateToggle extends StatelessWidget {
  const _DeviceStateToggle({
    required this.isOn,
    required this.onChanged,
  });

  final bool isOn;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trạng thái thiết bị',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: AppColors.loginLabel,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _StateButton(
              label: 'TẮT',
              isSelected: !isOn,
              color: AppColors.splashTrack,
              textColor: AppColors.splashTitle,
              onTap: () => onChanged(false),
            ),
            const SizedBox(width: 10),
            _StateButton(
              label: 'BẬT',
              isSelected: isOn,
              color: AppColors.primary,
              textColor: Colors.white,
              onTap: () => onChanged(true),
            ),
          ],
        ),
      ],
    );
  }
}

class _StateButton extends StatelessWidget {
  const _StateButton({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : AppColors.splashTrack,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? textColor : AppColors.loginLabel,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.splashTitle,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSave,
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
          'Lưu luật',
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
