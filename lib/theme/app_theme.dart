import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ============================================================
  // WHATSAPP BRAND COLORS
  // ============================================================

  // Main WhatsApp green
  static const Color primary = Color(0xFF04AF46);

  // Dark WhatsApp green
  static const Color primaryDark = Color(0xFF075E54);

  // WhatsApp teal/green
  static const Color accent = Color(0xFF128C7E);

  // ============================================================
  // APP SURFACES
  // ============================================================

  // Do NOT make the whole app background green.
  static const Color background = Color(0xFFF5F7F6);

  static const Color surface = Colors.white;

  // ============================================================
  // TEXT
  // ============================================================

  static const Color textPrimary = Color(0xFF17201D);

  static const Color textSecondary = Color(0xFF6B7773);

  // ============================================================
  // UTILITY
  // ============================================================

  static const Color divider = Color(0xFFE3E8E6);

  static const Color error = Color(0xFFD32F2F);

  // ============================================================
// DARK MODE
// ============================================================

  static const Color darkBackground = Color(0xFF101513);

  static const Color darkSurface = Color(0xFF18201D);

  static const Color darkSurfaceElevated = Color(0xFF202A26);

  static const Color darkTextPrimary = Color(0xFFF1F5F3);

  static const Color darkTextSecondary = Color(0xFF9AA8A3);

  static const Color darkDivider = Color(0xFF2C3833);
}


class AppTheme {
  AppTheme._();

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,

      secondary: AppColors.accent,
      onSecondary: Colors.white,

      surface: AppColors.surface,

      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,

      colorScheme: colorScheme,

      scaffoldBackgroundColor:
      AppColors.background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBarTheme: const AppBarTheme(
        backgroundColor:
        AppColors.primaryDark,

        foregroundColor:
        Colors.white,

        elevation: 0,

        centerTitle: false,
      ),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        height: 72,

        indicatorColor: AppColors.primary,

        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        iconTheme:
        WidgetStateProperty.all<IconThemeData>(
          const IconThemeData(
            color: Colors.white,
            size: 24,
          ),
        ),

        labelTextStyle:
        WidgetStateProperty.all<TextStyle>(
          const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ========================================================
      // CARDS
      // ========================================================

      cardTheme: CardThemeData(
        color:
        AppColors.surface,

        elevation: 0,

        margin: EdgeInsets.zero,

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(16),
        ),
      ),

      // ========================================================
      // DIVIDERS
      // ========================================================

      dividerTheme:
      const DividerThemeData(
        color:
        AppColors.divider,
      ),

      // ========================================================
      // CHIPS
      // ========================================================

      chipTheme: ChipThemeData(
        backgroundColor:
        AppColors.surface,

        selectedColor:
        AppColors.primary,

        disabledColor:
        AppColors.divider,

        side: const BorderSide(
          color: AppColors.divider,
        ),

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20),
        ),
      ),

      // ========================================================
      // SNACKBAR
      // ========================================================

      snackBarTheme:
      const SnackBarThemeData(
        behavior:
        SnackBarBehavior.floating,
      ),
    );
  }


  // ============================================================
  // DARK THEME
  // ============================================================

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.primaryDark,

      secondary: AppColors.accent,
      onSecondary: Colors.white,

      surface: AppColors.darkSurface,

      onSurface: AppColors.darkTextPrimary,

      error: AppColors.error,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,

      colorScheme: colorScheme,

      brightness: Brightness.dark,

      scaffoldBackgroundColor:
      AppColors.darkBackground,

      // ========================================================
      // APP BAR
      // ========================================================

      appBarTheme: const AppBarTheme(
        backgroundColor:
        AppColors.primaryDark,

        foregroundColor:
        Colors.white,

        elevation: 0,

        centerTitle: false,
      ),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      navigationBarTheme:
      NavigationBarThemeData(
        backgroundColor:
        AppColors.primaryDark,

        elevation: 0,

        height: 72,

        indicatorColor:
        AppColors.primary,

        indicatorShape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(16),
        ),

        iconTheme:
        WidgetStateProperty.all<
            IconThemeData>(
          const IconThemeData(
            color: Colors.white,
            size: 24,
          ),
        ),

        labelTextStyle:
        WidgetStateProperty.all<TextStyle>(
          const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ========================================================
      // CARDS
      // ========================================================

      cardTheme: CardThemeData(
        color: AppColors.darkSurface,

        elevation: 0,

        margin: EdgeInsets.zero,

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(16),
        ),
      ),

      // ========================================================
      // DIVIDERS
      // ========================================================

      dividerTheme:
      const DividerThemeData(
        color: AppColors.darkDivider,
      ),

      // ========================================================
      // CHIPS
      // ========================================================

      chipTheme: ChipThemeData(
        backgroundColor:
        AppColors.darkSurface,

        selectedColor:
        AppColors.primaryDark,

        disabledColor:
        AppColors.darkSurfaceElevated,

        side: const BorderSide(
          color: AppColors.darkDivider,
        ),

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20),
        ),

        labelStyle:
        const TextStyle(
          color: AppColors.darkTextPrimary,
        ),
      ),

      // ========================================================
      // SNACKBAR
      // ========================================================

      snackBarTheme:
      const SnackBarThemeData(
        behavior:
        SnackBarBehavior.floating,
      ),
    );
  }
}