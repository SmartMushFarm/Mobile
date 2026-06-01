enum ProductCategory { all, devices, spawn, kits }

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating = 0.0,
    this.isBestSeller = false,
    this.isProDevice = false,
    this.isWideCard = false,
    this.stockLabel,
  });

  final String id;
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  final ProductCategory category;
  final double rating;
  final bool isBestSeller;
  final bool isProDevice;
  final bool isWideCard;
  final String? stockLabel;
}
