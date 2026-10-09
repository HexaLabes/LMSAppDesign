import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../quiz/quiz_screen.dart';

class AssessmentTestScreen extends StatelessWidget {
  const AssessmentTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final assessments = [
      {
        'title': 'Mid-Term Comprehensive Assessment',
        'course': 'Web Development',
        'questions': 50,
        'duration': '60 mins',
        'passingMarks': '70%',
        'status': 'Completed',
        'obtained': '86%',
        'grade': 'Grade A',
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Final Certification Assessment Test',
        'course': 'Web Development',
        'questions': 100,
        'duration': '120 mins',
        'passingMarks': '75%',
        'status': 'Upcoming',
        'obtained': null,
        'grade': 'Eligible on Nov 15',
        'color': const Color(0xFF0F44B8),
      },
      {
        'title': 'IELTS Full Length Mock Assessment',
        'course': 'IELTS Preparation',
        'questions': 80,
        'duration': '150 mins',
        'passingMarks': 'Band 6.5',
        'status': 'Completed',
        'obtained': 'Band 7.5',
        'grade': 'Passed',
        'color': const Color(0xFF10B981),
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          'Assessment Test',
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
                  const Icon(Icons.assignment_turned_in_rounded, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ASSESSMENT TESTS',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Formal examinations, mid-terms, and certification assessments',
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

            ...assessments.map((test) {
              final isDone = test['status'] == 'Completed';

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
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
                            test['course'] as String,
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
                            test['status'] as String,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      test['title'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Grid stats of test
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('QUESTIONS', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                              Text('${test['questions']}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('TIME LIMIT', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                              Text('${test['duration']}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PASS CRITERIA', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                              Text('${test['passingMarks']}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isDone ? 'Result: ${test['obtained']} (${test['grade']})' : '${test['grade']}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isDone ? const Color(0xFF10B981) : const Color(0xFF0F44B8),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => QuizScreen(
                                  title: test['title'] as String,
                                  isSimulator: true,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_circle_fill_rounded, size: 16),
                          label: Text(isDone ? 'Review Test' : 'Start Exam'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F44B8),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
