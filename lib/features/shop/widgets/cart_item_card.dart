import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/shop/models/cart_model.dart';
import 'package:intl/intl.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final CartItemModel item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cartCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cartCardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.cartImageBg,
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: item.productImageUrl != null
                  ? Image.network(
                      item.productImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: _imgError,
                    )
                  : _imgError(context, null, null),
            ),
            const SizedBox(width: 16),
            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + remove button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.productName ?? 'Sản phẩm',
                          style: AppTextStyles.cartItemTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: AppColors.shopTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Price + quantity stepper
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currencyFormat.format(item.price),
                        style: AppTextStyles.cartItemPrice,
                      ),
                      const Spacer(),
                      _QuantityStepper(
                        quantity: item.quantity,
                        onChanged: onQuantityChanged,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tổng: ${currencyFormat.format(item.price * item.quantity)}',
                    style: AppTextStyles.cartItemDesc,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imgError(BuildContext c, Object? e, StackTrace? s) =>
      Container(
        color: AppColors.cartImageBg,
        child: const Center(
          child: Icon(
            Icons.image,
            color: AppColors.loginHint,
            size: 24,
          ),
        ),
      );
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.onChanged,
  });

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.cartQtySelectorBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.cartQtySelectorBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperBtn(
            icon: Icons.remove,
            onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$quantity',
              style: AppTextStyles.cartQtyValue,
              textAlign: TextAlign.center,
            ),
          ),
          _StepperBtn(
            icon: Icons.add,
            onTap: () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }
}

class _StepperBtn extends StatelessWidget {
  const _StepperBtn({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: AppColors.cartQtyBtnShadow,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
          border: isEnabled
              ? Border.all(color: AppColors.cartQtySelectorBorder)
              : null,
        ),
        child: Icon(
          icon,
          size: 12,
          color: isEnabled
              ? AppColors.shopTextPrimary
              : AppColors.shopTextSecondary.withOpacity(0.4),
        ),
      ),
    );
  }
}
