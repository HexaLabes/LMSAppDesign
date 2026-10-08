import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InstituteThemePreset {
  final String id;
  final String name;
  final String subtitle;
  final Color primary;
  final Color primaryLight;
  final Color accent;

  const InstituteThemePreset({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.primary,
    required this.primaryLight,
    required this.accent,
  });
}

class AppColors {
  // Theme Presets (Matching all types of institutes)
  static const List<InstituteThemePreset> presets = [
    InstituteThemePreset(
      id: 'sapphire',
      name: 'Royal Sapphire',
      subtitle: 'Universal Academic Blue',
      primary: Color(0xFF1D4ED8),
      primaryLight: Color(0xFF3B82F6),
      accent: Color(0xFFEA580C),
    ),
    InstituteThemePreset(
      id: 'indigo',
      name: 'Modern Indigo',
      subtitle: 'Tech & IT Academy',
      primary: Color(0xFF4F46E5),
      primaryLight: Color(0xFF6366F1),
      accent: Color(0xFF06B6D4),
    ),
    InstituteThemePreset(
      id: 'emerald',
      name: 'Emerald Green',
      subtitle: 'Health & Safety Training',
      primary: Color(0xFF165B3B),
      primaryLight: Color(0xFF10B981),
      accent: Color(0xFFE95D34),
    ),
    InstituteThemePreset(
      id: 'crimson',
      name: 'Crimson Burgundy',
      subtitle: 'Medical & Classical Institute',
      primary: Color(0xFF991B1B),
      primaryLight: Color(0xFFDC2626),
      accent: Color(0xFFF59E0B),
    ),
    InstituteThemePreset(
      id: 'purple',
      name: 'Royal Violet',
      subtitle: 'Modern Innovation & Arts',
      primary: Color(0xFF6D28D9),
      primaryLight: Color(0xFF8B5CF6),
      accent: Color(0xFFEC4899),
    ),
    InstituteThemePreset(
      id: 'slate',
      name: 'Executive Slate',
      subtitle: 'Corporate & Management LMS',
      primary: Color(0xFF0F172A),
      primaryLight: Color(0xFF334155),
      accent: Color(0xFF3B82F6),
    ),
  ];

  // Default Primary & Accents (Sapphire Blue as universal default)
  static const Color primaryBlue = Color(0xFF1D4ED8);
  static const Color primaryBlueLight = Color(0xFF3B82F6);
  // Backwards-compatibility aliases
  static const Color primaryGreen = Color(0xFF1D4ED8);
  static const Color primaryGreenLight = Color(0xFF3B82F6);
  static const Color accentOrange = Color(0xFFEA580C);
  static const Color accentOrangeLight = Color(0xFFFF6E4A);

  // Light Mode Colors
  static const Color lightBg = Color(0xFFFAF7F2);
  static const Color lightCardBg = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFEFECE5);
  static const Color lightTextPrimary = Color(0xFF1E2125);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextMuted = Color(0xFF9CA3AF);

  // Dark Mode Colors
  static const Color darkBg = Color(0xFF0F1216);
  static const Color darkCardBg = Color(0xFF181C23);
  static const Color darkCardElevated = Color(0xFF202630);
  static const Color darkBorder = Color(0xFF28303D);
  static const Color darkTextPrimary = Color(0xFFF3F4F6);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkTextMuted = Color(0xFF6B7280);

  // Badge Colors
  static const Color badgeFree = Color(0xFF1D4ED8);
  static const Color badgePro = Color(0xFFEA580C);
  static const Color badgeAttempt = Color(0xFF1D4ED8);
  static const Color starYellow = Color(0xFFFBBF24);

  // Status & Chart Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color chartFill = Color(0x331D4ED8);
}

class AppTheme {
  static ThemeData getLightTheme([Color? primary, Color? accent]) {
    final primaryCol = primary ?? AppColors.primaryBlue;
    final accentCol = accent ?? AppColors.accentOrange;
    final baseTextTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      primaryColor: primaryCol,
      colorScheme: ColorScheme.light(
        primary: primaryCol,
        secondary: accentCol,
        surface: AppColors.lightCardBg,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
      ),
      cardTheme: CardTheme(
        color: AppColors.lightCardBg,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryCol,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: AppColors.lightTextPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
          letterSpacing: -0.3,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryCol,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return accentCol;
          }
          return const Color(0xFFD1D5DB);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryCol, width: 1.8),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.lightTextMuted,
          fontSize: 14,
        ),
      ),
    );
  }

  static ThemeData getDarkTheme([Color? primary, Color? accent]) {
    final primaryCol = primary ?? AppColors.primaryBlueLight;
    final accentCol = accent ?? AppColors.accentOrangeLight;
    final baseTextTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      primaryColor: primaryCol,
      colorScheme: ColorScheme.dark(
        primary: primaryCol,
        secondary: accentCol,
        surface: AppColors.darkCardBg,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
      ),
      cardTheme: CardTheme(
        color: AppColors.darkCardBg,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkCardBg,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: AppColors.darkTextPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextPrimary,
          letterSpacing: -0.3,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AppColors.darkTextPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.darkTextSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryCol,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return accentCol;
          }
          return const Color(0xFF4B5563);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCardBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryCol, width: 1.8),
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.darkTextMuted,
          fontSize: 14,
        ),
      ),
    );
  }

  // Backwards compatibility getter
  static ThemeData get lightTheme => getLightTheme();
  static ThemeData get darkTheme => getDarkTheme();
}
