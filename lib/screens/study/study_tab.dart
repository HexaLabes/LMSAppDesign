import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../quiz/flashcard_screen.dart';
import '../quiz/quiz_screen.dart';

class StudyTab extends StatelessWidget {
  const StudyTab({super.key});

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
              // Courses Header
              Text(
                'Courses',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),

              // CIT Exam Subtitle
              Text(
                state.currentExam,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 18),

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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pro Simulation access active.')),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Practice all topics Section
              Text(
                'Practice all topics',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 14),

              // Row 1: Question of the Day & Todays 10 Quiz
              Row(
                children: [
                  Expanded(
                    child: _buildTopicCard(
                      context,
                      title: 'Question of the Day',
                      badgeType: BadgeType.free,
                      icon: Icons.contrast_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuizScreen(title: 'Question of the Day')),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildTopicCard(
                      context,
                      title: 'Todays 10 Quiz',
                      badgeType: BadgeType.free,
                      icon: Icons.photo_library_rounded,
                      iconColor: const Color(0xFF10B981),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuizScreen(title: "Today's 10 Quiz")),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Row 2: Saved Questions Quiz & Past Errors Quiz
              Row(
                children: [
                  Expanded(
                    child: _buildTopicCard(
                      context,
                      title: 'Saved Questions Quiz',
                      badgeType: BadgeType.pro,
                      icon: Icons.bookmark_outline_rounded,
                      iconColor: AppColors.accentOrange,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuizScreen(title: 'Saved Questions Quiz')),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildTopicCard(
                      context,
                      title: 'Past Errors Quiz',
                      badgeType: BadgeType.pro,
                      icon: Icons.crop_free_rounded,
                      iconColor: const Color(0xFF10B981),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuizScreen(title: 'Past Errors Quiz')),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Row 3: Top 50 & Marathon
              Row(
                children: [
                  Expanded(
                    child: _buildTopicCard(
                      context,
                      title: 'Top 50',
                      subtitle: 'The Most Difficult Questions',
                      badgeType: BadgeType.pro,
                      icon: Icons.pentagon_rounded,
                      iconColor: Theme.of(context).primaryColor,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuizScreen(title: 'Top 50 Difficult Questions')),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildTopicCard(
                      context,
                      title: 'Marathon',
                      subtitle: '400 questions in a day',
                      badgeType: BadgeType.pro,
                      icon: Icons.auto_awesome_mosaic_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QuizScreen(title: 'Marathon 400 Questions')),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Timed Quiz (Full width horizontal card)
              Card(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuizScreen(title: 'Timed Quiz Pro')),
                  ),
                  borderRadius: BorderRadius.circular(18),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.timer_rounded, color: Color(0xFFF59E0B), size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Timed Quiz',
                            style: GoogleFonts.inter(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        const AppBadge(type: BadgeType.pro),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Row 4: Flashcards & Saved Flashcards
              Row(
                children: [
                  Expanded(
                    child: _buildTopicCard(
                      context,
                      title: 'Flashcards',
                      badgeType: BadgeType.free,
                      icon: Icons.pie_chart_outline_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FlashcardScreen(savedOnly: false)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildTopicCard(
                      context,
                      title: 'Saved Flashcards',
                      badgeType: BadgeType.pro,
                      icon: Icons.star_border_rounded,
                      iconColor: AppColors.accentOrange,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FlashcardScreen(savedOnly: true)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Section: Practice by Subject
              Text(
                'Practice by Subject',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 14),

              // List of Subjects with Progress bars
              ...state.subjects.map((subject) {
                final progress = (subject['progress'] as double?) ?? 0.0;
                final correct = subject['correct'] ?? 0;
                final total = subject['total'] ?? 0;
                final title = subject['title'] as String;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(title: title),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                  size: 22,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 6,
                                backgroundColor: isDark ? AppColors.darkCardElevated : const Color(0xFFE5E7EB),
                                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${(progress * 100).toInt()}%',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                                Text(
                                  'Questions $correct/$total correct',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicCard(
    BuildContext context, {
    required String title,
    String? subtitle,
    required BadgeType badgeType,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  AppBadge(type: badgeType),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  height: 1.25,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
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
