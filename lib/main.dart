import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'features/auth/services/auth_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  // Khởi tạo trạng thái đăng nhập ban đầu
  await AuthNotifier().checkLoginStatus();

  runApp(const SmartMushApp());
}

class SmartMushApp extends StatelessWidget {
  const SmartMushApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SmartMush Farmer',
      theme: appTheme,
      routerConfig: appRouter,
    );
  }
}
