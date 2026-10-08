import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum BadgeType { free, pro, buyAttempts }

class AppBadge extends StatelessWidget {
  final BadgeType type;
  final String? customText;

  const AppBadge({
    super.key,
    required this.type,
    this.customText,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    String text;
    bool showStar = false;

    switch (type) {
      case BadgeType.free:
        bg = AppColors.badgeFree;
        text = customText ?? 'Free';
        break;
      case BadgeType.pro:
        bg = AppColors.badgePro;
        text = customText ?? 'Pro';
        showStar = true;
        break;
      case BadgeType.buyAttempts:
        bg = AppColors.badgeAttempt;
        text = customText ?? 'Buy Attempts';
        showStar = true;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showStar) ...[
            const SizedBox(width: 3),
            const Icon(
              Icons.star,
              size: 11,
              color: AppColors.starYellow,
            ),
          ],
        ],
      ),
    );
  }
}

class ExamSimulatorCard extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback? onBuyAttempts;

  const ExamSimulatorCard({
    super.key,
    required this.onTap,
    this.onBuyAttempts,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark ? AppColors.darkCardBg : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.auto_awesome,
                        color: Theme.of(context).primaryColor,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Exam Simulator',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onBuyAttempts,
                    child: const AppBadge(type: BadgeType.buyAttempts),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Our Exam Simulation replicates the time limit, question count, and content of the official exam',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  height: 1.35,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureActionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final BadgeType? badgeType;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const FeatureActionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.badgeType,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark ? AppColors.darkCardBg : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: iconColor.withAlpha(28),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  if (badgeType != null) AppBadge(type: badgeType!),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  height: 1.2,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class StatMetricBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  const StatMetricBox({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark ? AppColors.darkCardBg : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: iconColor ?? AppColors.accentOrange),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
