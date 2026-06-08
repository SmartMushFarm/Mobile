import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/shop/data/order_api_service.dart';
import 'package:smartmush_farmer/features/shop/models/order_model.dart';
import 'package:smartmush_farmer/features/shop/data/payment_api_service.dart';
import 'package:smartmush_farmer/features/shop/models/payment_model.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final OrderApiService _orderService = OrderApiService();
  final PaymentApiService _paymentService = PaymentApiService();
  OrderModel? _order;
  PaymentModel? _payment;
  bool _isLoading = true;
  bool _isCancelling = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrderDetail();
  }

  Future<void> _loadOrderDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final order = await _orderService.getOrderDetail(widget.orderId);
      final payment = await _paymentService.getPaymentByOrderId(widget.orderId);
      setState(() {
        _order = order;
        _payment = payment;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Không thể tải chi tiết đơn hàng.';
      });
    }
  }

  Future<void> _cancelOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy đơn hàng'),
        content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Không')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hủy đơn', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Optimistic UI update
      final previousStatus = _order!.status;
      setState(() {
        _order = OrderModel(
          id: _order!.id,
          userId: _order!.userId,
          promotionId: _order!.promotionId,
          orderDate: _order!.orderDate,
          status: 'Cancelled',
          totalAmount: _order!.totalAmount,
          shippingAddress: _order!.shippingAddress,
          createdAt: _order!.createdAt,
          userName: _order!.userName,
          details: _order!.details,
        );
      });

      try {
        await _orderService.cancelOrder(widget.orderId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã hủy đơn hàng thành công')),
          );
        }
      } catch (e) {
        if (mounted) {
          // Rollback
          setState(() {
            _order = OrderModel(
              id: _order!.id,
              userId: _order!.userId,
              promotionId: _order!.promotionId,
              orderDate: _order!.orderDate,
              status: previousStatus,
              totalAmount: _order!.totalAmount,
              shippingAddress: _order!.shippingAddress,
              createdAt: _order!.createdAt,
              userName: _order!.userName,
              details: _order!.details,
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Hủy đơn hàng thất bại'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
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
                      ElevatedButton(onPressed: _loadOrderDetail, child: const Text('Thử lại')),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Mã đơn hàng', '#${_order!.id}'),
                      _buildInfoRow('Ngày đặt', dateFormat.format(_order!.createdAt ?? DateTime.now())),
                      _buildInfoRow('Trạng thái', _order!.status, color: _getStatusColor(_order!.status)),
                      const SizedBox(height: 24),
                      const Text('Sản phẩm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ...(_order!.details ?? []).map((detail) => _buildProductItem(detail, currencyFormat)),
                      const Divider(height: 32),
                      _buildInfoRow('Tạm tính', currencyFormat.format(_order!.totalAmount)),
                      _buildInfoRow('Tổng cộng', currencyFormat.format(_order!.totalAmount), isBold: true),
                      const SizedBox(height: 24),
                      if (_order!.shippingAddress != null) ...[
                        const Text('Địa chỉ giao hàng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(_order!.shippingAddress!, style: const TextStyle(color: Colors.grey)),
                      ],
                      const SizedBox(height: 24),
                      if (_payment != null) ...[
                        const Text('Thông tin thanh toán', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        _buildInfoRow('Phương thức', _payment!.paymentMethod),
                        _buildInfoRow('Trạng thái', _payment!.paymentStatus, color: _getPaymentStatusColor(_payment!.paymentStatus)),
                        if (_payment!.paidAt != null)
                          _buildInfoRow('Ngày thanh toán', dateFormat.format(_payment!.paidAt!)),
                      ],
                      const SizedBox(height: 40),
                      if (_order!.status.toLowerCase() == 'pending')
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: _isCancelling ? null : _cancelOrder,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isCancelling
                                ? const CircularProgressIndicator(color: Colors.red)
                                : const Text('Hủy đơn hàng'),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(dynamic detail, NumberFormat format) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: detail.productImageUrl != null
                ? Image.network(detail.productImageUrl!, fit: BoxFit.cover)
                : const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detail.productName ?? 'Sản phẩm', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('SL: ${detail.quantity}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(format.format(detail.price)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'confirmed': return Colors.blue;
      case 'shipping': return Colors.purple;
      case 'completed': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'paid': return Colors.green;
      case 'failed': return Colors.red;
      case 'refunded': return Colors.blue;
      default: return Colors.grey;
    }
  }
}
