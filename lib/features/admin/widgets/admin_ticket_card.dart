import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_priority_badge.dart';

enum TicketStatus { pending, inProgress, completed }

class AdminTicketCard extends StatelessWidget {
  final String id;
  final String title;
  final String device;
  final String? assigned;
  final String time;
  final TicketPriority priority;
  final TicketStatus status;
  final List<String> buttons;
  final VoidCallback? onViewDetails;

  const AdminTicketCard({
    super.key,
    required this.id,
    required this.title,
    required this.device,
    this.assigned,
    required this.time,
    required this.priority,
    required this.status,
    required this.buttons,
    this.onViewDetails,
  });

  String get _statusLabel {
    switch (status) {
      case TicketStatus.pending:
        return 'Pending';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.completed:
        return 'Completed';
    }
  }

  Color get _statusColor {
    switch (status) {
      case TicketStatus.pending:
        return const Color(0xFFF59E0B);
      case TicketStatus.inProgress:
        return const Color(0xFF0EA5E9);
      case TicketStatus.completed:
        return const Color(0xFF22C55E);
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
        border: Border.all(color: AppColors.border),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '#$id',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: _statusColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _statusLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AdminPriorityBadge(priority: priority),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.sensors, device),
                if (assigned != null) ...[
                  const SizedBox(height: 6),
                  _buildInfoRow(Icons.person, assigned!),
                ],
                const SizedBox(height: 6),
                _buildInfoRow(Icons.access_time, time),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                if (onViewDetails != null)
                  GestureDetector(
                    onTap: onViewDetails,
                    child: Text(
                      'View Details',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF43B94E),
                      ),
                    ),
                  ),
                const Spacer(),
                ...buttons.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final btn = entry.value;
                  final isLast = idx == buttons.length - 1;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: isLast ? 0 : 4, right: isLast ? 0 : 4),
                      child: _TicketButton(
                        label: _buttonLabel(btn),
                        icon: _buttonIcon(btn),
                        color: _buttonColor(btn),
                        onTap: () => _handleButton(context, btn),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _buttonLabel(String btn) {
    switch (btn) {
      case 'assign_technician':
        return 'Assign Technician';
      case 'update_status':
        return 'Update Status';
      default:
        return btn;
    }
  }

  IconData _buttonIcon(String btn) {
    switch (btn) {
      case 'assign_technician':
        return Icons.person_add;
      case 'update_status':
        return Icons.edit;
      default:
        return Icons.circle;
    }
  }

  Color _buttonColor(String btn) {
    switch (btn) {
      case 'assign_technician':
        return const Color(0xFF8B5CF6);
      case 'update_status':
        return const Color(0xFF43B94E);
      default:
        return AppColors.primary;
    }
  }

  void _handleButton(BuildContext context, String btn) {
    switch (btn) {
      case 'assign_technician':
        _showSnackBar(context, 'Assigning technician...');
        break;
      case 'update_status':
        _showSnackBar(context, 'Updating ticket status...');
        break;
    }
  }
}

class _TicketButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TicketButton({
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
        padding: const EdgeInsets.symmetric(vertical: 9),
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
                  fontSize: 11,
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
