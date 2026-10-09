import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/lms_data.dart';
import '../../models/models.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_theme.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes == 0 ? 1 : difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }

  void _showQuestionReviewSheet(BuildContext context, QuizAttemptResult attempt, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(60),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(90),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          attempt.quizTitle,
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Score: ${attempt.score}/${attempt.totalQuestions} (${attempt.percentage.toInt()}%) • Time: ${attempt.timeTaken}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: attempt.isPassed ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (attempt.isPassed ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      attempt.isPassed ? 'PASSED' : 'NEEDS PRACTICE',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: attempt.isPassed ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              Text(
                'Question by Question Review (${attempt.questions.length} Items)',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.grey),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: attempt.questions.isEmpty
                    ? Center(
                        child: Text(
                          'No individual question telemetry saved for this attempt.',
                          style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: attempt.questions.length,
                        itemBuilder: (c, qIdx) {
                          final item = attempt.questions[qIdx];
                          final isCorrect = item.selectedAnswerIndex == item.correctAnswerIndex;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCardBg : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isCorrect
                                    ? const Color(0xFF10B981).withAlpha(100)
                                    : const Color(0xFFEF4444).withAlpha(100),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: isCorrect
                                            ? const Color(0xFF10B981).withAlpha(30)
                                            : const Color(0xFFEF4444).withAlpha(30),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isCorrect ? Icons.check_rounded : Icons.close_rounded,
                                        size: 14,
                                        color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Q${qIdx + 1}. ${item.questionText}',
                                        style: GoogleFonts.inter(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                ...item.options.asMap().entries.map((optEntry) {
                                  final optIdx = optEntry.key;
                                  final optText = optEntry.value;
                                  final isStudentSelected = item.selectedAnswerIndex == optIdx;
                                  final isTheCorrectAnswer = item.correctAnswerIndex == optIdx;

                                  Color optBg = Colors.transparent;
                                  Color optBorder = isDark ? Colors.grey[800]! : Colors.grey[300]!;
                                  Color optTextColor = isDark ? Colors.white70 : Colors.black87;

                                  if (isTheCorrectAnswer) {
                                    optBg = const Color(0xFF10B981).withAlpha(isDark ? 40 : 20);
                                    optBorder = const Color(0xFF10B981);
                                    optTextColor = isDark ? const Color(0xFF6EE7B7) : const Color(0xFF065F46);
                                  } else if (isStudentSelected && !isCorrect) {
                                    optBg = const Color(0xFFEF4444).withAlpha(isDark ? 40 : 20);
                                    optBorder = const Color(0xFFEF4444);
                                    optTextColor = isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B);
                                  }

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: optBg,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: optBorder),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${String.fromCharCode(65 + optIdx)}.',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: optTextColor,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            optText,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: optTextColor,
                                              fontWeight: (isStudentSelected || isTheCorrectAnswer)
                                                  ? FontWeight.w700
                                                  : FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        if (isTheCorrectAnswer)
                                          const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF10B981))
                                        else if (isStudentSelected && !isCorrect)
                                          const Icon(Icons.cancel_rounded, size: 16, color: Color(0xFFEF4444)),
                                      ],
                                    ),
                                  );
                                }),

                                if (item.explanation.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F44B8).withAlpha(isDark ? 30 : 15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.lightbulb_outline_rounded, size: 15, color: Color(0xFF0F44B8)),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'Explanation: ${item.explanation}',
                                            style: GoogleFonts.inter(
                                              fontSize: 11.5,
                                              color: isDark ? AppColors.darkTextSecondary : const Color(0xFF1E3A8A),
                                              height: 1.35,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = context.watch<AppStateProvider>();
    final resultsGroups = LMSMockData.resultsSummary;
    final attempts = state.quizAttempts;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          'Results & Performance',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF0F44B8),
          unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          indicatorColor: const Color(0xFF0F44B8),
          indicatorWeight: 3,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: [
            Tab(text: 'Attempted Quizzes (${attempts.length})'),
            const Tab(text: 'Official Exams'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Quick Summary Metrics Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F44B8), Color(0xFF1E5CD8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F44B8).withAlpha(50),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'STUDENT SCORECARD',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${attempts.length} Quizzes Attempted • ${state.passingProbability.toInt()}% Pass Probability',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: Colors.white.withAlpha(220),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Attempted Quizzes
                  _buildAttemptedQuizzesTab(context, attempts, isDark),

                  // Tab 2: Official Exam Results
                  _buildOfficialExamsTab(resultsGroups, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttemptedQuizzesTab(BuildContext context, List<QuizAttemptResult> attempts, bool isDark) {
    if (attempts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz_outlined, size: 54, color: Colors.grey.withAlpha(120)),
            const SizedBox(height: 12),
            Text(
              'No quiz attempts recorded yet.',
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Attempt a quiz to view scores and detailed answers here.',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      itemCount: attempts.length,
      itemBuilder: (context, index) {
        final att = attempts[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 25 : 8),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (att.isPassed ? const Color(0xFF10B981) : const Color(0xFFF59E0B))
                            .withAlpha(isDark ? 50 : 25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        att.isPassed ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                        color: att.isPassed ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: (att.isPassed ? const Color(0xFF10B981) : const Color(0xFFF59E0B))
                                      .withAlpha(isDark ? 40 : 20),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  att.isPassed ? 'PASSED' : 'NEEDS PRACTICE',
                                  style: GoogleFonts.inter(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: att.isPassed ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _formatDate(att.attemptedAt),
                                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            att.quizTitle,
                            style: GoogleFonts.inter(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Score: ${att.score}/${att.totalQuestions} (${att.percentage.toInt()}%)  •  Duration: ${att.timeTaken}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F44B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${att.questions.length} Questions Evaluated',
                      style: GoogleFonts.inter(fontSize: 11.5, color: Colors.grey),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showQuestionReviewSheet(context, att, isDark),
                      icon: const Icon(Icons.analytics_outlined, size: 15),
                      label: const Text('Review Details'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F44B8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        textStyle: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOfficialExamsTab(List<CourseResultGroup> resultsGroups, bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      children: [
        ...resultsGroups.map((group) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          group.courseTitle,
                          style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Roll: ${group.rollNumber}',
                        style: GoogleFonts.inter(fontSize: 11.5, color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

                if (group.results.isEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'No published exam results found for this course.',
                          style: GoogleFonts.inter(fontSize: 12.5, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: group.results.map((res) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCardBg : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Exam Date: ${res.examDate}',
                                    style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F44B8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Overall: Band ${res.overall}',
                                      style: GoogleFonts.inter(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildScoreColumn('Listening', res.l),
                                  _buildScoreColumn('Reading', res.r),
                                  _buildScoreColumn('Writing', res.w),
                                  _buildScoreColumn('Speaking', res.s),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildScoreColumn(String label, String score) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(score, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: const Color(0xFF0F44B8))),
      ],
    );
  }
}
