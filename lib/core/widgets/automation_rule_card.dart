import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

enum AutomationRuleType {
  humidity,
  temperature,
  co2,
  time,
}

enum RulePriority { low, medium, high }

class AutomationRuleCard extends StatelessWidget {
  const AutomationRuleCard({
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

  IconData get _ruleIcon {
    switch (ruleType) {
      case AutomationRuleType.humidity:
        return Icons.water_drop_outlined;
      case AutomationRuleType.temperature:
        return Icons.thermostat_outlined;
      case AutomationRuleType.co2:
        return Icons.cloud_outlined;
      case AutomationRuleType.time:
        return Icons.schedule_outlined;
    }
  }

  Color get _iconColor {
    if (!isEnabled) return AppColors.splashTrack;
    switch (ruleType) {
      case AutomationRuleType.humidity:
        return AppColors.primary;
      case AutomationRuleType.temperature:
        return const Color(0xFFE67E22);
      case AutomationRuleType.co2:
        return AppColors.loginLink;
      case AutomationRuleType.time:
        return const Color(0xFF8E44AD);
    }
  }

  Color get _priorityColor {
    switch (priority) {
      case RulePriority.high:
        return AppColors.danger;
      case RulePriority.medium:
        return AppColors.warning;
      case RulePriority.low:
        return AppColors.primary;
    }
  }

  String get _priorityLabel {
    switch (priority) {
      case RulePriority.high:
        return 'CAO';
      case RulePriority.medium:
        return 'TRG';
      case RulePriority.low:
        return 'THẤP';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.55,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled
                ? AppColors.statusOnlineBackground
                : AppColors.splashTrack,
            width: isEnabled ? 1.5 : 1,
          ),
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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _ruleIcon,
                    size: 22,
                    color: _iconColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.splashTitle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _priorityColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _priorityLabel,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: _priorityColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _IfThenPreview(
                        ifCondition: ifCondition,
                        thenAction: thenAction,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: IconButton(
                            onPressed: onEdit,
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: AppColors.loginLabel,
                            ),
                            tooltip: 'Sửa luật',
                          ),
                        ),
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: IconButton(
                            onPressed: onDelete,
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: AppColors.danger,
                            ),
                            tooltip: 'Xóa luật',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _RuleToggle(isOn: isEnabled, onToggle: onToggle),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IfThenPreview extends StatelessWidget {
  const _IfThenPreview({
    required this.ifCondition,
    required this.thenAction,
  });

  final String ifCondition;
  final String thenAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ConditionChip(
          label: ifCondition,
          color: AppColors.loginLink,
          bgColor: AppColors.statusOnlineBackground,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Icon(
            Icons.arrow_forward,
            size: 14,
            color: AppColors.loginLabel,
          ),
        ),
        Expanded(
          child: _ConditionChip(
            label: thenAction,
            color: AppColors.splashTitle,
            bgColor: AppColors.metricIconBackground,
          ),
        ),
      ],
    );
  }
}

class _ConditionChip extends StatelessWidget {
  const _ConditionChip({
    required this.label,
    required this.color,
    required this.bgColor,
  });

  final String label;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _RuleToggle extends StatelessWidget {
  const _RuleToggle({
    required this.isOn,
    required this.onToggle,
  });

  final bool isOn;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isOn),
      child: Container(
        width: 48,
        height: 28,
        decoration: BoxDecoration(
          color: isOn ? AppColors.primary : AppColors.splashTrack,
          borderRadius: BorderRadius.circular(999),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isOn ? AppColors.primary : AppColors.splashTrack,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
