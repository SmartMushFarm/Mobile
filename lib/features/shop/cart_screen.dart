import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/shop/models/cart_model.dart';
import 'package:smartmush_farmer/features/shop/models/cart_item.dart';
import 'package:smartmush_farmer/features/shop/data/cart_api_service.dart';
import 'package:smartmush_farmer/features/shop/widgets/cart_item_card.dart';
import 'package:smartmush_farmer/features/shop/widgets/order_summary_card.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartApiService _cartService = CartApiService();
  CartModel? _cart;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final cart = await _cartService.getCart();
      setState(() {
        _cart = cart;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Không thể tải giỏ hàng. Vui lòng thử lại.';
      });
    }
  }

  int get _itemCount => _cart?.items.fold(0, (sum, item) => sum! + item.quantity) ?? 0;

  Future<void> _onQuantityChanged(CartItemModel item, int quantity) async {
    if (quantity < 1) return;
    
    // Optimistic UI update
    setState(() {
      final index = _cart!.items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        final oldItem = _cart!.items[index];
        _cart!.items[index] = CartItemModel(
          id: oldItem.id,
          cartId: oldItem.cartId,
          productId: oldItem.productId,
          quantity: quantity,
          productName: oldItem.productName,
          productImageUrl: oldItem.productImageUrl,
          price: oldItem.price,
          subtotal: oldItem.price * quantity,
        );
      }
    });

    try {
      await _cartService.updateCartItemQuantity(
        cartItemId: item.id,
        quantity: quantity,
      );
      // Re-load to sync with server
      final cart = await _cartService.getCart();
      if (mounted) {
        setState(() {
          _cart = cart;
        });
      }
    } catch (e) {
      _showError('Không thể cập nhật số lượng');
      _loadCart(); // Rollback on error
    }
  }

  Future<void> _onRemoveItem(CartItemModel item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa sản phẩm'),
        content: Text('Bạn có chắc muốn xóa ${item.productName} khỏi giỏ hàng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final oldCart = _cart;
      setState(() {
        _cart = CartModel(
          id: _cart!.id,
          userId: _cart!.userId,
          items: _cart!.items.where((i) => i.id != item.id).toList(),
          totalAmount: _cart!.totalAmount - item.subtotal,
          createdAt: _cart!.createdAt,
        );
      });

      try {
        await _cartService.removeCartItem(item.id);
      } catch (e) {
        setState(() => _cart = oldCart); // Rollback
        _showError('Không thể xóa sản phẩm');
      }
    }
  }

  Future<void> _onClearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa tất cả'),
        content: const Text('Bạn có chắc muốn xóa toàn bộ giỏ hàng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _cartService.clearCart();
        _loadCart();
      } catch (e) {
        _showError('Không thể xóa giỏ hàng');
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _onCheckout() {
    if (_cart == null || _cart!.items.isEmpty) return;
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
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _error != null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(_error!, style: AppTextStyles.loginSubtitle),
                                      TextButton(onPressed: _loadCart, child: const Text('Thử lại')),
                                    ],
                                  ),
                                )
                              : _cart == null || _cart!.items.isEmpty
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
          if (_cart != null && _cart!.items.isNotEmpty)
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
            color: AppColors.shopTextSecondary.withOpacity(0.4),
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
          ..._cart!.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CartItemCard(
                item: item,
                onQuantityChanged: (qty) => _onQuantityChanged(item, qty),
                onRemove: () => _onRemoveItem(item),
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
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    
    double subtotal = _cart?.items.fold(0.0, (sum, item) => (sum ?? 0.0) + (item.price * item.quantity)) ?? 0.0;

    double shipping = subtotal > 0 ? 35000 : 0;
    double tax = subtotal * 0.05;
    double total = subtotal + shipping + tax;

    return CartSummary(
      subtotal: currencyFormat.format(subtotal),
      shipping: currencyFormat.format(shipping),
      tax: currencyFormat.format(tax),
      total: currencyFormat.format(total),
    );
  }
}
