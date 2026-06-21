import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  
  int _step = 1; // 1: Email, 2: OTP & New Password
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOTP() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showSnackBar('Vui lòng nhập email hợp lệ', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.forgotPassword(email: email);
      setState(() {
        _isLoading = false;
        _step = 2;
      });
      _showSnackBar('Mã OTP đã được gửi đến email của bạn');
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Lỗi: ${e.toString()}', isError: true);
    }
  }

  Future<void> _handleResetPassword() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    final newPassword = _newPasswordController.text;

    if (otp.isEmpty || newPassword.isEmpty) {
      _showSnackBar('Vui lòng điền đầy đủ thông tin', isError: true);
      return;
    }
    if (newPassword.length < 8) {
      _showSnackBar('Mật khẩu phải có ít nhất 8 ký tự', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.resetPasswordOTP(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      if (mounted) {
        _showSnackBar('Đặt lại mật khẩu thành công! Hãy đăng nhập lại.');
        context.go('/login');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Lỗi: ${e.toString()}', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: AppBar(
        title: const Text('Quên mật khẩu'),
        backgroundColor: AppColors.loginBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.loginLabel),
          onPressed: () => _step == 1 ? context.pop() : setState(() => _step = 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _step == 1 ? 'Nhập Email của bạn' : 'Xác thực OTP & Mật khẩu mới',
              style: AppTextStyles.registerTitle,
            ),
            const SizedBox(height: 8),
            Text(
              _step == 1 
                ? 'Chúng tôi sẽ gửi một mã OTP đến email này để xác nhận quyền sở hữu.'
                : 'Nhập mã OTP 6 số và mật khẩu mới bạn muốn đặt.',
              style: AppTextStyles.loginSubtitle,
            ),
            const SizedBox(height: 32),
            if (_step == 1) ...[
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ Email',
                  hintText: 'nguoi@smartmush.com',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
              const SizedBox(height: 24),
              _buildButton('Gửi mã OTP', _handleSendOTP),
            ] else ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Mã OTP (6 số)',
                  hintText: '123456',
                  prefixIcon: Icon(Icons.password_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu mới',
                  hintText: '••••••••',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),
              _buildButton('Đặt lại mật khẩu', _handleResetPassword),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: _isLoading ? null : () => setState(() => _step = 1),
                  child: const Text('Quay lại nhập email', style: TextStyle(color: AppColors.loginLink)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isLoading 
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
