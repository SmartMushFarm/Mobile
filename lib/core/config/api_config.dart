import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:5000/api';
  }

  static String get products => '$baseUrl/products';
  static String productById(int id) => '$baseUrl/products/$id';

  static String get categories => '$baseUrl/categories';
  static String categoryById(int id) => '$baseUrl/categories/$id';

  // Cart
  static String get cart => '$baseUrl/cart';
  static String get cartItems => '$baseUrl/cart/items';
  static String cartItemById(int id) => '$baseUrl/cart/items/$id';
  static String get clearCart => '$baseUrl/cart/clear';

  // Orders
  static String get checkout => '$baseUrl/orders/checkout';
  static String get myOrders => '$baseUrl/orders/my-orders';
  static String orderById(int id) => '$baseUrl/orders/$id';
  static String cancelOrder(int id) => '$baseUrl/orders/$id/cancel';

  // Admin Orders
  static String get adminOrders => '$baseUrl/admin/orders';
  static String updateOrderStatus(int id) => '$baseUrl/admin/orders/$id/status';

  // Payments
  static String get paymentsCreate => '$baseUrl/payments/create';
  static String paymentByOrderId(int orderId) => '$baseUrl/payments/order/$orderId';
  static String paymentConfirm(int id) => '$baseUrl/payments/$id/confirm';

  // Auth
  static String get authMe => '$baseUrl/auth/me';
  static String get authChangePassword => '$baseUrl/auth/change-password';
  static String get authUsers => '$baseUrl/auth/users';
  static String authUserById(int id) => '$baseUrl/auth/users/$id';
  static String authUserStatus(int id) => '$baseUrl/auth/users/$id/status';

  // Promotions
  static String get promotions => '$baseUrl/promotions';
  static String promotionById(int id) => '$baseUrl/promotions/$id';
}
