import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/automation_rule_card.dart';
import 'package:smartmush_farmer/core/widgets/box_tab_bar.dart';
import 'package:smartmush_farmer/features/user/data/mock_box_overview.dart';
import 'package:smartmush_farmer/features/user/widgets/box_page_header.dart';
import 'package:smartmush_farmer/features/user/widgets/box_screen_shell.dart';

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
  late final Map<String, bool> _ruleStates;

  @override
  void initState() {
    super.initState();
    _ruleStates = {
      'humidity': true,
      'temperature': true,
      'co2': false,
      'time': true,
    };
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

  void _toggleRule(String key, bool value) {
    setState(() => _ruleStates[key] = value);
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
      selectedTab: BoxTab.automation,
      onTabSelected: (tab) => _onTabSelected(context, tab),
      header: BoxPageHeader(
        boxName: data.name,
        statusLabel: data.growStatusLabel,
      ),
      body: _AutomationBody(
        ruleStates: _ruleStates,
        onToggleRule: _toggleRule,
        onAddRule: () => context.push('/box/automation/add', extra: widget.boxId),
      ),
    );
  }
}

class _AutomationBody extends StatelessWidget {
  const _AutomationBody({
    required this.ruleStates,
    required this.onToggleRule,
    required this.onAddRule,
  });

  final Map<String, bool> ruleStates;
  final void Function(String, bool) onToggleRule;
  final VoidCallback onAddRule;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Luật tự động hóa',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.splashTitle,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Quản lý hành vi tự động cho môi trường trồng nấm',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.loginLabel,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ..._buildRuleCards(),
        const SizedBox(height: 24),
        _AddRuleButton(onTap: onAddRule),
      ],
    );
  }

  List<Widget> _buildRuleCards() {
    return [
      _RuleCard(
        key: const ValueKey('humidity'),
        ruleType: AutomationRuleType.humidity,
        title: 'Độ ẩm dưới 75%',
        priority: RulePriority.medium,
        ifCondition: 'Độ ẩm < 75%',
        thenAction: 'Bật Phun sương',
        isEnabled: ruleStates['humidity']!,
        onToggle: (v) => onToggleRule('humidity', v),
        onEdit: () {},
        onDelete: () {},
      ),
      const SizedBox(height: 12),
      _RuleCard(
        key: const ValueKey('temperature'),
        ruleType: AutomationRuleType.temperature,
        title: 'Nhiệt độ trên 32\u00B0C',
        priority: RulePriority.high,
        ifCondition: 'Nhiệt độ > 32\u00B0C',
        thenAction: 'Bật Quạt',
        isEnabled: ruleStates['temperature']!,
        onToggle: (v) => onToggleRule('temperature', v),
        onEdit: () {},
        onDelete: () {},
      ),
      const SizedBox(height: 12),
      _RuleCard(
        key: const ValueKey('co2'),
        ruleType: AutomationRuleType.co2,
        title: 'CO2 trên 1200 ppm',
        priority: RulePriority.low,
        ifCondition: 'CO2 > 1200 ppm',
        thenAction: 'Bật Quạt hút',
        isEnabled: ruleStates['co2']!,
        onToggle: (v) => onToggleRule('co2', v),
        onEdit: () {},
        onDelete: () {},
      ),
      const SizedBox(height: 12),
      _RuleCard(
        key: const ValueKey('time'),
        ruleType: AutomationRuleType.time,
        title: 'Lúc 18:00',
        priority: RulePriority.low,
        ifCondition: 'Giờ = 18:00',
        thenAction: 'Tắt Đèn LED',
        isEnabled: ruleStates['time']!,
        onToggle: (v) => onToggleRule('time', v),
        onEdit: () {},
        onDelete: () {},
      ),
    ];
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({
    super.key,
    required this.ruleType,
    required this.title,
    required this.priority,
    required this.ifCondition,
    required this.thenAction,
    required this.isEnabled,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final AutomationRuleType ruleType;
  final String title;
  final RulePriority priority;
  final String ifCondition;
  final String thenAction;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AutomationRuleCard(
      ruleType: ruleType,
      title: title,
      priority: priority,
      ifCondition: ifCondition,
      thenAction: thenAction,
      isEnabled: isEnabled,
      onToggle: onToggle,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}

class _AddRuleButton extends StatelessWidget {
  const _AddRuleButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 20, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Thêm luật',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
