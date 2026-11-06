import 'package:flutter/material.dart';

/// Bảng màu Light Theme – Thể thao tươi sáng, thoáng đãng, dễ đọc
class AppColors {
  // ── Brand / Primary ──────────────────────────────────────────────────────
  static const Color primary      = Color(0xFF059669); // Emerald 600 – sắc cỏ chính
  static const Color primaryLight = Color(0xFF34D399); // Emerald 400 – nhấn mạnh giá
  static const Color primaryDark  = Color(0xFF047857); // Emerald 700 – hover

  // ── Nền & bề mặt ────────────────────────────────────────────────────────
  static const Color background   = Color(0xFFF0FDF4); // Green-tinted white (very subtle)
  static const Color surface      = Color(0xFFFFFFFF); // Trắng thuần
  static const Color surfaceLight = Color(0xFFECFDF5); // Emerald 50 – chip / badge nền
  static const Color border       = Color(0xFFD1FAE5); // Emerald 100
  static const Color inputFill    = Color(0xFFF8FFFE); // Nhẹ hơn surface

  // ── Văn bản ─────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF064E3B); // Emerald 900 – tiêu đề đậm
  static const Color textSecondary = Color(0xFF065F46); // Emerald 800 – phụ đề
  static const Color textMuted     = Color(0xFF6B7280); // Cool gray 500

  // ── Ngữ nghĩa ────────────────────────────────────────────────────────────
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color danger  = Color(0xFFDC2626); // Red 600
  static const Color success = Color(0xFF059669); // Đồng nhất với primary
  static const Color info    = Color(0xFF2563EB); // Blue 600

  // ── Shadow helper ────────────────────────────────────────────────────────
  static BoxShadow get cardShadow => BoxShadow(
    color: const Color(0xFF059669).withValues(alpha: 0.10),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );
}
