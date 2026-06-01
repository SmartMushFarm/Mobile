import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/shop/models/checkout_item.dart';

class DeliveryMethodCard extends StatelessWidget {
  const DeliveryMethodCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  final DeliveryMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (method) {
      case DeliveryMethod.standard:
        return Icons.local_shipping_outlined;
      case DeliveryMethod.express:
        return Icons.flash_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.checkoutDeliveryActiveBg
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.shopPrice : AppColors.shopCategoryBorder,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    _icon,
                    size: 18,
                    color: AppColors.shopTextPrimary,
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      size: 18,
                      color: AppColors.shopPrice,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                method.label,
                style: AppTextStyles.checkoutDeliveryName,
              ),
              const SizedBox(height: 4),
              Text(
                method.price,
                style: AppTextStyles.checkoutDeliveryPrice,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
