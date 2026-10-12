import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Màu chung, bảng màu ghi chú và giao diện của ứng dụng.
class AppColors {
  static const primary = Color(0xFF337AAA);
  static const ink = Color(0xFF315A78);
  static const muted = Color(0xFF617788);
  static const background = Color(0xFFF5F8FC);
  static const outline = Color(0xFFDFE8EF);
  static const primarySoft = Color(0xFFEAF4FB);
  static const bannerStart = Color(0xFFC8D9E8);
  static const bannerMiddle = Color(0xFFE6EDF3);
  static const bannerEnd = Color(0xFFF0CCD6);
  static const bannerBorder = Color(0xFFC2D3E2);
  static const bannerInk = Color(0xFF315A78);
}

class NoteColor {
  const NoteColor(this.label, this.background, this.accent);

  final String label;
  final Color background;
  final Color accent;
}

class NotePalette {
  // Mỗi màu gồm: tên, màu nền và màu nhấn. Giữ thứ tự để đọc màu đã lưu.
  static const colors = [
    NoteColor('Tím', Color(0xFFF0ECF8), Color(0xFF73628C)),
    NoteColor('Vàng', Color(0xFFFAF1D9), Color(0xFF816A34)),
    NoteColor('Xanh lá', Color(0xFFE9F2E9), Color(0xFF527263)),
    NoteColor('Xanh dương', Color(0xFFE8F2FA), Color(0xFF35729F)),
    NoteColor('Hồng', Color(0xFFF8E7EE), Color(0xFF8D5B6D)),
    NoteColor('Cam', Color(0xFFFAEBDC), Color(0xFF8C623F)),
  ];

  static NoteColor of(int index) =>
      colors[index >= 0 && index < colors.length ? index : 0];
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.ink,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.ink,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: _inputBorder(),
      enabledBorder: _inputBorder(),
      focusedBorder: _inputBorder(color: AppColors.primary, width: 2),
      contentPadding: const EdgeInsets.all(18),
      filled: true,
      fillColor: Colors.white,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: AppColors.ink,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );

  static OutlineInputBorder _inputBorder({
    Color color = AppColors.outline,
    double width = 1,
  }) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: color, width: width),
  );
}
