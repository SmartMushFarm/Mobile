class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? role;
  final String? status;
  final DateTime? createdAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.role,
    this.status,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Nếu API trả data bọc trong "data"
    final data = json['data'] != null && json['data'] is Map ? json['data'] : json;

    return UserModel(
      id: int.tryParse(data['id']?.toString() ?? ''),
      name: data['name']?.toString(),
      email: data['email']?.toString(),
      phone: data['phone']?.toString(),
      address: data['address']?.toString(),
      role: data['role']?.toString(),
      status: data['status']?.toString(),
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
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
