import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/auth/widgets/register_form_card.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateAccount() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.registerOTP(
        name: _nameController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      _showOTPDialog();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      String message = 'Đăng ký thất bại. Vui lòng thử lại.';
      if (e is DioException) {
        if (e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.connectionTimeout) {
          message = 'Máy chủ phản hồi chậm. Vui lòng kiểm tra kết nối mạng và thử lại.';
        } else if (e.response?.statusCode == 409) {
          message = 'Email này đã được sử dụng. Vui lòng chọn email khác.';
        } else if (e.response?.data != null && e.response?.data is Map) {
          message = e.response?.data['message'] ?? message;
        }
      } else if (e is Exception) {
        message = e.toString().replaceAll('Exception: ', '');
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showOTPDialog() {
    final otpController = TextEditingController();
    bool isVerifying = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Xác thực Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Mã OTP đã được gửi đến email của bạn. Vui lòng kiểm tra và nhập mã vào đây.'),
              const SizedBox(height: 16),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: '123456',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isVerifying ? null : () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: isVerifying ? null : () async {
                if (otpController.text.length < 6) return;
                
                setDialogState(() => isVerifying = true);
                try {
                  await AuthService.verifyRegistrationOTP(
                    email: _emailController.text.trim().toLowerCase(),
                    otp: otpController.text.trim(),
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Xác thực thành công! Hãy đăng nhập.'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                    context.go('/login');
                  }
                } catch (e) {
                  setDialogState(() => isVerifying = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mã OTP không đúng hoặc đã hết hạn')),
                  );
                }
              },
              child: isVerifying 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Xác nhận'),
            ),
          ],
        ),
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
          const formOverlap = 24.0;

          return Stack(
            children: [
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
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(24),
                          ),
                          child: SizedBox(
                            height: illustrationHeight,
                            width: double.infinity,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/images/register_illustration.png',
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        AppColors.splashLogoSurface
                                            .withValues(alpha: 0.6),
                                        AppColors.splashLogoSurface
                                            .withValues(alpha: 0),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -formOverlap),
                          child: RegisterFormCard(
                            formKey: _formKey,
                            nameController: _nameController,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            phoneController: _phoneController,
                            addressController: _addressController,
                            obscurePassword: _obscurePassword,
                            isLoading: _isLoading,
                            onTogglePasswordVisibility: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            onCreateAccount: _handleCreateAccount,
                            onLogin: () => context.go('/login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      color: AppColors.loginBackground.withValues(alpha: 0.5),
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => context.go('/login'),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.arrow_back,
                            size: 16,
                            color: AppColors.loginLabel,
                          ),
                        ),
                      ),
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
