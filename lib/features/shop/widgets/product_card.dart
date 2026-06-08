import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/shop/models/product.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  Widget _buildErrorWidget() =>
      const Center(child: Icon(Icons.image_not_supported, color: Colors.grey));

  @override
  Widget build(BuildContext context) {
    if (product.isWideCard) return _buildWideCard(context);
    return _buildStandardCard(context);
  }

  Widget _buildStandardCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.shopCardBorder),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D4CAF50),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageSection(height: 167),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.isBestSeller) ...[
                    _buildBadge('Bán chạy', AppColors.shopPrice),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    product.name,
                    style: AppTextStyles.shopProductName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _buildRatingRow(),
                  const SizedBox(height: 10),
                  _buildPriceRow(addToCart: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 202,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.shopCardBorder),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D4CAF50),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 139.19 / 202,
              child: Container(
                color: AppColors.shopCardImageBg,
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
                      )
                    : _buildErrorWidget(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.categoryName?.toUpperCase() ?? 'SẢN PHẨM',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                        color: AppColors.loginLink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.name,
                      style: AppTextStyles.shopProductName.copyWith(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.description ?? '',
                      style: AppTextStyles.shopProductDesc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    _buildPriceRow(addToCart: true, compact: false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection({required double height}) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: AppColors.shopCardImageBg,
              child: product.imageUrl != null
                  ? Image.network(
                      product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
                    )
                  : _buildErrorWidget(),
            ),
          ),
          if (product.isBestSeller)
            Positioned(
              top: 8,
              right: 8,
              child: _buildBadge('Bán chạy', AppColors.shopPrice),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: AppTextStyles.shopCategoryActive.copyWith(
          color: color == AppColors.shopPrice
              ? AppColors.optimalBadgeText
              : Colors.white,
        ),
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        const Icon(
          Icons.star,
          size: 12,
          color: AppColors.warning,
        ),
        const SizedBox(width: 4),
        Text(
          product.rating.toString(),
          style: AppTextStyles.shopRating,
        ),
      ],
    );
  }

  Widget _buildPriceRow({required bool addToCart, bool compact = true}) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            currencyFormat.format(product.price),
            style: AppTextStyles.shopPrice,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (addToCart)
          GestureDetector(
            onTap: onAddToCart,
            child: Container(
              padding: EdgeInsets.all(compact ? 6 : 8),
              decoration: BoxDecoration(
                color: compact ? AppColors.shopSearchFill : AppColors.shopPrice,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(
                Icons.add_shopping_cart,
                size: compact ? 16 : 20,
                color: compact ? AppColors.shopTextSecondary : Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
