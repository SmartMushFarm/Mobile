import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_dashboard_screen.dart';
import 'package:smartmush_farmer/features/admin/admin_device_screen.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_orders_screen.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_users_screen.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_products_screen.dart';
import 'package:smartmush_farmer/features/admin/admin_maintenance_screen.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_alerts_screen.dart';
import 'package:smartmush_farmer/features/admin/screens/admin_tickets_screen.dart';
import 'package:smartmush_farmer/features/alerts/alerts_screen.dart';
import 'package:smartmush_farmer/features/auth/login_screen.dart';
import 'package:smartmush_farmer/features/auth/register_screen.dart';
import 'package:smartmush_farmer/features/auth/splash_screen.dart';
import 'package:smartmush_farmer/features/shop/cart_screen.dart';
import 'package:smartmush_farmer/features/shop/checkout_screen.dart';
import 'package:smartmush_farmer/features/shop/order_history_screen.dart';
import 'package:smartmush_farmer/features/shop/product_detail_screen.dart';
import 'package:smartmush_farmer/features/shop/shop_screen.dart';
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
        final productId = state.extra as String? ?? '';
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
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/admin/devices',
      builder: (context, state) => const AdminDeviceScreen(),
    ),
    GoRoute(
      path: '/admin/users',
      builder: (context, state) => const AdminUsersScreen(),
    ),
    GoRoute(
      path: '/admin/profile',
      builder: (context, state) => const AdminUsersScreen(),
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
