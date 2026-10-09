import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/mock_data.dart';
import '../../models/models.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_theme.dart';
import '../lms_modules/results_screen.dart';

class QuizScreen extends StatefulWidget {
  final String title;
  final bool isSimulator;

  const QuizScreen({
    super.key,
    required this.title,
    this.isSimulator = false,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<QuestionModel> _questions;
  int _currentIndex = 0;
  final Map<int, int> _selectedAnswers = {};
  final Set<int> _savedQuestions = {};
  bool _isSubmitted = false;

  Timer? _timer;
  int _secondsRemaining = 900; // 15 mins

  @override
  void initState() {
    super.initState();
    _questions = MockData.sampleQuestions;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _finishQuiz();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _finishQuiz() {
    _timer?.cancel();
    int correctCount = 0;
    final List<QuestionReviewItem> reviewItems = [];

    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final selected = _selectedAnswers[i] ?? -1;
      if (selected == q.correctIndex) {
        correctCount++;
      }
      reviewItems.add(
        QuestionReviewItem(
          questionText: q.question,
          options: q.options,
          selectedAnswerIndex: selected,
          correctAnswerIndex: q.correctIndex,
          explanation: q.explanation,
        ),
      );
    }

    final percentage = ((correctCount / _questions.length) * 100);
    final isPassed = percentage >= 70;
    final timeSpent = 900 - _secondsRemaining;

    final attempt = QuizAttemptResult(
      id: 'att-${DateTime.now().millisecondsSinceEpoch}',
      quizTitle: widget.title,
      score: correctCount,
      totalQuestions: _questions.length,
      percentage: percentage,
      isPassed: isPassed,
      attemptedAt: DateTime.now(),
      timeTaken: _formatTime(timeSpent),
      questions: reviewItems,
    );

    context.read<AppStateProvider>().addQuizAttempt(attempt);

    setState(() {
      _isSubmitted = true;
    });

    _showResultDialog(correctCount);
  }

  void _showResultDialog(int correctCount) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentage = ((correctCount / _questions.length) * 100).toInt();
    final isPassed = percentage >= 70;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: (isPassed ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPassed ? Icons.emoji_events_rounded : Icons.replay_rounded,
                color: isPassed ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                size: 40,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isPassed ? 'Outstanding! 🎉' : 'Keep Practicing! 💪',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You scored $correctCount / ${_questions.length} ($percentage%)',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isPassed ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isPassed
                  ? 'Congratulations! Your score has been recorded in the Results portal.'
                  : 'Your attempt has been saved. Review your errors and try again!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // Button to View in Results Tab
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ResultsScreen()),
                  );
                },
                icon: const Icon(Icons.assessment_rounded, size: 18),
                label: const Text('View in Results Tab'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F44B8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Done', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _currentIndex = 0;
                        _selectedAnswers.clear();
                        _isSubmitted = false;
                        _secondsRemaining = 900;
                        _startTimer();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Retry', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentQ = _questions[_currentIndex];
    final selectedOption = _selectedAnswers[_currentIndex];
    final isSaved = _savedQuestions.contains(_currentIndex);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          // Timer Widget
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: AppColors.accentOrange),
                const SizedBox(width: 6),
                Text(
                  _formatTime(_secondsRemaining),
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar & Question Counter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentIndex + 1} of ${_questions.length}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          color: isSaved ? AppColors.accentOrange : (isDark ? Colors.white70 : Colors.black54),
                        ),
                        onPressed: () {
                          setState(() {
                            if (isSaved) {
                              _savedQuestions.remove(_currentIndex);
                            } else {
                              _savedQuestions.add(_currentIndex);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) / _questions.length,
                      minHeight: 7,
                      backgroundColor: isDark ? AppColors.darkCardElevated : const Color(0xFFE5E7EB),
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Question & Options
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subject Tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withAlpha(isDark ? 50 : 25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        currentQ.category,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Question Text
                    Text(
                      currentQ.question,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Options List
                    ...List.generate(currentQ.options.length, (optIdx) {
                      final optionText = currentQ.options[optIdx];
                      final isSelected = selectedOption == optIdx;
                      final isCorrect = currentQ.correctIndex == optIdx;

                      Color borderColor;
                      Color bgColor;
                      Color textColor;

                      if (_isSubmitted || selectedOption != null) {
                        if (isSelected && isCorrect) {
                          borderColor = AppColors.success;
                          bgColor = AppColors.success.withAlpha(25);
                          textColor = AppColors.success;
                        } else if (isSelected && !isCorrect) {
                          borderColor = AppColors.error;
                          bgColor = AppColors.error.withAlpha(25);
                          textColor = AppColors.error;
                        } else if (isCorrect && _isSubmitted) {
                          borderColor = AppColors.success;
                          bgColor = AppColors.success.withAlpha(15);
                          textColor = AppColors.success;
                        } else {
                          borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
                          bgColor = isDark ? AppColors.darkCardBg : Colors.white;
                          textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
                        }
                      } else {
                        borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
                        bgColor = isDark ? AppColors.darkCardBg : Colors.white;
                        textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            if (!_isSubmitted) {
                              setState(() {
                                _selectedAnswers[_currentIndex] = optIdx;
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? borderColor
                                        : (isDark ? AppColors.darkCardElevated : const Color(0xFFF3F4F6)),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      String.fromCharCode(65 + optIdx),
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    optionText,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.5,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      color: textColor,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    // Explanation Box if answered
                    if (selectedOption != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCardElevated : const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF10B981).withAlpha(80),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.lightbulb_rounded, color: AppColors.accentOrange, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Explanation',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              currentQ.explanation,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                height: 1.4,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Navigation Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (_currentIndex > 0) ...[
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _currentIndex--);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Previous'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentIndex < _questions.length - 1) {
                          setState(() => _currentIndex++);
                        } else {
                          _finishQuiz();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text(
                        _currentIndex < _questions.length - 1 ? 'Next Question' : 'Finish Quiz',
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
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
}
