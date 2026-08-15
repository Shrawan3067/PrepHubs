import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryLight = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDark = Color(0xFF3730A3); // Indigo 800
  
  static const Color secondary = Color(0xFF0EA5E9); // Sky 500
  static const Color accent = Color(0xFF8B5CF6); // Violet 500
  static const Color emerald = Color(0xFF10B981); // Emerald 500
  static const Color amber = Color(0xFFF59E0B); // Amber 500
  static const Color rose = Color(0xFFF43F5E); // Rose 500
  static const Color gold = Color(0xFFD97706); // Gold / Premium

  // Light Mode Colors
  static const Color lightBg = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure White
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0); // Slate 200
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate 500
  static const Color lightTextMuted = Color(0xFF94A3B8); // Slate 400

  // Dark Mode Colors
  static const Color darkBg = Color(0xFF0B0F19); // Deep Midnight Slate
  static const Color darkSurface = Color(0xFF131C2E); // Dark Navy Surface
  static const Color darkCard = Color(0xFF1E293B); // Slate 800 Card
  static const Color darkBorder = Color(0xFF334155); // Slate 700
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkTextMuted = Color(0xFF64748B); // Slate 500

  // Helper method for hex color string conversion
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // Modern alpha helper to replace deprecated withOpacity
  static Color withAlpha(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}

