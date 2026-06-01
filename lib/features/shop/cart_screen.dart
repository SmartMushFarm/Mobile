import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/shop/models/cart_item.dart';
import 'package:smartmush_farmer/features/shop/widgets/cart_item_card.dart';
import 'package:smartmush_farmer/features/shop/widgets/order_summary_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> _items;

  static const _lionsManeImage =
      'https://www.figma.com/api/mcp/asset/383f08e6-84cd-4007-bc77-49a35dea7b4f';
  static const _climateSensorImage =
      'https://www.figma.com/api/mcp/asset/dc85e945-563e-449a-9919-7f4b34e17293';

  @override
  void initState() {
    super.initState();
    _items = [
      const CartItem(
        id: 'lions-mane',
        name: 'Khối phôi nấm hầu thủ',
        description: 'Túi 5lb sẵn sàng thu hoạch',
        price: '590.000đ',
        imageUrl: _lionsManeImage,
        quantity: 1,
      ),
      const CartItem(
        id: 'climate-sensor',
        name: 'Cảm biến khí hậu thông minh',
        description: 'Nhiệt độ, độ ẩm & CO2',
        price: '890.000đ',
        imageUrl: _climateSensorImage,
        quantity: 2,
      ),
    ];
  }

  int get _itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  void _onQuantityChanged(int index, int quantity) {
    setState(() {
      _items = List.from(_items);
      _items[index] = CartItem(
        id: _items[index].id,
        name: _items[index].name,
        description: _items[index].description,
        price: _items[index].price,
        imageUrl: _items[index].imageUrl,
        quantity: quantity,
      );
    });
  }

  void _onRemoveItem(int index) {
    setState(() {
      _items = List.from(_items)..removeAt(index);
    });
  }

  void _onClearAll() {
    setState(() => _items.clear());
  }

  void _onCheckout() {
    context.push('/shop/checkout?from=cart');
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth.clamp(0.0, 672.0);

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: _items.isEmpty
                          ? _buildEmptyCart()
                          : _buildCartContent(),
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
          Expanded(
            child: Text(
              'Giỏ hàng',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.55,
                color: AppColors.shopPrice,
              ),
            ),
          ),
          if (_items.isNotEmpty)
            GestureDetector(
              onTap: _onClearAll,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  'XÓA HẾT',
                  style: AppTextStyles.cartClearBtn,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: AppColors.shopTextSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Giỏ hàng trống',
            style: AppTextStyles.loginSubtitle,
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Items count
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$_itemCount sản phẩm',
                style: AppTextStyles.cartItemCount,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Cart items list
          ...List.generate(_items.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CartItemCard(
                item: _items[index],
                onQuantityChanged: (qty) => _onQuantityChanged(index, qty),
                onRemove: () => _onRemoveItem(index),
              ),
            );
          }),
          const SizedBox(height: 32),
          // Order summary
          OrderSummaryCard(
            summary: _computedSummary(),
            onCheckout: _onCheckout,
          ),
        ],
      ),
    );
  }

  CartSummary _computedSummary() {
    // Parse prices from "590.000đ" format
    int subtotal = 0;
    for (final item in _items) {
      final numeric = item.price
          .replaceAll('đ', '')
          .replaceAll('.', '')
          .replaceAll(',', '');
      subtotal += (int.tryParse(numeric) ?? 0) * item.quantity;
    }

    final shipping = 35000;
    final tax = (subtotal * 0.05).round();
    final total = subtotal + shipping + tax;

    String fmt(int n) =>
        '${(n ~/ 1000).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ';

    return CartSummary(
      subtotal: fmt(subtotal),
      shipping: fmt(shipping),
      tax: fmt(tax),
      total: fmt(total),
    );
  }
}
