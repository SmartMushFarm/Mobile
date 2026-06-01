import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ProductHero(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _ProductInfo(),
                                  const SizedBox(height: 20),
                                  _ProductDescription(),
                                  const SizedBox(height: 20),
                                  _FeatureChips(),
                                  const SizedBox(height: 20),
                                  _QuantitySelector(),
                                  const SizedBox(height: 24),
                                  _RecommendedSection(),
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
      bottomSheet: _BottomActions(),
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
  const _ProductHero();

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
    const imageUrl =
        'https://www.figma.com/api/mcp/asset/ac070f7c-928b-46ef-9ede-d389227be3b8';

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
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: _imgError,
              ),
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
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Đèn LED trồng nấm thông minh',
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
                          '4.9 (124 đánh giá)',
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
                      'CÒN HÀNG',
                      style: AppTextStyles.shopCategoryActive.copyWith(
                        color: AppColors.shopPrice,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          '2.150.000đ',
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nâng cao mùa vụ với hệ thống chiếu sáng quang phổ tiên tiến. '
          'Được thiết kế đặc biệt cho ngành nấm học, giải pháp chiếu sáng này '
          'tiết kiệm đến 40% năng lượng trong khi hỗ trợ tự động hóa IoT đầy đủ. '
          'Bắt chước chu kỳ tự nhiên để tối ưu hóa sự hình thành và phát triển '
          'thể quả của nhiều loại nấm khác nhau.',
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

class _QuantitySelector extends StatefulWidget {
  @override
  State<_QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<_QuantitySelector> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
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
  static const _recommended = [
    (
      name: 'Cảm biến độ ẩm',
      price: '990.000đ',
      imageUrl:
          'https://www.figma.com/api/mcp/asset/be93343e-0e8c-423a-b563-f5fcd02fd193',
    ),
    (
      name: 'Vòi phun sương Pro',
      price: '590.000đ',
      imageUrl:
          'https://www.figma.com/api/mcp/asset/0270cf31-e61a-4031-b867-8dbfe7df5273',
    ),
    (
      name: 'Theo dõi CO2',
      price: '1.890.000đ',
      imageUrl:
          'https://www.figma.com/api/mcp/asset/541eb925-261f-4640-9d1b-1181c7c656eb',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gợi ý cho bạn',
          style: AppTextStyles.shopSectionTitle,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _recommended.length,
            separatorBuilder: (c, i) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = _recommended[index];
              return _RecommendedCard(
                name: item.name,
                price: item.price,
                imageUrl: item.imageUrl,
                onTap: () {},
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
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã thêm vào giỏ hàng'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
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
                  child: Flexible(
                    child: Text(
                      'Thêm giỏ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.shopAddToCartBtn.copyWith(fontSize: 18),
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
