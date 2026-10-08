import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../auth/login_screen.dart';
import '../quiz/custom_quiz_dialog.dart';

class SideMenuDrawer extends StatelessWidget {
  final Function(int) onTabSelected;

  const SideMenuDrawer({
    super.key,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = context.watch<AppStateProvider>();

    return Drawer(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      child: SafeArea(
        child: Column(
          children: [
            // User Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Theme.of(context).primaryColor, state.primaryColorLight],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withAlpha(isDark ? 80 : 40),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    'Shanaz Ahmed',
                                    style: GoogleFonts.inter(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'student@hexalabes.com',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            const AppBadge(type: BadgeType.pro, customText: 'Pro Member'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Quick Exam Selector inside Drawer
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardElevated : const Color(0xFFF3EFEA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.school_rounded,
                              size: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              state.currentExam,
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_drop_down, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Menu List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.home_rounded,
                    title: 'Home Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      onTabSelected(0);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.local_library_rounded,
                    title: 'Courses & Modules',
                    badge: '7 Subjects',
                    onTap: () {
                      Navigator.pop(context);
                      onTabSelected(1);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.bar_chart_rounded,
                    title: 'Stats & Analytics',
                    onTap: () {
                      Navigator.pop(context);
                      onTabSelected(2);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.tune_rounded,
                    title: 'Create Custom Quiz',
                    isPro: true,
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (_) => const CustomQuizDialog(),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.bookmark_outline_rounded,
                    title: 'Saved Flashcards',
                    onTap: () {
                      Navigator.pop(context);
                      onTabSelected(1);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.workspace_premium_rounded,
                    title: 'Subscription & Pro',
                    iconColor: AppColors.starYellow,
                    onTap: () {
                      Navigator.pop(context);
                      onTabSelected(3);
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Divider(),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      onTabSelected(3);
                    },
                  ),

                  // Dark Mode Switch in Drawer
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardBg : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                              color: isDark ? AppColors.accentOrange : Colors.amber.shade700,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Dark Mode',
                              style: GoogleFonts.inter(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: state.isDarkMode,
                          onChanged: (val) {
                            state.toggleDarkMode(val);
                          },
                        ),
                      ],
                    ),
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.pop(context);
                      onTabSelected(3);
                    },
                  ),
                ],
              ),
            ),

            // Logout & Brand Bottom Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
                          title: Text(
                            'Sign Out',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                          ),
                          content: Text(
                            'Are you sure you want to sign out from CIT Prep LMS?',
                            style: GoogleFonts.inter(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentOrange,
                              ),
                              onPressed: () {
                                Navigator.pop(ctx);
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  (route) => false,
                                );
                              },
                              child: const Text('Sign Out'),
                            ),
                          ],
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.logout_rounded, color: AppColors.error, size: 22),
                          const SizedBox(width: 12),
                          Text(
                            'Sign Out',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hexa Labes LMS • v1.0.0',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? badge,
    bool isPro = false,
    Color? iconColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          icon,
          size: 22,
          color: iconColor ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        trailing: isPro
            ? const AppBadge(type: BadgeType.pro)
            : (badge != null
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardElevated : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  )
                : const Icon(Icons.chevron_right, size: 18)),
      ),
    );
  }
}
