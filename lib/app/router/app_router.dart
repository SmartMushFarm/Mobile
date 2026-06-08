import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_dashboard_screen.dart';
import 'package:smartmush_farmer/features/admin/admin_device_screen.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_device_detail_screen.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_orders_screen.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_users_screen.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_products_screen.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_categories_screen.dart';
import 'package:smartmush_farmer/features/admin/admin_maintenance_screen.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_alerts_screen.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_tickets_screen.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_profile_screen.dart';
import 'package:smartmush_farmer/features/alerts/alerts_screen.dart';
import 'package:smartmush_farmer/features/auth/login_screen.dart';
import 'package:smartmush_farmer/features/auth/register_screen.dart';
import 'package:smartmush_farmer/features/auth/splash_screen.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';
import 'package:smartmush_farmer/features/auth/models/user_model.dart';
import 'package:smartmush_farmer/features/shop/cart_screen.dart';
import 'package:smartmush_farmer/features/shop/checkout_screen.dart';
import 'package:smartmush_farmer/features/shop/order_history_screen.dart';
import 'package:smartmush_farmer/features/shop/product_detail_screen.dart';
import 'package:smartmush_farmer/features/shop/shop_screen.dart';
import 'package:smartmush_farmer/features/shop/payment_screen.dart';
import 'package:smartmush_farmer/features/shop/order_detail_screen.dart';
import 'package:smartmush_farmer/features/user/add_automation_rule_screen.dart';
import 'package:smartmush_farmer/features/user/box_automation_screen.dart';
import 'package:smartmush_farmer/features/user/box_control_screen.dart';
import 'package:smartmush_farmer/features/user/box_overview_screen.dart';
import 'package:smartmush_farmer/features/user/account_settings_screen.dart';
import 'package:smartmush_farmer/features/user/home_box_list_screen.dart';
import 'package:smartmush_farmer/features/user/create_maintenance_request_screen.dart';
import 'package:smartmush_farmer/features/user/create_preset_screen.dart';
import 'package:smartmush_farmer/features/user/maintenance_requests_screen.dart';
import 'package:smartmush_farmer/features/user/preset_list_screen.dart';
import 'package:smartmush_farmer/features/user/my_devices_screen.dart';
import 'package:smartmush_farmer/features/user/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final bool loggedIn = await AuthService.isLoggedIn();
    final String location = state.uri.toString();
    
    final bool isPublicPath = location == '/' || location == '/login' || location == '/register';

    if (!loggedIn) {
      return isPublicPath ? null : '/login';
    }

    // Nếu đã đăng nhập
    final userMap = await AuthService.getCurrentUser();
    
    // Nếu token tồn tại nhưng thông tin user lồng chưa có, cho phép truy cập
    if (userMap == null) return null;

    final user = UserModel.fromJson(userMap);
    final String role = (user.role ?? '').toLowerCase();

    // Logic chặn User vào trang Admin: Chỉ chặn nếu chắc chắn là role thấp
    if (location.startsWith('/admin') && (role == 'user' || role == 'customer' || role == 'member' || role == 'farmer')) {
      return '/home';
    }

    // Nếu Admin đang ở các trang công khai -> Chuyển về Dashboard
    if (role == 'admin' && isPublicPath && location != '/') {
      return '/admin';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeBoxListScreen(),
    ),
    GoRoute(
      path: '/box/overview',
      builder: (context, state) {
        final boxId = state.extra as String? ?? '';
        return BoxOverviewScreen(boxId: boxId);
      },
    ),
    GoRoute(
      path: '/box/control',
      builder: (context, state) {
        final boxId = state.extra as String? ?? '';
        return BoxControlScreen(boxId: boxId);
      },
    ),
    GoRoute(
      path: '/box/automation',
      builder: (context, state) {
        final boxId = state.extra as String? ?? '';
        return BoxAutomationScreen(boxId: boxId);
      },
    ),
    GoRoute(
      path: '/box/automation/add',
      builder: (context, state) {
        final boxId = state.extra as String? ?? '';
        return AddAutomationRuleScreen(boxId: boxId);
      },
    ),
    GoRoute(
      path: '/presets',
      builder: (context, state) => const PresetListScreen(),
    ),
    GoRoute(
      path: '/presets/create',
      builder: (context, state) => const CreatePresetScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/profile/devices',
      builder: (context, state) => const MyDevicesScreen(),
    ),
    GoRoute(
      path: '/profile/settings',
      builder: (context, state) => const AccountSettingsScreen(),
    ),
    GoRoute(
      path: '/shop',
      builder: (context, state) => const ShopScreen(),
    ),
    GoRoute(
      path: '/shop/product-detail',
      builder: (context, state) {
        final productId = state.extra as int? ?? 0;
        return ProductDetailScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/shop/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/shop/checkout',
      builder: (context, state) {
        final from = state.uri.queryParameters['from'];
        return CheckoutScreen(from: from);
      },
    ),
    GoRoute(
      path: '/shop/order-history',
      builder: (context, state) => const OrderHistoryScreen(),
    ),
    GoRoute(
      path: '/shop/order-detail',
      builder: (context, state) {
        final orderId = state.extra as int? ?? 0;
        return OrderDetailScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/shop/payment',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return PaymentScreen(
          orderId: extra['orderId'] as int? ?? 0,
          amount: extra['amount'] as double? ?? 0.0,
          paymentMethod: extra['paymentMethod'] as String? ?? 'QR',
        );
      },
    ),
    GoRoute(
      path: '/alerts',
      builder: (context, state) => const AlertsScreen(),
    ),
    GoRoute(
      path: '/maintenance',
      builder: (context, state) => const MaintenanceRequestsScreen(),
    ),
    GoRoute(
      path: '/maintenance/create',
      builder: (context, state) => const CreateMaintenanceRequestScreen(),
    ),
    // Admin Routes
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/admin/devices',
      builder: (context, state) => const AdminDeviceScreen(),
    ),
    GoRoute(
      path: '/admin/device-detail',
      builder: (context, state) {
        final deviceId = state.extra as String? ?? '';
        return AdminDeviceDetailScreen(deviceId: deviceId);
      },
    ),
    GoRoute(
      path: '/admin/users',
      builder: (context, state) => const AdminUsersScreen(),
    ),
    GoRoute(
      path: '/admin/profile',
      builder: (context, state) => const AdminProfileScreen(),
    ),
    GoRoute(
      path: '/admin/profile/settings',
      builder: (context, state) => const AccountSettingsScreen(),
    ),
    GoRoute(
      path: '/admin/orders',
      builder: (context, state) => const AdminOrdersScreen(),
    ),
    GoRoute(
      path: '/admin/products',
      builder: (context, state) => const AdminProductsScreen(),
    ),
    GoRoute(
      path: '/admin/categories',
      builder: (context, state) => const AdminCategoriesScreen(),
    ),
    GoRoute(
      path: '/admin/maintenance',
      builder: (context, state) => const AdminMaintenanceScreen(),
    ),
    GoRoute(
      path: '/admin/alerts',
      builder: (context, state) => const AdminAlertsScreen(),
    ),
    GoRoute(
      path: '/admin/tickets',
      builder: (context, state) => const AdminTicketsScreen(),
    ),
  ],
);
