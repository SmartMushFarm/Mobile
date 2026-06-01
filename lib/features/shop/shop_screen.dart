import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/category_chip.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/shop/data/mock_products.dart';
import 'package:smartmush_farmer/features/shop/models/product.dart';
import 'package:smartmush_farmer/features/shop/widgets/product_card.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  ProductCategory _selectedCategory = ProductCategory.all;
  int _cartCount = 2;

  void _onCategorySelected(ProductCategory category) {
    setState(() => _selectedCategory = category);
  }

  void _onProductTap(Product product) {
    context.push('/shop/product-detail', extra: product.id);
  }

  void _onAddToCart(Product product) {
    setState(() => _cartCount++);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} đã được thêm vào giỏ hàng'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onBottomNavSelected(UserNavItem item) {
    switch (item) {
      case UserNavItem.home:
        context.go('/home');
      case UserNavItem.shop:
        break;
      case UserNavItem.alerts:
        context.push('/alerts');
      case UserNavItem.profile:
        context.push('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = productsByCategory(_selectedCategory);

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
                            _buildSearchBar(),
                            const SizedBox(height: 12),
                            _buildCategoryChips(),
                            const SizedBox(height: 20),
                            _buildProductGrid(products),
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
      floatingActionButton: _buildCartFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.loginBackground,
      child: Row(
        children: [
          Text(
            'SmartMush Farmer',
            style: GoogleFonts.plusJakartaSans(
              textStyle: AppTextStyles.homeAppBarTitle,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.loginLabel),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.shopSearchFill,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        style: AppTextStyles.shopSearchHint,
        decoration: InputDecoration(
          hintText: 'Tìm phôi nấm, thiết bị...',
          hintStyle: AppTextStyles.shopSearchHint,
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.loginLabel,
            size: 20,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CategoryChip(
            label: 'Tất cả',
            isSelected: _selectedCategory == ProductCategory.all,
            onTap: () => _onCategorySelected(ProductCategory.all),
          ),
          const SizedBox(width: 8),
          CategoryChip(
            label: 'Thiết bị',
            isSelected: _selectedCategory == ProductCategory.devices,
            onTap: () => _onCategorySelected(ProductCategory.devices),
          ),
          const SizedBox(width: 8),
          CategoryChip(
            label: 'Phôi nấm',
            isSelected: _selectedCategory == ProductCategory.spawn,
            onTap: () => _onCategorySelected(ProductCategory.spawn),
          ),
          const SizedBox(width: 8),
          CategoryChip(
            label: 'Bộ kit',
            isSelected: _selectedCategory == ProductCategory.kits,
            onTap: () => _onCategorySelected(ProductCategory.kits),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    if (products.isEmpty) {
      return Center(
        child: Text(
          'Không có sản phẩm nào',
          style: AppTextStyles.loginSubtitle,
        ),
      );
    }

    final standardProducts =
        products.where((p) => !p.isWideCard).toList();
    final wideProducts =
        products.where((p) => p.isWideCard).toList();

    return Column(
      children: [
        if (standardProducts.length >= 2) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < 2 && i < standardProducts.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(
                  child: ProductCard(
                    product: standardProducts[i],
                    onTap: () => _onProductTap(standardProducts[i]),
                    onAddToCart: () => _onAddToCart(standardProducts[i]),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
        ],
        ...wideProducts.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ProductCard(
              product: p,
              onTap: () => _onProductTap(p),
              onAddToCart: () => _onAddToCart(p),
            ),
          ),
        ),
        if (standardProducts.length > 2) ...[
          for (int i = 2; i < standardProducts.length; i += 2) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int j = i;
                    j < i + 2 && j < standardProducts.length;
                    j++) ...[
                  if (j > i) const SizedBox(width: 12),
                  Expanded(
                    child: ProductCard(
                      product: standardProducts[j],
                      onTap: () => _onProductTap(standardProducts[j]),
                      onAddToCart: () => _onAddToCart(standardProducts[j]),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildCartFab() {
    return GestureDetector(
      onTap: () => context.push('/shop/cart'),
      child: SizedBox(
        width: 56,
        height: 56,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.shopPrice,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x264CAF50),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
