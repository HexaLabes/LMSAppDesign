import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/mock_courses_data.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../courses/course_detail_screen.dart';
import '../courses/course_module_screen.dart';
import '../lms_modules/my_courses_screen.dart';
import '../quiz/custom_quiz_dialog.dart';
import '../quiz/flashcard_screen.dart';
import '../quiz/quiz_screen.dart';

class HomeTab extends StatefulWidget {
  final VoidCallback onOpenDrawer;

  const HomeTab({
    super.key,
    required this.onOpenDrawer,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _isNoticeDismissed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = context.watch<AppStateProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar with Drawer Button, Brand & Notifications
              _buildTopBar(context, isDark),
              const SizedBox(height: 16),

              // 2. Student Welcome & Course Header
              _buildStudentHeader(context, state, isDark),
              const SizedBox(height: 16),

              // 3. Quick Stats Metric Row (Progress, Attendance, Quizzes, Fee)
              _buildQuickStatsRow(context, state, isDark),
              const SizedBox(height: 16),

              // 4. LMS Notice Board Banner (Dismissible)
              if (!_isNoticeDismissed) ...[
                _buildNoticeBoardBanner(context, isDark),
                const SizedBox(height: 20),
              ],

              // 5. LMS Core Learning Modules (Matches D:\Hexa Labes\Ecommerce\LMS)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LMS Dashboard',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F6CFF).withAlpha(isDark ? 50 : 25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Student Portal',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4F6CFF),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Modules Grid: 2 Columns
              _buildLmsModulesGrid(context, isDark),
              const SizedBox(height: 24),

              // 6. Practice & Quiz Modes Section
              Text(
                'Practice & Test Simulator',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 14),

              // Exam Simulator Card
              ExamSimulatorCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const QuizScreen(
                        title: 'Exam Simulator (Full)',
                        isSimulator: true,
                      ),
                    ),
                  );
                },
                onBuyAttempts: () {
                  _showBuyAttemptsModal(context);
                },
              ),
              const SizedBox(height: 14),

              // Today's 10 Quiz
              _buildPracticeCard(
                context,
                isDark: isDark,
                icon: Icons.photo_library_rounded,
                iconColor: const Color(0xFF10B981),
                title: "Today's 10 Quiz",
                badgeType: BadgeType.free,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const QuizScreen(title: "Today's 10 Quiz"),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // Past Errors Quiz
              _buildPracticeCard(
                context,
                isDark: isDark,
                icon: Icons.refresh_rounded,
                iconColor: AppColors.accentOrange,
                title: "Past Errors Quiz",
                badgeType: BadgeType.pro,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const QuizScreen(title: "Past Errors Quiz"),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // Saved Questions Quiz
              _buildPracticeCard(
                context,
                isDark: isDark,
                icon: Icons.bookmark_outline_rounded,
                iconColor: const Color(0xFFF59E0B),
                title: "Saved Questions Quiz",
                badgeType: BadgeType.pro,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const QuizScreen(title: "Saved Questions Quiz"),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // Flashcards & Create Custom Quiz
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: isDark ? AppColors.darkCardBg : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const FlashcardScreen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(18),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Align(
                                alignment: Alignment.topRight,
                                child: AppBadge(type: BadgeType.free),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.style_rounded, color: Color(0xFFF59E0B), size: 24),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Flashcards',
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Card(
                      color: isDark ? AppColors.darkCardBg : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => const CustomQuizDialog(),
                          );
                        },
                        borderRadius: BorderRadius.circular(18),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Align(
                                alignment: Alignment.topRight,
                                child: AppBadge(type: BadgeType.pro),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.add_circle_outline_rounded, color: Theme.of(context).primaryColor, size: 24),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Create Custom Quiz',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Top Bar
  Widget _buildTopBar(BuildContext context, bool isDark) {
    final state = context.watch<AppStateProvider>();
    final primary = Theme.of(context).primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: widget.onOpenDrawer,
              icon: const Icon(Icons.menu_rounded, size: 28),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CIT Prep LMS',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: primary,
                    letterSpacing: 0.2,
                  ),
                ),
                Text(
                  'Student Learning Portal',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            // Quick Theme Palette Switcher
            InkWell(
              onTap: () => _showThemePickerSheet(context, state, isDark),
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 30 : 10),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.palette_outlined, size: 20, color: primary),
              ),
            ),
            const SizedBox(width: 8),
            // Notifications Bell
            InkWell(
              onTap: () => _showNotificationsSheet(context, isDark),
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 30 : 10),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined, size: 22),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.accentOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 2. Student Header Card
  Widget _buildStudentHeader(BuildContext context, AppStateProvider state, bool isDark) {
    return Card(
      color: isDark ? AppColors.darkCardBg : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Profile Avatar
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F6CFF), Color(0xFF1E3A8A)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F6CFF).withAlpha(isDark ? 80 : 40),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 28,
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
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 16),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Roll No: ST-2026-042  •  Main Campus',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Enrolled Course Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enrolled Course:',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
                InkWell(
                  onTap: () => _showExamPicker(context, state),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardElevated : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.currentExam,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 3. Quick Stats Metric Row
  Widget _buildQuickStatsRow(BuildContext context, AppStateProvider state, bool isDark) {
    return Row(
      children: [
        _buildMetricCard(
          context,
          isDark: isDark,
          icon: Icons.trending_up_rounded,
          iconColor: const Color(0xFF4F6CFF),
          title: 'Progress',
          value: '68%',
          subtitle: 'Active',
          onTap: () => _showProgressDetails(context, isDark),
        ),
        const SizedBox(width: 10),
        _buildMetricCard(
          context,
          isDark: isDark,
          icon: Icons.check_circle_outline_rounded,
          iconColor: const Color(0xFF10B981),
          title: 'Attendance',
          value: '92%',
          subtitle: 'Present',
          onTap: () => _showAttendanceDetails(context, isDark),
        ),
        const SizedBox(width: 10),
        _buildMetricCard(
          context,
          isDark: isDark,
          icon: Icons.assignment_turned_in_outlined,
          iconColor: AppColors.accentOrange,
          title: 'Quizzes',
          value: '${state.quizzesPassed}/15',
          subtitle: 'Passed',
          onTap: () => _showQuizzesDetails(context, isDark),
        ),
        const SizedBox(width: 10),
        _buildMetricCard(
          context,
          isDark: isDark,
          icon: Icons.account_balance_wallet_outlined,
          iconColor: const Color(0xFF8B5CF6),
          title: 'Fee Status',
          value: 'Paid',
          subtitle: 'Clear',
          onTap: () => _showFeeDetails(context, isDark),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Card(
        color: isDark ? AppColors.darkCardBg : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 4. LMS Notice Board Banner (Matches LMS Index.cshtml #noticeBoardBanner)
  Widget _buildNoticeBoardBanner(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardElevated : const Color(0xFFF4F7FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF4F6CFF).withAlpha(isDark ? 80 : 40),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F6CFF).withAlpha(isDark ? 60 : 30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.campaign_rounded,
                    color: Color(0xFF4F6CFF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LMS Notice Board',
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'Upcoming Assessment Test & Quiz schedule',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isNoticeDismissed = true;
                    });
                  },
                  icon: const Icon(Icons.close_rounded, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_note_rounded, size: 16, color: Color(0xFF4F6CFF)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Module 4 Assessment Test will be unlocked on Oct 15.',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
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

  // 5. LMS Core Learning Modules Grid (Exact modules from D:\Hexa Labes\Ecommerce\LMS)
  Widget _buildLmsModulesGrid(BuildContext context, bool isDark) {
    final modules = [
      {
        'title': 'My Courses',
        'subtitle': 'Lectures & SCORM',
        'icon': Icons.local_library_rounded,
        'color': const Color(0xFF4F6CFF),
        'onTap': () => _showMyCoursesModal(context, isDark),
      },
      {
        'title': 'Assessment Test',
        'subtitle': 'Online Exams',
        'icon': Icons.assignment_turned_in_rounded,
        'color': const Color(0xFF10B981),
        'onTap': () => _showAssessmentTestsModal(context, isDark),
      },
      {
        'title': 'Attempt Quizzes',
        'subtitle': 'Practice Tests',
        'icon': Icons.quiz_rounded,
        'color': AppColors.accentOrange,
        'onTap': () => _showQuizzesDetails(context, isDark),
      },
      {
        'title': 'Flashcards',
        'subtitle': 'Study Decks',
        'icon': Icons.style_rounded,
        'color': const Color(0xFFF59E0B),
        'onTap': () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const FlashcardScreen()),
          );
        },
      },
      {
        'title': 'Course Progress',
        'subtitle': 'Analytics & Stats',
        'icon': Icons.trending_up_rounded,
        'color': const Color(0xFF8B5CF6),
        'onTap': () => _showProgressDetails(context, isDark),
      },
      {
        'title': 'Assignments',
        'subtitle': 'Tasks & Feedback',
        'icon': Icons.assignment_rounded,
        'color': const Color(0xFF06B6D4),
        'onTap': () => _showAssignmentsModal(context, isDark),
      },
      {
        'title': 'Attendance',
        'subtitle': 'Attendance Record',
        'icon': Icons.check_circle_rounded,
        'color': const Color(0xFF10B981),
        'onTap': () => _showAttendanceDetails(context, isDark),
      },
      {
        'title': 'Fee Details',
        'subtitle': 'Vouchers & Paid Dues',
        'icon': Icons.account_balance_wallet_rounded,
        'color': const Color(0xFFEC4899),
        'onTap': () => _showFeeDetails(context, isDark),
      },
      {
        'title': 'Course Timings',
        'subtitle': 'Class Schedule',
        'icon': Icons.schedule_rounded,
        'color': const Color(0xFF6366F1),
        'onTap': () => _showCourseTimingsModal(context, isDark),
      },
      {
        'title': 'Attachments',
        'subtitle': 'PDFs & Handouts',
        'icon': Icons.attach_file_rounded,
        'color': const Color(0xFF3B82F6),
        'onTap': () => _showAttachmentsModal(context, isDark),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final item = modules[index];
        final Color color = item['color'] as Color;

        return Card(
          color: isDark ? AppColors.darkCardBg : Colors.white,
          elevation: isDark ? 0 : 1,
          shadowColor: Colors.black.withAlpha(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: InkWell(
            onTap: item['onTap'] as VoidCallback,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: color.withAlpha(isDark ? 45 : 25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: color,
                          size: 22,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: isDark
                            ? AppColors.darkTextSecondary.withAlpha(100)
                            : AppColors.lightTextSecondary.withAlpha(100),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item['title'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item['subtitle'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper Practice Card
  Widget _buildPracticeCard(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required BadgeType badgeType,
    required VoidCallback onTap,
  }) {
    return Card(
      color: isDark ? AppColors.darkCardBg : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              AppBadge(type: badgeType),
            ],
          ),
        ),
      ),
    );
  }

  // --- Modal Sheets & Dialogs for LMS Modules ---

  void _showMyCoursesModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final courses = MockCoursesData.courses;

        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: controller,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Enrolled Courses',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Access your syllabus, video lectures and SCORM players',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const MyCoursesScreen()),
                          );
                        },
                        child: Text(
                          'View All',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: const Color(0xFF0F44B8)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  ...courses.map((course) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4F6CFF).withAlpha(30),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.play_circle_filled_rounded, color: Color(0xFF4F6CFF), size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.title,
                                      style: GoogleFonts.inter(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                    Text(
                                      'Instructor: ${course.instructorName} • ${course.modulesCount} Modules',
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5,
                                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: course.progress,
                              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F6CFF)),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${(course.progress * 100).toInt()}% Completed',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF4F6CFF),
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => CourseDetailScreen(course: course),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Details',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => CourseModuleScreen(course: course),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0F44B8),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      textStyle: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700),
                                    ),
                                    child: const Text('Resume Modules'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAssessmentTestsModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assessment Tests',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Formative and Summative official assessments',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 16),
              _buildAssessmentTile(
                context,
                isDark,
                title: 'Formative Assessment #1: TNA & Course Design',
                totalMarks: 50,
                status: 'Completed (44/50)',
                statusColor: const Color(0xFF10B981),
              ),
              const SizedBox(height: 10),
              _buildAssessmentTile(
                context,
                isDark,
                title: 'Summative Assessment #2: Final Evaluation',
                totalMarks: 100,
                status: 'Available to Attempt',
                statusColor: const Color(0xFF4F6CFF),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const QuizScreen(title: 'Summative Assessment Test'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAssessmentTile(
    BuildContext context,
    bool isDark, {
    required String title,
    required int totalMarks,
    required String status,
    required Color statusColor,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.assignment_turned_in_rounded, color: statusColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  'Total Marks: $totalMarks  •  $status',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: const Size(60, 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Start', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  void _showAttendanceDetails(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Attendance Summary',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatBadge(isDark, 'Total Classes', '25', Colors.blue),
                  _buildStatBadge(isDark, 'Present Days', '23', Colors.green),
                  _buildStatBadge(isDark, 'Absent Days', '2', Colors.red),
                  _buildStatBadge(isDark, 'Percentage', '92%', Colors.purple),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Attendance is well above the mandatory 80% threshold required for certification eligibility.',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFeeDetails(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fee Details & Vouchers',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildFeeRow('Total Course Fee', 'PKR 45,000', isDark),
                    const Divider(height: 16),
                    _buildFeeRow('Paid Amount', 'PKR 45,000', isDark, isPositive: true),
                    const Divider(height: 16),
                    _buildFeeRow('Remaining Balance', 'PKR 0', isDark),
                    const Divider(height: 16),
                    _buildFeeRow('Payment Status', 'CLEARED / PAID', isDark, isBadge: true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeeRow(String label, String value, bool isDark, {bool isPositive = false, bool isBadge = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        if (isBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF10B981)),
            ),
          )
        else
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: isPositive ? const Color(0xFF10B981) : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
            ),
          ),
      ],
    );
  }

  Widget _buildStatBadge(bool isDark, String label, String val, Color color) {
    return Column(
      children: [
        Text(
          val,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  void _showProgressDetails(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Course Progress Breakdown',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildProgressBar('Module 1: Needs Assessment', 0.90, isDark),
              const SizedBox(height: 10),
              _buildProgressBar('Module 2: Course Design', 0.85, isDark),
              const SizedBox(height: 10),
              _buildProgressBar('Module 3: Facilitation Skills', 0.65, isDark),
              const SizedBox(height: 10),
              _buildProgressBar('Module 4: Evaluation & Assessment', 0.40, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(String title, double value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF4F6CFF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F6CFF)),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  void _showQuizzesDetails(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Attempt Quizzes',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const QuizScreen(title: "Today's 10 Quiz"),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Start Daily Quiz'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (_) => const CustomQuizDialog(),
                  );
                },
                icon: const Icon(Icons.tune_rounded),
                label: const Text('Custom Quiz Generator'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCourseTimingsModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Course Timings & Batch Info',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _buildTimingRow(Icons.calendar_today_rounded, 'Class Schedule', 'Mon, Wed, Fri (Weekly)', isDark),
                    const Divider(height: 16),
                    _buildTimingRow(Icons.access_time_rounded, 'Class Timings', '06:00 PM - 08:00 PM PKT', isDark),
                    const Divider(height: 16),
                    _buildTimingRow(Icons.person_outline_rounded, 'Lead Trainer', 'Dr. John Doe', isDark),
                    const Divider(height: 16),
                    _buildTimingRow(Icons.location_on_outlined, 'Campus / Medium', 'Main Campus / Online LMS', isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimingRow(IconData icon, String label, String value, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF4F6CFF)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
              Text(
                value,
                style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAssignmentsModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assignments & Tasks',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 14),
              _buildAssessmentTile(
                context,
                isDark,
                title: 'Assignment 1: Instructional Plan Formulation',
                totalMarks: 20,
                status: 'Submitted • Graded (19/20)',
                statusColor: const Color(0xFF10B981),
              ),
              const SizedBox(height: 10),
              _buildAssessmentTile(
                context,
                isDark,
                title: 'Assignment 2: Lesson Delivery Reflection',
                totalMarks: 20,
                status: 'Due in 3 days',
                statusColor: const Color(0xFFF59E0B),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAttachmentsModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Student Attachments & Resources',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 14),
              _buildAttachmentItem('CIT_Course_Syllabus_2026.pdf', '2.4 MB', isDark),
              const SizedBox(height: 8),
              _buildAttachmentItem('Module_3_Facilitation_Handout.pdf', '5.1 MB', isDark),
              const SizedBox(height: 8),
              _buildAttachmentItem('Kirkpatrick_Evaluation_Reference.pdf', '1.8 MB', isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentItem(String name, String size, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(size, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.download_rounded, color: Color(0xFF4F6CFF), size: 20),
        ],
      ),
    );
  }

  void _showNotificationsSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 14),
              _buildNotificationItem('New lecture uploaded in Module 3', '10 mins ago', Icons.video_library_rounded, Colors.blue, isDark),
              const SizedBox(height: 10),
              _buildNotificationItem('Assessment #1 graded: 44/50', '2 hours ago', Icons.grade_rounded, Colors.green, isDark),
              const SizedBox(height: 10),
              _buildNotificationItem('Live doubt clearing session tomorrow 7 PM', '1 day ago', Icons.live_tv_rounded, Colors.orange, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(String title, String time, IconData icon, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withAlpha(30), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
              Text(time, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  void _showExamPicker(BuildContext context, AppStateProvider state) {
    final exams = [
      'CIT Exam',
      'IOSH Managing Safely',
      'OSHA 30-Hour General Industry',
      'Nebosh IGC',
      'Advance Vision Technical Training',
    ];

    final primary = Theme.of(context).primaryColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Enrolled Course',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              ...exams.map((exam) {
                final isSelected = state.currentExam == exam;
                return ListTile(
                  title: Text(
                    exam,
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? primary : null,
                    ),
                  ),
                  trailing: isSelected ? Icon(Icons.check, color: primary) : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () {
                    state.setCurrentExam(exam);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showThemePickerSheet(BuildContext context, AppStateProvider state, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(80),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(Icons.palette_rounded, color: Theme.of(context).primaryColor, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Change Institute Theme',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose a color palette matching your institute branding:',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...AppColors.presets.asMap().entries.map((entry) {
                    final index = entry.key;
                    final preset = entry.value;
                    final isSelected = state.selectedThemeIndex == index;

                    return InkWell(
                      onTap: () {
                        state.setThemeIndex(index);
                        setSheetState(() {});
                        Navigator.pop(ctx);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? preset.primary.withAlpha(isDark ? 50 : 25)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? preset.primary
                                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [preset.primary, preset.primaryLight],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: preset.primary.withAlpha(70),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    preset.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                  Text(
                                    preset.subtitle,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle_rounded, color: preset.primary, size: 22)
                            else
                              Icon(Icons.radio_button_unchecked_rounded, color: Colors.grey.withAlpha(120), size: 20),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showBuyAttemptsModal(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exam Simulator Attempts'),
        content: const Text('You have 3 exam attempts remaining. Contact administration or purchase extra credits to take more simulation attempts.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white),
            child: const Text('Get More Attempts'),
          ),
        ],
      ),
    );
  }
}
