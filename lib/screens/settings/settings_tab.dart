import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_theme.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = context.watch<AppStateProvider>();
    final formattedDate = DateFormat('MMM dd, yyyy').format(state.examDate);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Settings',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),

              // Section: Practice Settings
              Text(
                'Practice Settings',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    _buildSettingsRow(
                      context,
                      title: 'Learning Mode',
                      onTap: () {
                        _showLearningModeDialog(context);
                      },
                    ),
                    _buildDivider(isDark),
                    _buildSettingsRow(
                      context,
                      title: 'Exam Date',
                      trailingText: formattedDate,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: state.examDate,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          state.setExamDate(picked);
                        }
                      },
                    ),
                    _buildDivider(isDark),
                    _buildSettingsRow(
                      context,
                      title: 'Reset Progress',
                      isDestructive: true,
                      onTap: () {
                        _showResetConfirmation(context, state);
                      },
                    ),
                  ],
                ),
              ),
              // Section: Institute Theme & Brand Color
              Text(
                'Institute Theme & Brand Color',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select a color scheme that matches your institute branding',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ...AppColors.presets.asMap().entries.map((entry) {
                        final index = entry.key;
                        final preset = entry.value;
                        final isSelected = state.selectedThemeIndex == index;

                        return Column(
                          children: [
                            if (index > 0) _buildDivider(isDark),
                            InkWell(
                              onTap: () => state.setThemeIndex(index),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                                child: Row(
                                  children: [
                                    // Color Circle Preview
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [preset.primary, preset.primaryLight],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: preset.primary.withAlpha(isDark ? 80 : 50),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: isSelected
                                          ? const Center(
                                              child: Icon(
                                                Icons.check_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            preset.name,
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                              color: isSelected
                                                  ? preset.primary
                                                  : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                            ),
                                          ),
                                          Text(
                                            preset.subtitle,
                                            style: GoogleFonts.inter(
                                              fontSize: 11.5,
                                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: preset.primary.withAlpha(25),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Active',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: preset.primary,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Section: System Settings
              Text(
                'System Settings',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    _buildSwitchRow(
                      title: 'Dark Mode',
                      value: state.isDarkMode,
                      onChanged: (val) => state.toggleDarkMode(val),
                    ),
                    _buildDivider(isDark),
                    _buildSwitchRow(
                      title: 'Sounds',
                      value: state.soundsEnabled,
                      onChanged: (val) => state.toggleSounds(val),
                    ),
                    _buildDivider(isDark),
                    _buildSwitchRow(
                      title: 'Vibration',
                      value: state.vibrationEnabled,
                      onChanged: (val) => state.toggleVibration(val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section: Help & Support
              Text(
                'Help & Support',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    _buildSettingsRow(
                      context,
                      title: 'Subscription Management',
                      onTap: () {
                        _showSubscriptionInfo(context);
                      },
                    ),
                    _buildDivider(isDark),
                    _buildSettingsRow(
                      context,
                      title: 'Rate Us',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Thank you for your rating! ⭐⭐⭐⭐⭐')),
                        );
                      },
                    ),
                    _buildDivider(isDark),
                    _buildSettingsRow(
                      context,
                      title: 'Contact Us',
                      onTap: () {
                        _showContactDialog(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Footer Legal Links
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showLegalDialog(context, 'Privacy Policy', 'Your privacy is respected. All your prep records and exam answers are secured on Hexa Labes LMS.');
                      },
                      child: Text(
                        'Privacy Policy',
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '|',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showLegalDialog(context, 'Terms of Use', 'By using CIT Prep LMS, you agree to access exam materials for personal educational use.');
                      },
                      child: Text(
                        'Terms of Use',
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsRow(
    BuildContext context, {
    required String title,
    String? trailingText,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: isDestructive
                    ? AppColors.error
                    : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
            ),
            Row(
              children: [
                if (trailingText != null) ...[
                  Text(
                    trailingText,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 18,
      endIndent: 18,
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
    );
  }

  void _showResetConfirmation(BuildContext context, AppStateProvider state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Reset Progress', style: GoogleFonts.inter(fontWeight: FontWeight.w800)),
        content: Text(
          'This will reset your question statistics, passing probability, streaks, and quiz history. This action cannot be undone.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              state.resetProgress();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All progress has been reset.')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showLearningModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Learning Mode', style: GoogleFonts.inter(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.flash_on_rounded, color: Theme.of(context).primaryColor),
              title: const Text('Adaptive Practice (Active)'),
              subtitle: const Text('Prioritizes weak topics automatically'),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.format_list_numbered_rounded),
              title: const Text('Sequential Mode'),
              subtitle: const Text('Covers topics in syllabus sequence'),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubscriptionInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('LMS Pro Membership', style: GoogleFonts.inter(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Status: Active Pro Member ★'),
            const SizedBox(height: 8),
            const Text('Includes unlimited Exam Simulations, 400 Question Marathons, Top 50 hardest questions, and complete flashcards.'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Contact Support', style: GoogleFonts.inter(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Support Email: support@hexalabes.com'),
            SizedBox(height: 6),
            Text('LMS Helpdesk: lms.hexalabes.com/help'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showLegalDialog(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w800)),
        content: Text(body, style: GoogleFonts.inter()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }
}
