import 'package:flutter/material.dart';

enum TicketPriority { high, medium, low }

class AdminPriorityBadge extends StatelessWidget {
  final TicketPriority priority;

  const AdminPriorityBadge({
    super.key,
    required this.priority,
  });

  Color get _backgroundColor {
    switch (priority) {
      case TicketPriority.high:
        return const Color(0xFFFFEDEA);
      case TicketPriority.medium:
        return const Color(0xFFFFF4E5);
      case TicketPriority.low:
        return const Color(0xFFE8F5E9);
    }
  }

  Color get _textColor {
    switch (priority) {
      case TicketPriority.high:
        return const Color(0xFFD32F2F);
      case TicketPriority.medium:
        return const Color(0xFFB76E00);
      case TicketPriority.low:
        return const Color(0xFF2E7D32);
    }
  }

  String get _label {
    switch (priority) {
      case TicketPriority.high:
        return 'High Priority';
      case TicketPriority.medium:
        return 'Medium Priority';
      case TicketPriority.low:
        return 'Low Priority';
    }
  }

  IconData get _icon {
    switch (priority) {
      case TicketPriority.high:
        return Icons.error;
      case TicketPriority.medium:
        return Icons.warning;
      case TicketPriority.low:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: _textColor),
          const SizedBox(width: 4),
          Text(
            _label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }
}
