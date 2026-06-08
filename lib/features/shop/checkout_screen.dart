import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/shop/models/cart_model.dart';
import 'package:smartmush_farmer/features/shop/data/cart_api_service.dart';
import 'package:smartmush_farmer/features/shop/data/order_api_service.dart';
import 'package:smartmush_farmer/features/shop/models/checkout_item.dart';
import 'package:smartmush_farmer/features/shop/widgets/checkout_section_card.dart';
import 'package:smartmush_farmer/features/shop/widgets/delivery_method_card.dart';
import 'package:smartmush_farmer/features/shop/widgets/payment_method_card.dart';
import 'package:smartmush_farmer/features/auth/models/user_model.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, this.from});

  final String? from;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartApiService _cartService = CartApiService();
  final OrderApiService _orderService = OrderApiService();
  CartModel? _cart;
  bool _isLoading = true;
  bool _isPlacingOrder = false;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _promoController = TextEditingController();

  DeliveryMethod _selectedDelivery = DeliveryMethod.standard;
  PaymentMethod _selectedPayment = PaymentMethod.cod;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _cartService.getCart(),
        AuthService.fetchMe(),
      ]);

      final cart = results[0] as CartModel?;
      final user = results[1] as UserModel?;

      setState(() {
        _cart = cart;
        if (user?.address != null && user!.address!.isNotEmpty) {
          _addressController.text = user.address!;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCart() async {
    // This is now handled in _loadInitialData
  }

  CheckoutSummary get _summary {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    double subtotal = _cart?.totalAmount ?? 0;
    double shipping = _selectedDelivery == DeliveryMethod.standard ? 35000 : 55000;
    double tax = (subtotal * 0.05);
    double total = subtotal + shipping + tax;
    
    return CheckoutSummary(
      subtotal: currencyFormat.format(subtotal),
      shipping: currencyFormat.format(shipping),
      tax: currencyFormat.format(tax),
      total: currencyFormat.format(total),
    );
  }

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

  Future<void> _onPlaceOrder() async {
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập địa chỉ giao hàng')),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);
    try {
      final order = await _orderService.checkout(
        shippingAddress: _addressController.text.trim(),
        paymentMethod: _selectedPayment == PaymentMethod.cod ? 'COD' : 'QR',
      );
      
      if (mounted) {
        if (_selectedPayment == PaymentMethod.cod) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đặt hàng thành công'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
          context.push('/shop/order-history');
        } else {
          context.push('/shop/payment', extra: {
            'orderId': order.id,
            'amount': order.totalAmount,
            'paymentMethod': 'QR',
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đặt hàng thất bại: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
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
    _addressController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: SafeArea(
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
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
                  'Địa chỉ giao hàng',
                  style: AppTextStyles.checkoutAddressName,
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: _addressController,
                  maxLines: 2,
                  style: AppTextStyles.checkoutAddressDetail,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    if (_cart == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tóm tắt đơn hàng', style: AppTextStyles.checkoutSectionTitle),
        const SizedBox(height: 12),
        ..._cart!.items.map((item) => Padding(
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
                      child: item.productImageUrl != null 
                        ? Image.network(
                          item.productImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: _imgError,
                        )
                        : _imgError(context, null, null),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName ?? 'Sản phẩm',
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
                      currencyFormat.format(item.price),
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
            onTap: _isPlacingOrder ? null : _onPlaceOrder,
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
              child: _isPlacingOrder 
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  )
                : Text('Đặt hàng', style: AppTextStyles.checkoutPlaceOrderBtn),
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
