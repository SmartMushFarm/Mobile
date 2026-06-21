class PromotionModel {
  final int? id;
  final String code;
  final int discountPercent;
  final DateTime validFrom;
  final DateTime validTo;
  final String status;

  PromotionModel({
    this.id,
    required this.code,
    required this.discountPercent,
    required this.validFrom,
    required this.validTo,
    required this.status,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      code: json['code'] ?? '',
      discountPercent: (double.tryParse(json['discount_percent']?.toString() ?? '0') ?? 0).toInt(),
      validFrom: DateTime.parse(json['valid_from'] ?? DateTime.now().toIso8601String()),
      validTo: DateTime.parse(json['valid_to'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'discount_percent': discountPercent,
      'valid_from': validFrom.toIso8601String(),
      'valid_to': validTo.toIso8601String(),
      'status': status,
    };
  }
}
