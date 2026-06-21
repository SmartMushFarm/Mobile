class NotificationModel {
  final int? id;
  final int? userId;
  final int? deviceId;
  final String type;
  final String title;
  final String message;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationModel({
    this.id,
    this.userId,
    this.deviceId,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] is String ? int.tryParse(json['id']) : json['id'],
      userId: json['user_id'] is String ? int.tryParse(json['user_id']) : json['user_id'],
      deviceId: json['device_id'] is String ? int.tryParse(json['device_id']) : json['device_id'],
      type: json['type'] ?? 'Info',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      isRead: json['is_read'] == true || json['is_read'] == 1 || json['read'] == true,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : (json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null),
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : (json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'device_id': deviceId,
      'type': type,
      'title': title,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
