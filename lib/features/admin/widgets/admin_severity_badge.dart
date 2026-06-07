import 'package:flutter/material.dart';

enum AlertSeverity { critical, warning, success }

class AdminSeverityBadge extends StatelessWidget {
  final AlertSeverity severity;

  const AdminSeverityBadge({
    super.key,
    required this.severity,
  });

  Color get _backgroundColor {
    switch (severity) {
      case AlertSeverity.critical:
        return const Color(0xFFFFEDEA);
      case AlertSeverity.warning:
        return const Color(0xFFFFF4E5);
      case AlertSeverity.success:
        return const Color(0xFFE8F5E9);
    }
  }

  Color get _textColor {
    switch (severity) {
      case AlertSeverity.critical:
        return const Color(0xFFD32F2F);
      case AlertSeverity.warning:
        return const Color(0xFFB76E00);
      case AlertSeverity.success:
        return const Color(0xFF2E7D32);
    }
  }

  String get _label {
    switch (severity) {
      case AlertSeverity.critical:
        return 'Critical';
      case AlertSeverity.warning:
        return 'Warning';
      case AlertSeverity.success:
        return 'Success';
    }
  }

  IconData get _icon {
    switch (severity) {
      case AlertSeverity.critical:
        return Icons.error;
      case AlertSeverity.warning:
        return Icons.warning;
      case AlertSeverity.success:
        return Icons.check_circle;
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
