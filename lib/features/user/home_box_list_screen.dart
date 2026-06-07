import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/box_card.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/user/models/mushroom_box.dart';
import 'package:smartmush_farmer/features/user/services/device_service.dart';

class HomeBoxListScreen extends StatefulWidget {
  const HomeBoxListScreen({super.key});

  @override
  State<HomeBoxListScreen> createState() => _HomeBoxListScreenState();
}

class _HomeBoxListScreenState extends State<HomeBoxListScreen> {
  UserNavItem _currentNav = UserNavItem.home;
  final DeviceService _deviceService = DeviceService();
  List<MushroomBox> _boxes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  bool _isStatusOn(dynamic value) {
    if (value == null) return false;
    final s = value.toString().toLowerCase();
    return s == 'on' || s == '1' || s == 'true' || s == 'active';
  }

  Future<void> _fetchDevices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final List<dynamic> data = await _deviceService.getMyDevices();
      setState(() {
        _boxes = data.map((d) {
          // Áp dụng linh hoạt mapping từ API sang Model
          return MushroomBox(
            id: d['id'].toString(),
            name: d['device_name'] ?? d['name'] ?? 'Thiết bị không tên',
            isOnline: d['status'] == 'Online' || d['status'] == 'Active' || d['isOnline'] == true,
            temperatureCelsius: (d['current_temperature'] ?? d['temperatureCelsius'] ?? 0).toInt(),
            humidityPercent: (d['current_humidity'] ?? d['humidityPercent'] ?? 0).toInt(),
            lightActive: _isStatusOn(d['mist_status']),
            fanActive: _isStatusOn(d['fan_status']),
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Không thể tải danh sách thiết bị';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  void _onNavSelected(UserNavItem item) {
    if (item == UserNavItem.home) {
      setState(() => _currentNav = item);
      return;
    }

    switch (item) {
      case UserNavItem.shop:
        context.push('/shop');
      case UserNavItem.alerts:
        context.push('/alerts');
      case UserNavItem.profile:
        context.push('/profile');
      case UserNavItem.home:
        break;
    }
  }

  void _onAddDevice() {
    final TextEditingController codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm thiết bị mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Nhập mã Claim Code được cung cấp để kết nối với thiết bị.'),
            const SizedBox(height: 16),
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Mã Claim Code',
                hintText: 'VD: ABC-123',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final code = codeController.text.trim();
              if (code.isEmpty) return;
              
              try {
                await _deviceService.claimDevice(code);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kết nối thiết bị thành công!')),
                  );
                  _fetchDevices(); // Refresh list
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.redAccent),
                  );
                }
              }
            },
            child: const Text('Kết nối'),
          ),
        ],
      ),
    );
  }

  void _onRemoveDevice(MushroomBox box) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận gỡ thiết bị'),
        content: Text('Bạn có chắc chắn muốn gỡ thiết bị "${box.name}" khỏi tài khoản không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _deviceService.removeOwner(int.parse(box.id));
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã gỡ thiết bị thành công')),
                  );
                  _fetchDevices();
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.redAccent),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Gỡ thiết bị'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddDevice,
        backgroundColor: AppColors.loginLink,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: UserBottomNav(
        currentItem: _currentNav,
        onItemSelected: _onNavSelected,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth.clamp(0.0, 448.0);

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: RefreshIndicator(
                  onRefresh: _fetchDevices,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _HomeHeader(),
                      ),
                      if (_isLoading)
                        const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (_errorMessage != null)
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_errorMessage!),
                                TextButton(
                                  onPressed: _fetchDevices,
                                  child: const Text('Thử lại'),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (_boxes.isEmpty)
                        const SliverFillRemaining(
                          child: Center(child: Text('Bạn chưa có thiết bị nào.')),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                          sliver: SliverList.separated(
                            itemCount: _boxes.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final box = _boxes[index];
                              return BoxCard(
                                box: box,
                                onTap: () => context.push(
                                  '/box/overview',
                                  extra: box.id,
                                ),
                                onRemove: () => _onRemoveDevice(box),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  String _getGreeting() {
    // Lấy giờ hiện tại của thiết bị (mặc định theo múi giờ hệ thống)
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Chào buổi sáng,';
    if (hour >= 12 && hour < 18) return 'Chào buổi chiều,';
    if (hour >= 18 && hour < 22) return 'Chào buổi tối,';
    return 'Chúc ngủ ngon,';
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final weekdayMap = {
      DateTime.monday: 'Thứ Hai',
      DateTime.tuesday: 'Thứ Ba',
      DateTime.wednesday: 'Thứ Tư',
      DateTime.thursday: 'Thứ Năm',
      DateTime.friday: 'Thứ Sáu',
      DateTime.saturday: 'Thứ Bảy',
      DateTime.sunday: 'Chủ Nhật',
    };
    
    final dayOfWeek = weekdayMap[now.weekday];
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year;
    
    return '$dayOfWeek, $day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: AppColors.loginBackground,
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/splash_logo.svg',
                width: 18,
                height: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'SmartMush Farmer',
                style: GoogleFonts.plusJakartaSans(
                  textStyle: AppTextStyles.homeAppBarTitle,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getFormattedDate(),
                      style: GoogleFonts.inter(
                        textStyle: AppTextStyles.loginSubtitle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getGreeting(),
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: AppTextStyles.homeGreeting,
                      ),
                    ),
                    Text(
                      'Người trồng nấm',
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: AppTextStyles.homeGreeting,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.avatarBorder, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A4CAF50),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/user_avatar.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
