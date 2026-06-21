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
import 'package:smartmush_farmer/features/admin/screens/admin_preset_management_screen.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_promotions_screen.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_profile_screen.dart';
import 'package:smartmush_farmer/features/alerts/alerts_screen.dart';
import 'package:smartmush_farmer/features/auth/login_screen.dart';
import 'package:smartmush_farmer/features/auth/register_screen.dart';
import 'package:smartmush_farmer/features/auth/forgot_password_screen.dart';
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
import 'package:smartmush_farmer/features/technician/technician_tasks_screen.dart';
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
    
    final bool isPublicPath = location == '/' || location == '/login' || location == '/register' || location == '/forgot-password';

    if (!loggedIn) {
      return isPublicPath ? null : '/login';
    }

    // Nếu đã đăng nhập
    final userMap = await AuthService.getCurrentUser();
    
    // Nếu token tồn tại nhưng thông tin user lồng chưa có, cho phép truy cập
    if (userMap == null) return null;

    final user = UserModel.fromJson(userMap);
    final String role = (user.role ?? '').toLowerCase();

    // Điều hướng dựa trên role nếu truy cập các trang công khai sau khi đăng nhập
    if (isPublicPath && location != '/') {
      if (role == 'admin') return '/admin';
      if (role == 'technician') return '/technician';
      return '/home';
    }

    // Chặn truy cập chéo role
    if (location.startsWith('/admin') && role != 'admin') {
      return '/home';
    }
    if (location.startsWith('/technician') && role != 'technician') {
      return '/home';
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
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
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
      builder: (context, state) {
        final preset = state.extra as Map<String, dynamic>?;
        return CreatePresetScreen(preset: preset);
      },
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
    // Hứng Deep Link từ Payment Gateway
    GoRoute(
      path: '/payment/success',
      builder: (context, state) => const OrderHistoryScreen(),
    ),
    GoRoute(
      path: '/payment/cancel',
      builder: (context, state) => const OrderHistoryScreen(),
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
    GoRoute(
      path: '/admin/presets',
      builder: (context, state) => const AdminPresetManagementScreen(),
    ),
    GoRoute(
      path: '/admin/promotions',
      builder: (context, state) => const AdminPromotionsScreen(),
    ),
    // Technician Routes
    GoRoute(
      path: '/technician',
      builder: (context, state) => const TechnicianTasksScreen(),
    ),
  ],
);
