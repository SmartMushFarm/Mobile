import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/category_chip.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/shop/data/shop_api_service.dart';
import 'package:smartmush_farmer/features/shop/data/cart_api_service.dart';
import 'package:smartmush_farmer/features/shop/models/product.dart';
import 'package:smartmush_farmer/features/shop/models/category_model.dart';
import 'package:smartmush_farmer/features/shop/widgets/product_card.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ShopApiService _apiService = ShopApiService();
  final CartApiService _cartService = CartApiService();
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  int? _selectedCategoryId;
  String _searchQuery = '';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _apiService.getProducts(),
        _apiService.getCategories(),
      ]);
      setState(() {
        _products = results[0] as List<ProductModel>;
        _categories = results[1] as List<CategoryModel>;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('ShopScreen _loadData Error: $e');
      setState(() {
        _isLoading = false;
        _error = 'Không thể tải dữ liệu. Vui lòng thử lại sau.';
      });
    }
  }

  void _onCategorySelected(int? categoryId) {
    setState(() => _selectedCategoryId = categoryId);
  }

  void _onProductTap(ProductModel product) {
    context.push('/shop/product-detail', extra: product.id);
  }

  // Chuyển string tiếng Việt có dấu thành không dấu và viết thường
  String _toNoDiacritics(String str) {
    var result = str.toLowerCase();
    result = result.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
    result = result.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
    result = result.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
    result = result.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
    result = result.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
    result = result.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
    result = result.replaceAll(RegExp(r'[đ]'), 'd');
    
    // Xóa các ký tự kết hợp (combining marks) nếu còn
    result = result.replaceAll(RegExp(r'[\u0300-\u036f]'), '');
    return result;
  }

  Future<void> _onAddToCart(ProductModel product) async {
    try {
      await _cartService.addItemToCart(productId: product.id, quantity: 1);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} đã được thêm vào giỏ hàng'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể thêm vào giỏ hàng. Vui lòng thử lại.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
    final filteredProducts = _products.where((p) {
      final matchesCategory =
          _selectedCategoryId == null || p.categoryId == _selectedCategoryId;

      final productNameNormalized = _toNoDiacritics(p.name);
      final queryNormalized = _toNoDiacritics(_searchQuery);

      final matchesSearch = _searchQuery.isEmpty ||
          productNameNormalized.contains(queryNormalized);

      return matchesCategory && matchesSearch;
    }).toList();

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
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _error != null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(_error!, style: AppTextStyles.loginSubtitle),
                                      TextButton(
                                        onPressed: _loadData,
                                        child: const Text('Thử lại'),
                                      ),
                                    ],
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: _loadData,
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildSearchBar(),
                                        const SizedBox(height: 12),
                                        _buildCategoryChips(),
                                        const SizedBox(height: 20),
                                        _buildProductGrid(filteredProducts),
                                      ],
                                    ),
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
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: AppTextStyles.shopSearchHint.copyWith(color: AppColors.shopTextPrimary),
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
            isSelected: _selectedCategoryId == null,
            onTap: () => _onCategorySelected(null),
          ),
          ..._categories.map((category) => Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CategoryChip(
                  label: category.name,
                  isSelected: _selectedCategoryId == category.id,
                  onTap: () => _onCategorySelected(category.id),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            'Không có sản phẩm nào',
            style: AppTextStyles.loginSubtitle,
          ),
        ),
      );
    }

    final standardProducts =
        products.where((p) => !p.isWideCard).toList();
    final wideProducts =
        products.where((p) => p.isWideCard).toList();

    return Column(
      children: [
        if (standardProducts.isNotEmpty) ...[
          for (int i = 0; i < standardProducts.length; i += 2) ...[
            if (i > 0) const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ProductCard(
                    product: standardProducts[i],
                    onTap: () => _onProductTap(standardProducts[i]),
                    onAddToCart: () => _onAddToCart(standardProducts[i]),
                  ),
                ),
                const SizedBox(width: 12),
                if (i + 1 < standardProducts.length)
                  Expanded(
                    child: ProductCard(
                      product: standardProducts[i + 1],
                      onTap: () => _onProductTap(standardProducts[i + 1]),
                      onAddToCart: () => _onAddToCart(standardProducts[i + 1]),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ],
        if (wideProducts.isNotEmpty) ...[
          const SizedBox(height: 12),
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
