import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../storage/auth_storage.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    ),
  );

  static bool _interceptorAdded = false;

  static Dio get instance {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    
    if (!_interceptorAdded) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = await AuthStorage.getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            return handler.next(options);
          },
          onError: (DioException e, handler) {
            if (e.response?.statusCode == 401) {
              // Handle unauthorized
            }
            return handler.next(e);
          },
        ),
      );
      _interceptorAdded = true;
    }
    return _dio;
  }
}
