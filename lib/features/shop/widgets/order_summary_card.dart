import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/shop/models/cart_item.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    required this.summary,
    required this.onCheckout,
  });

  final CartSummary summary;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cartSummaryBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cartCardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TÓM TẮT ĐƠN HÀNG',
            style: AppTextStyles.cartSectionLabel,
          ),
          const SizedBox(height: 16),
          _SummaryRow(label: 'Tạm tính', value: summary.subtotal),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Phí vận chuyển', value: summary.shipping),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Thuế', value: summary.tax),
          const SizedBox(height: 14),
          Divider(color: AppColors.cartDivider, thickness: 1),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tổng cộng', style: AppTextStyles.cartSummaryTotalLabel),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    summary.total,
                    style: AppTextStyles.cartSummaryTotalValue,
                  ),
                  Text('VND', style: AppTextStyles.cartSummaryCurrency),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: GestureDetector(
              onTap: onCheckout,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.shopPrice,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.cartBtnShadow,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text('Thanh toán an toàn', style: AppTextStyles.cartCheckoutBtn),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Thanh toán được xử lý bảo mật.',
              style: AppTextStyles.cartSecureNote,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.cartSummaryLabel),
        Text(value, style: AppTextStyles.cartSummaryValue),
      ],
    );
  }
}
