import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/auth/widgets/login_form_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'farmer@smartmush.com');
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mock login successful'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Forgot password flow coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth.clamp(0.0, 448.0);
          final illustrationHeight = (constraints.maxHeight * 0.36)
              .clamp(220.0, 309.0)
              .toDouble();
          const formOverlap = 32.0;

          return Stack(
            children: [
              Positioned(
                top: -constraints.maxHeight * 0.1,
                left: -constraints.maxWidth * 0.1,
                child: Container(
                  width: constraints.maxWidth * 0.5,
                  height: constraints.maxHeight * 0.25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.splashGlow.withValues(alpha: 0.1),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.splashGlow.withValues(alpha: 0.1),
                        blurRadius: 32,
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxWidth,
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: illustrationHeight,
                          width: double.infinity,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              color: AppColors.loginIllustrationBg,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x0D4CAF50),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/images/login_illustration.png',
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -formOverlap),
                          child: LoginFormCard(
                            formKey: _formKey,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            isLoading: _isLoading,
                            onLogin: _handleLogin,
                            onForgotPassword: _handleForgotPassword,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
