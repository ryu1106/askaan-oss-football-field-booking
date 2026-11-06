import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // ── Đọc từ file assets/env/.env (với fallback an toàn) ──────────────────

  /// IP LAN của máy tính chủ (dùng khi test trên điện thoại thật cùng Wi-Fi)
  static String get localLanIp =>
      dotenv.maybeGet('LAN_IP') ?? '192.168.2.20';

  /// Cổng máy chủ backend Node.js
  static String get port =>
      dotenv.maybeGet('BACKEND_PORT') ?? '5000';

  // Đổi thành true nếu bạn test trên điện thoại thật cắm cáp / Wi-Fi
  static bool isPhysicalDevice = false;

  /// Tự động xác định Base URL phù hợp với từng môi trường chạy:
  /// - Android Emulator (máy ảo): Dùng 10.0.2.2 trỏ về localhost máy tính
  /// - Web / Windows / macOS: Dùng localhost
  /// - Điện thoại thật Android/iOS: Dùng IP LAN nội bộ máy tính
  static String get baseUrl {
    // Ưu tiên biến API_BASE_URL nếu được cấu hình tường minh trong .env
    final envUrl = dotenv.maybeGet('API_BASE_URL');

    if (kIsWeb) {
      return envUrl ?? 'http://localhost:$port/api';
    }
    if (Platform.isAndroid) {
      if (isPhysicalDevice) {
        return envUrl ?? 'http://$localLanIp:$port/api';
      }
      return envUrl ?? 'http://10.0.2.2:$port/api';
    }
    return envUrl ?? 'http://localhost:$port/api';
  }

  /// Máy chủ gốc để tải ảnh tĩnh (/uploads/...)
  static String get hostUrl {
    final base = baseUrl;
    return base.replaceAll('/api', '');
  }

  /// Hàm chuẩn hóa URL hình ảnh từ Backend
  static String formatImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://images.unsplash.com/photo-1529900748604-07564a03e7a6?w=600';
    }
    // Nếu đã là chuỗi Base64 Data URI thì giữ nguyên không nối host
    if (path.startsWith('data:image')) {
      return path;
    }
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    // Nếu là đường dẫn cục bộ trên server
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$hostUrl$cleanPath';
  }
}

