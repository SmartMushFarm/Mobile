import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/shop/data/payment_api_service.dart';
import 'package:smartmush_farmer/features/shop/data/cart_api_service.dart';
import 'package:smartmush_farmer/features/shop/models/payment_model.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
  });

  final int orderId;
  final double amount;
  final String paymentMethod;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentApiService _paymentService = PaymentApiService();
  final CartApiService _cartService = CartApiService();
  PaymentModel? _payment;
  bool _isLoading = true;
  bool _isConfirming = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _createPayment();
  }

  Future<void> _createPayment() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final payment = await _paymentService.createPayment(
        orderId: widget.orderId,
        paymentMethod: widget.paymentMethod,
      );
      setState(() {
        _payment = payment;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Không thể tạo yêu cầu thanh toán. Vui lòng thử lại.';
      });
    }
  }

  Future<void> _confirmPayment() async {
    if (_payment == null) return;
    setState(() => _isConfirming = true);
    try {
      await _paymentService.confirmPayment(_payment!.id);
      await _cartService.clearCart();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thanh toán thành công'),
            backgroundColor: Colors.green,
          ),
        );
        context.pushReplacement('/shop/order-history');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xác nhận thanh toán thất bại'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isConfirming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: AppBar(
        title: const Text('Thanh toán'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: AppTextStyles.loginSubtitle),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _createPayment,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Quét mã để thanh toán',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Số tiền: ${currencyFormat.format(widget.amount)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.shopPrice,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_payment?.qrCode != null)
                        _buildQRCode(_payment!.qrCode!)
                      else
                        const Icon(Icons.qr_code, size: 200, color: Colors.grey),
                      const SizedBox(height: 32),
                      const Text(
                        'Sau khi chuyển khoản, vui lòng bấm nút bên dưới để xác nhận.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isConfirming ? null : _confirmPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.shopPrice,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isConfirming
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Xác nhận đã thanh toán',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildQRCode(String qrData) {
    if (qrData.startsWith('http')) {
      return Image.network(qrData, width: 250, height: 250);
    }
    // Assume base64 if not URL
    try {
      final bytes = base64Decode(qrData.split(',').last);
      return Image.memory(bytes, width: 250, height: 250);
    } catch (e) {
      return const Icon(Icons.broken_image, size: 200, color: Colors.red);
    }
  }
}
