import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';
import '../lms_modules/assignments_screen.dart';
import '../lms_modules/assessment_test_screen.dart';
import '../lms_modules/attachments_screen.dart';
import '../lms_modules/attendance_screen.dart';
import '../lms_modules/attempt_quizzes_screen.dart';
import '../lms_modules/course_progress_screen.dart';
import '../lms_modules/course_timings_screen.dart';
import '../lms_modules/fee_details_screen.dart';
import '../lms_modules/my_courses_screen.dart';
import '../lms_modules/results_screen.dart';
import '../lms_modules/student_dashboard_profile_screen.dart';
import '../lms_modules/student_feedback_screen.dart';
import '../lms_modules/trainer_feedback_screen.dart';
import '../quiz/flashcard_screen.dart';

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
            // Student Profile Header
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StudentDashboardProfileScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(18),
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
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0F44B8), Color(0xFF1E5CD8)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F44B8).withAlpha(isDark ? 80 : 40),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'KHALID',
                                style: GoogleFonts.inter(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'khalid@hexalabes.com',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F44B8).withAlpha(25),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Enrolled Student',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F44B8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Navigation Options List (All 15 LMS Sidebar Items)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
                    child: Text(
                      'QUICK LINKS',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF94A3B8),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),

                  // 1. Student Dashboard (Navigates to Main LMS Dashboard screen)
                  _buildSidebarItem(
                    context,
                    icon: Icons.dashboard_rounded,
                    title: 'Student Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      onTabSelected(0);
                    },
                  ),

                  // 2. Student Profile (Opens Student Profile screen)
                  _buildSidebarItem(
                    context,
                    icon: Icons.person_outline_rounded,
                    title: 'Student Profile',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StudentDashboardProfileScreen()),
                      );
                    },
                  ),

                  // 2. Student's Attachments
                  _buildSidebarItem(
                    context,
                    icon: Icons.attach_file_rounded,
                    title: "Student's Attachments",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AttachmentsScreen()),
                      );
                    },
                  ),

                  // 3. My Courses
                  _buildSidebarItem(
                    context,
                    icon: Icons.local_library_rounded,
                    title: 'My Courses',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyCoursesScreen()),
                      );
                    },
                  ),

                  // 4. Assignments
                  _buildSidebarItem(
                    context,
                    icon: Icons.assignment_rounded,
                    title: 'Assignments',
                    badge: '4 Tasks',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AssignmentsScreen()),
                      );
                    },
                  ),

                  // 5. Attempt Quizzes
                  _buildSidebarItem(
                    context,
                    icon: Icons.dvr_rounded,
                    title: 'Attempt Quizzes',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AttemptQuizzesScreen()),
                      );
                    },
                  ),

                  // 6. Assessment Test
                  _buildSidebarItem(
                    context,
                    icon: Icons.assignment_turned_in_rounded,
                    title: 'Assessment Test',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AssessmentTestScreen()),
                      );
                    },
                  ),

                  // 7. Flashcards
                  _buildSidebarItem(
                    context,
                    icon: Icons.style_rounded,
                    title: 'Flashcards',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FlashcardScreen()),
                      );
                    },
                  ),

                  // 8. Course Progress
                  _buildSidebarItem(
                    context,
                    icon: Icons.trending_up_rounded,
                    title: 'Course Progress',
                    badge: '76.9%',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CourseProgressScreen()),
                      );
                    },
                  ),

                  // 9. Fee Details
                  _buildSidebarItem(
                    context,
                    icon: Icons.account_balance_wallet_rounded,
                    title: 'Fee Details',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FeeDetailsScreen()),
                      );
                    },
                  ),

                  // 10. Course Timings
                  _buildSidebarItem(
                    context,
                    icon: Icons.schedule_rounded,
                    title: 'Course Timings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CourseTimingsScreen()),
                      );
                    },
                  ),

                  // 11. Attendence
                  _buildSidebarItem(
                    context,
                    icon: Icons.check_circle_rounded,
                    title: 'Attendence',
                    badge: '87.5%',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AttendanceScreen()),
                      );
                    },
                  ),

                  // 12. Results
                  _buildSidebarItem(
                    context,
                    icon: Icons.assessment_rounded,
                    title: 'Results',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ResultsScreen()),
                      );
                    },
                  ),

                  // 13. Student Feedback
                  _buildSidebarItem(
                    context,
                    icon: Icons.rate_review_rounded,
                    title: 'Student Feedback',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StudentFeedbackScreen()),
                      );
                    },
                  ),

                  // 14. Trainer Feedback
                  _buildSidebarItem(
                    context,
                    icon: Icons.assignment_turned_in_outlined,
                    title: 'Trainer Feedback',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TrainerFeedbackScreen()),
                      );
                    },
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Divider(),
                  ),

                  // Dark Mode Switch
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Dark Mode',
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
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
                ],
              ),
            ),

            // Logout Footer
            Container(
              padding: const EdgeInsets.all(14),
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
                          title: Text('Sign Out', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                          content: const Text('Are you sure you want to sign out from your LMS account?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
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
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Sign Out',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Hexa Labes LMS • v1.0.0',
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
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

  Widget _buildSidebarItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? badge,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Icon(
          icon,
          size: 20,
          color: const Color(0xFF0F44B8),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF334155),
          ),
        ),
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F44B8).withAlpha(isDark ? 50 : 20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F44B8),
                  ),
                ),
              )
            : const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
      ),
    );
  }
}
