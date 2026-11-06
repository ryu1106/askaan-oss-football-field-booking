import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  Dio? _dio;

  ApiClient._internal();

  /// Lazy getter — Dio chỉ được khởi tạo lần đầu tiên khi gọi API,
  /// lúc đó dotenv đã được load xong nên ApiConstants.baseUrl trả đúng giá trị.
  Dio get dio {
    if (_dio != null) return _dio!;

    final resolvedUrl = ApiConstants.baseUrl;

    _dio = Dio(
      BaseOptions(
        baseUrl: resolvedUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor tự động gán Bearer Token vào mọi request
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          String message = 'Đã có lỗi xảy ra. Vui lòng thử lại!';

          if (e.response != null && e.response?.data != null) {
            final data = e.response?.data;
            if (data is Map && data.containsKey('message')) {
              message = data['message'].toString();
            }
          } else if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout) {
            message = 'Hết thời gian chờ kết nối máy chủ.';
          } else if (e.type == DioExceptionType.connectionError) {
            message =
                'Không thể kết nối đến máy chủ ($resolvedUrl). '
                'Vui lòng kiểm tra backend đã chạy chưa.';
          }

          return handler.next(
            DioException(
              requestOptions: e.requestOptions,
              response: e.response,
              type: e.type,
              error: message,
            ),
          );
        },
      ),
    );

    return _dio!;
  }

  /// Trả về baseUrl đang được dùng — tiện để debug
  String get currentBaseUrl => ApiConstants.baseUrl;
}
