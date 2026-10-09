import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../quiz/quiz_screen.dart';

class AttemptQuizzesScreen extends StatelessWidget {
  const AttemptQuizzesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final quizzes = [
      {
        'title': 'Module 1: HTML5 Semantics & SEO Quiz',
        'course': 'Web Development',
        'questions': 15,
        'duration': '15 mins',
        'status': 'Completed',
        'score': '14/15 (93%)',
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Module 2: Modern CSS Layouts & Flexbox',
        'course': 'Web Development',
        'questions': 20,
        'duration': '20 mins',
        'status': 'Completed',
        'score': '18/20 (90%)',
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Module 3: JavaScript ES6+ & Async/Await',
        'course': 'Web Development',
        'questions': 25,
        'duration': '25 mins',
        'status': 'Available',
        'score': null,
        'color': const Color(0xFF0F44B8),
      },
      {
        'title': 'IELTS Listening Practice Set 1',
        'course': 'IELTS Academic Preparation',
        'questions': 40,
        'duration': '30 mins',
        'status': 'Available',
        'score': null,
        'color': const Color(0xFF0F44B8),
      },
      {
        'title': 'IELTS Academic Reading Mock Test',
        'course': 'IELTS Academic Preparation',
        'questions': 40,
        'duration': '60 mins',
        'status': 'Completed',
        'score': '32/40 (Band 7.5)',
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Data Structures: Stacks & Queues Quiz',
        'course': 'Advanced Problem Solving',
        'questions': 15,
        'duration': '20 mins',
        'status': 'Available',
        'score': null,
        'color': const Color(0xFF0F44B8),
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          'Attempt Quizzes',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            // Blue Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F44B8), Color(0xFF1E5CD8)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.dvr_rounded, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ATTEMPT QUIZZES',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Test knowledge with modular course quizzes',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: Colors.white.withAlpha(210),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            ...quizzes.map((q) {
              final isDone = q['status'] == 'Completed';

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F44B8).withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            q['course'] as String,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF0F44B8),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDone ? const Color(0xFF10B981) : const Color(0xFF0F44B8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            q['status'] as String,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      q['title'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.help_outline_rounded, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                        const SizedBox(width: 4),
                        Text(
                          '${q['questions']} Questions',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Icon(Icons.timer_outlined, size: 16, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                        const SizedBox(width: 4),
                        Text(
                          q['duration'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isDone && q['score'] != null)
                          Text(
                            'Score: ${q['score']}',
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF10B981),
                            ),
                          )
                        else
                          Text(
                            'Not attempted yet',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            ),
                          ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => QuizScreen(title: q['title'] as String),
                              ),
                            );
                          },
                          icon: Icon(isDone ? Icons.replay_rounded : Icons.play_arrow_rounded, size: 16),
                          label: Text(isDone ? 'Retake Quiz' : 'Start Quiz'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDone ? const Color(0xFF10B981) : const Color(0xFF0F44B8),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
