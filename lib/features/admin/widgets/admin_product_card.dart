import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/shop/models/product.dart';
import 'package:intl/intl.dart';

enum ProductStockStatus { inStock, lowStock, outOfStock }

class AdminProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AdminProductCard({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });

  ProductStockStatus get stockStatus {
    if (product.stockQuantity <= 0) return ProductStockStatus.outOfStock;
    if (product.stockQuantity < 10) return ProductStockStatus.lowStock;
    return ProductStockStatus.inStock;
  }

  String get _stockLabel {
    switch (stockStatus) {
      case ProductStockStatus.inStock:
        return 'In Stock';
      case ProductStockStatus.lowStock:
        return 'Low Stock';
      case ProductStockStatus.outOfStock:
        return 'Out Of Stock';
    }
  }

  Color get _stockColor {
    switch (stockStatus) {
      case ProductStockStatus.inStock:
        return const Color(0xFF22C55E);
      case ProductStockStatus.lowStock:
        return const Color(0xFFF59E0B);
      case ProductStockStatus.outOfStock:
        return const Color(0xFFEF4444);
    }
  }

  IconData get _productIcon {
    final lower = product.name.toLowerCase();
    if (lower.contains('led') || lower.contains('light')) return Icons.lightbulb;
    if (lower.contains('mushroom') || lower.contains('culture')) return Icons.eco;
    if (lower.contains('humidity') || lower.contains('sensor')) return Icons.water_drop;
    if (lower.contains('mist')) return Icons.water;
    if (lower.contains('substrate') || lower.contains('bag')) return Icons.inventory_2;
    return Icons.shopping_bag;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: stockStatus == ProductStockStatus.outOfStock
              ? const Color(0xFFEF4444).withOpacity(0.3)
              : AppColors.border,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: stockStatus == ProductStockStatus.outOfStock
                        ? const Color(0xFFF3F4F6)
                        : const Color(0xFF43B94E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: product.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Icon(
                              _productIcon,
                              color: stockStatus == ProductStockStatus.outOfStock
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF43B94E),
                              size: 28,
                            ),
                          ),
                        )
                      : Icon(
                          _productIcon,
                          color: stockStatus == ProductStockStatus.outOfStock
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF43B94E),
                          size: 28,
                        ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: stockStatus == ProductStockStatus.outOfStock
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            currencyFormat.format(product.price),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: stockStatus == ProductStockStatus.outOfStock
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF22C55E),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _stockColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _stockColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _stockLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _stockColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Stock: ${product.stockQuantity}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.category_outlined,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              product.categoryName ?? 'No category',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            const SizedBox(height: 8),
            Row(
              children: [
                _ActionIconButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  color: const Color(0xFF0EA5E9),
                  onTap: onEdit ?? () {},
                ),
                const SizedBox(width: 8),
                _ActionIconButton(
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  color: const Color(0xFFEF4444),
                  onTap: onDelete ?? () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionIconButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
