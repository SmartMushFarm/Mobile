enum MaintenanceStatus {
  pending,               // Customer tạo yêu cầu
  received,              // Admin approve
  processing,            // Admin schedule + gán technician
  waitingConfirmation,   // Technician báo đã xong
  completed,             // Admin xác nhận hoàn tất
  cancelled,
}

class MaintenanceTicket {
  const MaintenanceTicket({
    required this.id,
    required this.deviceId,
    required this.deviceName,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final int deviceId;
  final String deviceName;
  final String title;
  final String description;
  final String priority;
  final MaintenanceStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory MaintenanceTicket.fromJson(Map<String, dynamic> json) {
    return MaintenanceTicket(
      id: json['id']?.toString() ?? '',
      deviceId: json['device_id'] is int ? json['device_id'] : int.tryParse(json['device_id']?.toString() ?? '0') ?? 0,
      deviceName: json['device_name'] ?? json['device']?['device_name'] ?? 'Thiết bị #${json['device_id']}',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      priority: json['priority'] ?? '',
      status: _parseStatus(json['status']),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }

  static MaintenanceStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return MaintenanceStatus.pending;
      case 'received':
        return MaintenanceStatus.received;
      case 'processing':
        return MaintenanceStatus.processing;
      case 'waitingconfirmation':
      case 'waiting_confirmation':
        return MaintenanceStatus.waitingConfirmation;
      case 'completed':
        return MaintenanceStatus.completed;
      case 'cancelled':
        return MaintenanceStatus.cancelled;
      default:
        return MaintenanceStatus.pending;
    }
  }
}
