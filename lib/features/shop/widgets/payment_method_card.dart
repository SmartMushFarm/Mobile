import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/shop/models/checkout_item.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (method) {
      case PaymentMethod.cod:
        return Icons.payments_outlined;
      case PaymentMethod.payOS:
        return Icons.qr_code_scanner_outlined;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance_outlined;
      case PaymentMethod.creditCard:
        return Icons.credit_card_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.shopPrice : AppColors.shopCategoryBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.checkoutCardShadow,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              _icon,
              size: 20,
              color: AppColors.shopTextPrimary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method.label,
                style: AppTextStyles.checkoutPaymentName,
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.shopPrice
                      : AppColors.shopCategoryBorder,
                  width: isSelected ? 3 : 2,
                ),
                color: isSelected ? AppColors.shopPrice : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
