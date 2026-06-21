import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/shop/data/shop_api_service.dart';
import 'package:smartmush_farmer/features/shop/data/cart_api_service.dart';
import 'package:smartmush_farmer/features/shop/models/product.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final int productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ShopApiService _apiService = ShopApiService();
  final CartApiService _cartService = CartApiService();
  ProductModel? _product;
  List<ProductModel> _recommendedProducts = [];
  bool _isLoading = true;
  bool _isAddingToCart = false;
  String? _error;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final product = await _apiService.getProductById(widget.productId);
      
      // Load recommended products (same category)
      List<ProductModel> recommended = [];
      try {
        final allProducts = await _apiService.getProducts();
        recommended = allProducts
            .where((p) => p.categoryId == product.categoryId && p.id != product.id)
            .take(5)
            .toList();
      } catch (e) {
        debugPrint('Error loading recommended products: $e');
      }

      setState(() {
        _product = product;
        _recommendedProducts = recommended;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Không thể tải chi tiết sản phẩm.';
      });
    }
  }

  Future<void> _addToCart() async {
    if (_product == null) return;
    setState(() => _isAddingToCart = true);
    try {
      await _cartService.addItemToCart(
        productId: _product!.id,
        quantity: _quantity,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_product!.name} đã được thêm vào giỏ hàng'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
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
    } finally {
      if (mounted) setState(() => _isAddingToCart = false);
    }
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
                    _buildHeader(context),
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
                                        onPressed: _loadProduct,
                                        child: const Text('Thử lại'),
                                      ),
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _ProductHero(product: _product!),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _ProductInfo(product: _product!),
                                            const SizedBox(height: 20),
                                            _ProductDescription(product: _product!),
                                            const SizedBox(height: 20),
                                            _FeatureChips(),
                                            const SizedBox(height: 20),
                                            _buildQuantitySelector(),
                                            const SizedBox(height: 24),
                                            if (_recommendedProducts.isNotEmpty)
                                              _RecommendedSection(
                                                products: _recommendedProducts,
                                              ),
                                            const SizedBox(height: 100),
                                          ],
                                        ),
                                      ),
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
        onItemSelected: (item) {
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
        },
      ),
      bottomSheet: _product != null
          ? _BottomActions(
              product: _product!,
              isAdding: _isAddingToCart,
              onAddToCart: _addToCart,
            )
          : null,
    );
  }

  Widget _buildQuantitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SỐ LƯỢNG',
          style: AppTextStyles.loginFieldLabel.copyWith(
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.shopQuantitySelectorBg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0x4DBECAB9)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _QuantityButton(
                icon: Icons.remove,
                onTap: () {
                  if (_quantity > 1) setState(() => _quantity--);
                },
              ),
              Expanded(
                child: Text(
                  '$_quantity',
                  style: AppTextStyles.shopQuantity,
                  textAlign: TextAlign.center,
                ),
              ),
              _QuantityButton(
                icon: Icons.add,
                onTap: () => setState(() => _quantity++),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            'Chi tiết sản phẩm',
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
}

class _ProductHero extends StatelessWidget {
  const _ProductHero({required this.product});
  final ProductModel product;

  Widget _imgError(BuildContext c, Object? e, StackTrace? s) =>
      Container(
        color: AppColors.shopProductImageBg,
        child: const Center(
          child: Icon(
            Icons.image,
            color: AppColors.loginHint,
            size: 48,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0x4DBECAB9),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A4CAF50),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 348 / 300,
              child: product.imageUrl != null
                  ? Image.network(
                      product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: _imgError,
                    )
                  : _imgError(context, null, null),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Dot(isActive: true),
                  const SizedBox(width: 8),
                  _Dot(isActive: false),
                  const SizedBox(width: 8),
                  _Dot(isActive: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.shopPrice : AppColors.shopCategoryBorder,
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: AppTextStyles.shopDetailName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _Badge(
                    color: AppColors.shopProBadgeBg,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 12, color: AppColors.shopProBadge),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating} (124 đánh giá)',
                          style: AppTextStyles.shopRating.copyWith(
                            color: AppColors.shopProBadge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _Badge(
                    color: const Color(0x1A006E1C),
                    child: Text(
                      product.stockQuantity > 0 ? 'CÒN HÀNG' : 'HẾT HÀNG',
                      style: AppTextStyles.shopCategoryActive.copyWith(
                        color: product.stockQuantity > 0 ? AppColors.shopPrice : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          currencyFormat.format(product.price),
          style: AppTextStyles.shopDetailPrice,
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: child,
    );
  }
}

class _ProductDescription extends StatelessWidget {
  const _ProductDescription({required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.description ?? 'Không có mô tả cho sản phẩm này.',
          style: AppTextStyles.shopDetailDescription,
        ),
      ],
    );
  }
}

class _FeatureChips extends StatelessWidget {
  static const _features = [
    (Icons.wifi, 'WiFi'),
    (Icons.bolt, 'Tiết kiệm điện'),
    (Icons.auto_awesome, 'Tự động hóa'),
    (Icons.water_drop_outlined, 'Chống ẩm'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _features.map((f) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.shopFeatureChipBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(f.$1, size: 16, color: AppColors.shopTextPrimary),
              const SizedBox(width: 6),
              Text(f.$2, style: AppTextStyles.shopFeatureChip),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0x4DBECAB9)),
        ),
        child: Icon(icon, size: 18, color: AppColors.shopTextPrimary),
      ),
    );
  }
}

class _RecommendedSection extends StatelessWidget {
  const _RecommendedSection({required this.products});
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sản phẩm tương tự',
          style: AppTextStyles.shopSectionTitle,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (c, i) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
              return _RecommendedCard(
                name: product.name,
                price: currencyFormat.format(product.price),
                imageUrl: product.imageUrl ?? '',
                onTap: () {
                  context.pushReplacement('/shop/product-detail', extra: product.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.onTap,
  });

  final String name;
  final String price;
  final String imageUrl;
  final VoidCallback onTap;

  Widget _imgError(BuildContext c, Object? e, StackTrace? s) =>
      Container(color: AppColors.shopProductImageBg);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.shopRecommendedCardBorder),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 158 / 150,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: _imgError,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.shopRecommendedProductName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    price,
                    style: AppTextStyles.shopRecommendedPrice,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.product,
    required this.onAddToCart,
    required this.isAdding,
  });
  final ProductModel product;
  final VoidCallback onAddToCart;
  final bool isAdding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: AppColors.loginBackground,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A4CAF50),
            blurRadius: 6,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: isAdding ? null : onAddToCart,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.shopAddToCartBorder,
                      width: 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: isAdding
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Flexible(
                          child: Text(
                            'Thêm giỏ',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                AppTextStyles.shopAddToCartBtn.copyWith(fontSize: 18),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => context.push('/shop/checkout?from=buy-now'),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.shopBuyNowBtn,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33006E1C),
                        blurRadius: 15,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Mua ngay',
                    style: AppTextStyles.shopBuyNowBtn,
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
