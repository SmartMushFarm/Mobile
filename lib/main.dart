import 'package:flutter/material.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';

void main() {
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