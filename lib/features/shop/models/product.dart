class ProductModel {
  final int id;
  final String name;
  final String? description;
  final double price;
  final int stockQuantity;
  final String? imageUrl;
  final String? status;
  final int? categoryId;
  final String? categoryName;
  final DateTime? createdAt;

  // UI specific fields (might not come from API directly)
  final double rating;
  final bool isBestSeller;
  final bool isProDevice;
  final bool isWideCard;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stockQuantity,
    this.imageUrl,
    this.status,
    this.categoryId,
    this.categoryName,
    this.createdAt,
    this.rating = 0.0,
    this.isBestSeller = false,
    this.isProDevice = false,
    this.isWideCard = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      stockQuantity: int.tryParse(json['stock_quantity']?.toString() ?? '0') ?? 0,
      imageUrl: json['image_url']?.toString(),
      status: json['status']?.toString(),
      categoryId: json['category_id'] != null 
          ? int.tryParse(json['category_id'].toString()) 
          : null,
      categoryName: json['category_name']?.toString(),
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      // Defaulting UI fields as they are not in the provided API response
      rating: 0.0,
      isBestSeller: false,
      isProDevice: false,
      isWideCard: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock_quantity': stockQuantity,
      'image_url': imageUrl,
      'status': status,
      'category_id': categoryId,
      'category_name': categoryName,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
