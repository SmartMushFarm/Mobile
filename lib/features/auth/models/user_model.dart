class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? role;
  final String? status;
  final int? deviceCount;
  final String? lastActive;
  final DateTime? createdAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.role,
    this.status,
    this.deviceCount,
    this.lastActive,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Linh hoạt tìm data object
    Map<String, dynamic> data = json;
    if (json.containsKey('data') && json['data'] is Map) {
      data = Map<String, dynamic>.from(json['data']);
    }
    
    // Nếu có key 'user' lồng bên trong
    if (data.containsKey('user') && data['user'] is Map) {
      data = Map<String, dynamic>.from(data['user']);
    }

    // Tính toán số lượng thiết bị linh hoạt
    int count = 0;
    final possibleDeviceFields = ['device_count', 'deviceCount', 'devices_count', 'devices', 'mushroom_boxes', 'mushroom_box_count'];
    for (var field in possibleDeviceFields) {
      if (data[field] != null) {
        if (data[field] is List) {
          count = (data[field] as List).length;
          break;
        } else {
          count = int.tryParse(data[field].toString()) ?? 0;
          if (count > 0) break;
        }
      }
    }

    return UserModel(
      id: int.tryParse(data['id']?.toString() ?? ''),
      name: data['name']?.toString() ?? data['full_name']?.toString() ?? data['username']?.toString(),
      email: data['email']?.toString(),
      phone: data['phone']?.toString() ?? data['phone_number']?.toString(),
      address: data['address']?.toString(),
      role: data['role']?.toString(),
      status: data['status']?.toString(),
      deviceCount: count,
      lastActive: data['last_active']?.toString() ?? data['last_login']?.toString(),
      createdAt: data['created_at'] != null 
          ? DateTime.tryParse(data['created_at'].toString()) 
          : (data['createdAt'] != null ? DateTime.tryParse(data['createdAt'].toString()) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
      'status': status,
      'device_count': deviceCount,
      'last_active': lastActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
