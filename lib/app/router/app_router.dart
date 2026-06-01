import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/features/alerts/alerts_screen.dart';
import 'package:smartmush_farmer/features/auth/login_screen.dart';
import 'package:smartmush_farmer/features/auth/register_screen.dart';
import 'package:smartmush_farmer/features/auth/splash_screen.dart';
import 'package:smartmush_farmer/features/shop/shop_screen.dart';
import 'package:smartmush_farmer/features/user/add_automation_rule_screen.dart';
import 'package:smartmush_farmer/features/user/box_automation_screen.dart';
import 'package:smartmush_farmer/features/user/box_control_screen.dart';
import 'package:smartmush_farmer/features/user/box_overview_screen.dart';
import 'package:smartmush_farmer/features/user/home_box_list_screen.dart';
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
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/shop',
      builder: (context, state) => const ShopScreen(),
    ),
    GoRoute(
      path: '/alerts',
      builder: (context, state) => const AlertsScreen(),
    ),
  ],
);
