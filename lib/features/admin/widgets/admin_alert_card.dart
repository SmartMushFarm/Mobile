import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_severity_badge.dart';

class AdminAlertCard extends StatelessWidget {
  final String device;
  final String time;
  final String title;
  final String description;
  final AlertSeverity severity;
  final List<String> buttons;
  final VoidCallback? onResolve;
  final VoidCallback? onAssignTech;
  final VoidCallback? onArchive;

  const AdminAlertCard({
    super.key,
    required this.device,
    required this.time,
    required this.title,
    required this.description,
    required this.severity,
    required this.buttons,
    this.onResolve,
    this.onAssignTech,
    this.onArchive,
  });

  Color get _accentColor {
    switch (severity) {
      case AlertSeverity.critical:
        return const Color(0xFFEF4444);
      case AlertSeverity.warning:
        return const Color(0xFFF59E0B);
      case AlertSeverity.success:
        return const Color(0xFF22C55E);
    }
  }

  IconData get _severityIcon {
    switch (severity) {
      case AlertSeverity.critical:
        return Icons.error;
      case AlertSeverity.warning:
        return Icons.warning;
      case AlertSeverity.success:
        return Icons.check_circle;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _accentColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_severityIcon, color: _accentColor, size: 24),
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
                                  device,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                              ),
                              AdminSeverityBadge(severity: severity),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 12,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                time,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          if (buttons.isNotEmpty) ...[
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            _buildButtons(context),
          ],
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: buttons.asMap().entries.map((entry) {
          final idx = entry.key;
          final btn = entry.value;
          final isLast = idx == buttons.length - 1;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: isLast ? 0 : 4, right: isLast ? 0 : 4),
              child: _AlertButton(
                label: _buttonLabel(btn),
                icon: _buttonIcon(btn),
                color: _buttonColor(btn),
                onTap: () => _handleButton(context, btn),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _buttonLabel(String btn) {
    switch (btn) {
      case 'resolve':
        return 'Resolve';
      case 'assign_tech':
        return 'Assign Tech';
      case 'archive':
        return 'Archive';
      default:
        return btn;
    }
  }

  IconData _buttonIcon(String btn) {
    switch (btn) {
      case 'resolve':
        return Icons.check;
      case 'assign_tech':
        return Icons.person_add;
      case 'archive':
        return Icons.archive;
      default:
        return Icons.circle;
    }
  }

  Color _buttonColor(String btn) {
    switch (btn) {
      case 'resolve':
        return const Color(0xFF22C55E);
      case 'assign_tech':
        return const Color(0xFF8B5CF6);
      case 'archive':
        return AppColors.textSecondary;
      default:
        return AppColors.primary;
    }
  }

  void _handleButton(BuildContext context, String btn) {
    switch (btn) {
      case 'resolve':
        _showSnackBar(context, 'Alert marked as resolved');
        break;
      case 'assign_tech':
        if (onAssignTech != null) {
          onAssignTech!();
        }
        break;
      case 'archive':
        _showSnackBar(context, 'Notification archived');
        break;
    }
  }
}

class _AlertButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AlertButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
