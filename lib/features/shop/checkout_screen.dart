import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/shop/models/checkout_item.dart';
import 'package:smartmush_farmer/features/shop/widgets/checkout_section_card.dart';
import 'package:smartmush_farmer/features/shop/widgets/delivery_method_card.dart';
import 'package:smartmush_farmer/features/shop/widgets/payment_method_card.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, this.from});

  final String? from;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  DeliveryMethod _selectedDelivery = DeliveryMethod.standard;
  PaymentMethod _selectedPayment = PaymentMethod.creditCard;
  final TextEditingController _promoController = TextEditingController();

  static const _ledImage =
      'https://www.figma.com/api/mcp/asset/ac070f7c-928b-46ef-9ede-d389227be3b8';
  static const _spawnImage =
      'https://www.figma.com/api/mcp/asset/383f08e6-84cd-4007-bc77-49a35dea7b4f';

  static const _orderItems = [
    CheckoutItem(
      name: 'Đèn LED trồng nấm thông minh',
      price: '2.150.000đ',
      quantity: 1,
      imageUrl: _ledImage,
    ),
    CheckoutItem(
      name: 'Phôi nấm bào ngư vàng',
      price: '295.000đ',
      quantity: 2,
      imageUrl: _spawnImage,
    ),
  ];

  CheckoutSummary get _summary {
    // Subtotal: Đèn LED x1 + Phôi x2
    final subtotal = 2150000 + (295000 * 2);
    final shipping = _selectedDelivery == DeliveryMethod.standard ? 35000 : 55000;
    final tax = (subtotal * 0.05).round();
    final total = subtotal + shipping + tax;
    return CheckoutSummary(
      subtotal: _formatPrice(subtotal),
      shipping: _formatPrice(shipping),
      tax: _formatPrice(tax),
      total: _formatPrice(total),
    );
  }

  String _formatPrice(int n) =>
      '${(n ~/ 1000).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ';

  void _onApplyPromo() {
    final code = _promoController.text.trim();
    if (code.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mã "$code" đã được áp dụng'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onPlaceOrder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đặt hàng thành công'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.push('/shop/order-history');
  }

  void _onBottomNavSelected(UserNavItem item) {
    switch (item) {
      case UserNavItem.home:
        context.go('/home');
      case UserNavItem.shop:
        context.go('/shop');
      case UserNavItem.alerts:
        context.push('/alerts');
      case UserNavItem.profile:
        context.push('/profile');
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth.clamp(0.0, 448.0);

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildShippingAddress(),
                            const SizedBox(height: 24),
                            _buildOrderSummary(),
                            const SizedBox(height: 24),
                            _buildDeliverySection(),
                            const SizedBox(height: 24),
                            _buildPaymentSection(),
                            const SizedBox(height: 24),
                            _buildPromoSection(),
                            const SizedBox(height: 24),
                            _buildCostBreakdown(),
                            const SizedBox(height: 24),
                            _buildPlaceOrderButton(),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: UserBottomNav(
        currentItem: UserNavItem.shop,
        onItemSelected: _onBottomNavSelected,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.loginBackground,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.loginLabel),
            onPressed: () => context.go('/shop'),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          Text(
            'Thanh toán',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.55,
              color: AppColors.shopPrice,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddress() {
    return CheckoutSectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 18,
            color: AppColors.shopTextSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nguyễn Văn A',
                  style: AppTextStyles.checkoutAddressName,
                ),
                const SizedBox(height: 4),
                Text(
                  '123 Nguyễn Huệ, Quận 1, TP.HCM',
                  style: AppTextStyles.checkoutAddressDetail,
                ),
                const SizedBox(height: 2),
                Text(
                  '0901 234 567',
                  style: AppTextStyles.checkoutAddressDetail,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text('SỬA', style: AppTextStyles.checkoutEditBtn),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tóm tắt đơn hàng', style: AppTextStyles.checkoutSectionTitle),
        const SizedBox(height: 12),
        ..._orderItems.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CheckoutSectionCard(
                padding: const EdgeInsets.all(13),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.checkoutCardBorder,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: _imgError,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: AppTextStyles.checkoutOrderItemName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'SL: ${item.quantity}',
                            style: AppTextStyles.checkoutOrderItemQty,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      item.price,
                      style: AppTextStyles.checkoutOrderItemPrice,
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildDeliverySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Phương thức giao hàng', style: AppTextStyles.checkoutSectionTitle),
        const SizedBox(height: 12),
        Row(
          children: [
            DeliveryMethodCard(
              method: DeliveryMethod.standard,
              isSelected: _selectedDelivery == DeliveryMethod.standard,
              onTap: () => setState(() => _selectedDelivery = DeliveryMethod.standard),
            ),
            const SizedBox(width: 12),
            DeliveryMethodCard(
              method: DeliveryMethod.express,
              isSelected: _selectedDelivery == DeliveryMethod.express,
              onTap: () => setState(() => _selectedDelivery = DeliveryMethod.express),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Phương thức thanh toán', style: AppTextStyles.checkoutSectionTitle),
        const SizedBox(height: 12),
        ...PaymentMethod.values.map((method) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PaymentMethodCard(
                method: method,
                isSelected: _selectedPayment == method,
                onTap: () => setState(() => _selectedPayment = method),
              ),
            )),
      ],
    );
  }

  Widget _buildPromoSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.shopCategoryBorder),
            ),
            child: TextField(
              controller: _promoController,
              style: AppTextStyles.checkoutPromoInput.copyWith(
                color: AppColors.shopTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Nhập mã giảm giá',
                hintStyle: AppTextStyles.checkoutPromoInput,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _onApplyPromo,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 19),
            decoration: BoxDecoration(
              color: AppColors.shopPrice,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('ÁP DỤNG', style: AppTextStyles.checkoutApplyBtn),
          ),
        ),
      ],
    );
  }

  Widget _buildCostBreakdown() {
    final s = _summary;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.checkoutCardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _BreakdownRow(label: 'Tạm tính', value: s.subtotal),
          const SizedBox(height: 12),
          _BreakdownRow(label: 'Phí vận chuyển', value: s.shipping),
          const SizedBox(height: 12),
          _BreakdownRow(label: 'Thuế', value: s.tax),
          const SizedBox(height: 16),
          Divider(color: AppColors.checkoutSectionBorder, thickness: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tổng cộng', style: AppTextStyles.checkoutTotalLabel),
              Text(s.total, style: AppTextStyles.checkoutTotalValue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: GestureDetector(
            onTap: _onPlaceOrder,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.shopPrice,
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33006E1C),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text('Đặt hàng', style: AppTextStyles.checkoutPlaceOrderBtn),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 14,
              color: AppColors.checkoutSecureNote,
            ),
            const SizedBox(width: 6),
            Text(
              'Thanh toán được xử lý bảo mật và mã hóa.',
              style: AppTextStyles.checkoutSecureNote,
            ),
          ],
        ),
      ],
    );
  }

  Widget _imgError(BuildContext c, Object? e, StackTrace? s) =>
      Container(color: AppColors.checkoutCardBorder);
}

class CheckoutSummary {
  const CheckoutSummary({
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
  });

  final String subtotal;
  final String shipping;
  final String tax;
  final String total;
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.checkoutBreakdownLabel),
        Text(value, style: AppTextStyles.checkoutBreakdownValue),
      ],
    );
  }
}
