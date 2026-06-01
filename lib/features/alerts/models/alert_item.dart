import 'package:flutter/material.dart';

enum AlertSeverity {
  critical,
  warning,
  automation,
  device,
  maintenance,
  info,
}

class AlertItem {
  const AlertItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.severity,
    required this.icon,
    this.isRead = false,
    this.hasViewBox = false,
    this.boxId,
    this.automationBadge,
  });

  final String id;
  final String title;
  final String description;
  final String timestamp;
  final AlertSeverity severity;
  final IconData icon;
  final bool isRead;
  final bool hasViewBox;
  final String? boxId;
  final String? automationBadge;
}
