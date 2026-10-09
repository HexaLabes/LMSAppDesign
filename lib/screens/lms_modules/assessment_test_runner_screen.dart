import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/lms_data.dart';
import '../../models/models.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_theme.dart';

class AssessmentTestRunnerScreen extends StatefulWidget {
  final String courseTitle;
  final LmsAssessmentModuleItem testModule;
  final bool isSimulatorMode;

  const AssessmentTestRunnerScreen({
    super.key,
    required this.courseTitle,
    required this.testModule,
    this.isSimulatorMode = false,
  });

  @override
  State<AssessmentTestRunnerScreen> createState() => _AssessmentTestRunnerScreenState();
}

class _AssessmentTestRunnerScreenState extends State<AssessmentTestRunnerScreen> {
  late List<LmsAssessmentQuestion> _questions;
  int _currentIndex = 0;
  final Map<int, String> _userAnswers = {}; // questionId -> answer string
  final Map<int, TextEditingController> _textControllers = {};

  Timer? _timer;
  int _secondsLeft = 30;
  bool _isSubmitted = false;
  DateTime _startTime = DateTime.now();
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _questions = widget.testModule.questions;
    _startTime = DateTime.now();

    for (var q in _questions) {
      _textControllers[q.id] = TextEditingController();
    }

    if (_questions.isNotEmpty) {
      _resetQuestionTimer(_questions[0].timeLimitSeconds);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var ctrl in _textControllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _resetQuestionTimer(int seconds) {
    _timer?.cancel();
    setState(() {
      _secondsLeft = seconds > 0 ? seconds : 45;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_secondsLeft > 1) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        t.cancel();
        _saveCurrentInput();
        if (_currentIndex < _questions.length - 1) {
          _goToQuestion(_currentIndex + 1);
        }
      }
    });
  }

  void _saveCurrentInput() {
    if (_questions.isEmpty || _currentIndex >= _questions.length) return;
    final q = _questions[_currentIndex];

    if (q.questionType == AssessmentQuestionType.fillInTheBlanks ||
        q.questionType == AssessmentQuestionType.shortAnswer) {
      final text = _textControllers[q.id]?.text.trim() ?? '';
      if (text.isNotEmpty) {
        _userAnswers[q.id] = text;
      }
    }
  }

  void _goToQuestion(int index) {
    if (index < 0 || index >= _questions.length) return;
    _saveCurrentInput();

    setState(() {
      _currentIndex = index;
    });

    _resetQuestionTimer(_questions[_currentIndex].timeLimitSeconds);
  }

  void _selectSingleChoice(int qId, int optIndex) {
    setState(() {
      _userAnswers[qId] = optIndex.toString();
    });
  }

  void _toggleMultipleChoice(int qId, int optIndex) {
    final currentStr = _userAnswers[qId] ?? '';
    final list = currentStr.isEmpty ? <String>[] : currentStr.split(',').map((e) => e.trim()).toList();
    final optStr = optIndex.toString();

    if (list.contains(optStr)) {
      list.remove(optStr);
    } else {
      list.add(optStr);
    }
    list.sort();

    setState(() {
      _userAnswers[qId] = list.join(',');
    });
  }

  void _selectTrueFalse(int qId, bool isTrue) {
    setState(() {
      _userAnswers[qId] = isTrue ? 'True' : 'False';
    });
  }

  void _insertWordFromBank(int qId, String word) {
    final ctrl = _textControllers[qId];
    if (ctrl != null) {
      ctrl.text = word;
      _userAnswers[qId] = word;
      setState(() {});
    }
  }

  bool _isAnswerCorrect(LmsAssessmentQuestion q) {
    final ans = (_userAnswers[q.id] ?? '').trim().toLowerCase();
    final correct = q.correctAnswer.trim().toLowerCase();

    if (q.questionType == AssessmentQuestionType.multipleChoice) {
      final userSet = ans.split(',').map((e) => e.trim()).toSet();
      final correctSet = correct.split(',').map((e) => e.trim()).toSet();
      return userSet.isNotEmpty && userSet.length == correctSet.length && userSet.containsAll(correctSet);
    }

    if (q.questionType == AssessmentQuestionType.fillInTheBlanks) {
      return ans == correct;
    }

    if (q.questionType == AssessmentQuestionType.trueFalse) {
      return ans == correct;
    }

    if (q.questionType == AssessmentQuestionType.shortAnswer) {
      return ans.isNotEmpty; // short answer marked complete
    }

    return ans == correct;
  }

  void _submitAssessment() {
    _saveCurrentInput();
    _timer?.cancel();

    _totalDuration = DateTime.now().difference(_startTime);

    // Calculate score
    int correctCount = 0;
    for (var q in _questions) {
      if (_isAnswerCorrect(q)) {
        correctCount++;
      }
    }

    final scorePct = (_questions.isEmpty ? 0 : (correctCount / _questions.length) * 100).toDouble();
    final isPassed = scorePct >= 65;

    // Record into AppStateProvider
    try {
      final state = context.read<AppStateProvider>();
      final attemptQuestions = _questions.map((q) {
        int selectedIndex = -1;
        int correctIndex = -1;

        if (q.questionType == AssessmentQuestionType.singleChoice) {
          selectedIndex = (int.tryParse(_userAnswers[q.id] ?? '-1') ?? 0) - 1;
          correctIndex = (int.tryParse(q.correctAnswer) ?? 0) - 1;
        }

        final optionsList = q.options.map((o) => o.text).toList();
        if (optionsList.isEmpty) {
          if (q.questionType == AssessmentQuestionType.trueFalse) {
            optionsList.addAll(['True', 'False']);
          } else {
            optionsList.add(q.correctAnswer);
          }
        }

        return QuestionReviewItem(
          questionText: q.questionText,
          options: optionsList,
          selectedAnswerIndex: selectedIndex,
          correctAnswerIndex: correctIndex,
          explanation: q.explanation.isNotEmpty ? q.explanation : 'Assessment standard key solution.',
        );
      }).toList();

      final result = QuizAttemptResult(
        id: 'asmt-${DateTime.now().millisecondsSinceEpoch}',
        quizTitle: '${widget.courseTitle} - ${widget.testModule.title}',
        score: correctCount,
        totalQuestions: _questions.length,
        percentage: scorePct,
        timeTaken: '${_totalDuration.inMinutes}m ${_totalDuration.inSeconds % 60}s',
        attemptedAt: DateTime.now(),
        isPassed: isPassed,
        questions: attemptQuestions,
      );

      state.addQuizAttempt(result);
    } catch (_) {}

    setState(() {
      _isSubmitted = true;
    });
  }

  void _showRecheckSummarySheet(bool isDark) {
    _saveCurrentInput();

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
                          'Recheck Assessment Answers',
                          style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'Review or edit any response before final submission',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F44B8).withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_userAnswers.length}/${_questions.length} Answered',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F44B8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: _questions.length,
                  itemBuilder: (c, idx) {
                    final q = _questions[idx];
                    final hasAns = _userAnswers.containsKey(q.id) && (_userAnswers[q.id]?.isNotEmpty ?? false);
                    final ansText = _userAnswers[q.id] ?? '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardBg : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: hasAns ? const Color(0xFF10B981).withAlpha(120) : (isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (hasAns ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withAlpha(25),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              hasAns ? 'ATTEMPTED' : 'UNANSWERED',
                              style: GoogleFonts.inter(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: hasAns ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Q${idx + 1}. ${q.questionText}',
                                  style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (hasAns)
                                  Text(
                                    'Your answer: $ansText',
                                    style: GoogleFonts.inter(fontSize: 11, color: isDark ? Colors.white70 : Colors.black87, fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _goToQuestion(idx);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF0F44B8),
                              side: const BorderSide(color: Color(0xFF0F44B8)),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Jump', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Continue Test'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _submitAssessment();
                      },
                      icon: const Icon(Icons.check_circle_rounded, size: 18),
                      label: const Text('Submit Final Test'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
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

    if (_isSubmitted) {
      return _buildResultView(context, isDark);
    }

    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        appBar: AppBar(title: Text(widget.testModule.title)),
        body: const Center(child: Text('No questions available in this assessment test.')),
      );
    }

    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          widget.testModule.title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 22),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Exit Assessment?'),
                content: const Text('Your current assessment progress will be lost if you leave now.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Stay')),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                    child: const Text('Exit Test'),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.rule_rounded),
            tooltip: 'Recheck all answers',
            onPressed: () => _showRecheckSummarySheet(isDark),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header stats bar (Type Badge, Q num, Timer)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuestionTypeBadge(q.questionType),
                  Text(
                    'Question ${_currentIndex + 1} of ${_questions.length}',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: _secondsLeft <= 10 ? const Color(0xFFEF4444) : const Color(0xFF0F44B8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '00:${_secondsLeft.toString().padLeft(2, '0')}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: _secondsLeft <= 10 ? const Color(0xFFEF4444) : const Color(0xFF0F44B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Question Navigator Grid Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              color: isDark ? AppColors.darkCardElevated : const Color(0xFFF1F5F9),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_questions.length, (idx) {
                          final isCurrent = idx == _currentIndex;
                          final qItem = _questions[idx];
                          final isAns = _userAnswers.containsKey(qItem.id) && (_userAnswers[qItem.id]?.isNotEmpty ?? false);

                          Color bg = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
                          Color txtColor = isDark ? Colors.white70 : Colors.black87;
                          Border? border;

                          if (isAns) {
                            bg = const Color(0xFF10B981);
                            txtColor = Colors.white;
                          }

                          if (isCurrent) {
                            border = Border.all(color: const Color(0xFF0F44B8), width: 2.5);
                          }

                          return GestureDetector(
                            onTap: () => _goToQuestion(idx),
                            child: Container(
                              width: 34,
                              height: 34,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: bg,
                                borderRadius: BorderRadius.circular(8),
                                border: border,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${idx + 1}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: txtColor,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _showRecheckSummarySheet(isDark),
                    icon: const Icon(Icons.checklist_rounded, size: 16),
                    label: Text(
                      'Recheck (${_userAnswers.length}/${_questions.length})',
                      style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w800),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF0F44B8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),

            // Question Main Body Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question text
                    Text(
                      q.questionText,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.45,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Interactive Input based on Question Type
                    _buildQuestionInputArea(q, isDark),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: _currentIndex > 0 ? () => _goToQuestion(_currentIndex - 1) : null,
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Previous'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  if (_currentIndex == _questions.length - 1)
                    ElevatedButton.icon(
                      onPressed: _submitAssessment,
                      icon: const Icon(Icons.check_circle_rounded, size: 18),
                      label: const Text('Submit Assessment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () => _goToQuestion(_currentIndex + 1),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: const Text('Next Question'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F44B8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
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

  Widget _buildQuestionTypeBadge(AssessmentQuestionType type) {
    String label;
    Color color;

    switch (type) {
      case AssessmentQuestionType.singleChoice:
        label = 'Single Choice';
        color = const Color(0xFF0F44B8);
        break;
      case AssessmentQuestionType.multipleChoice:
        label = 'Multiple Choice';
        color = const Color(0xFF10B981);
        break;
      case AssessmentQuestionType.fillInTheBlanks:
        label = 'Fill in the Blanks';
        color = const Color(0xFFF59E0B);
        break;
      case AssessmentQuestionType.trueFalse:
        label = 'True / False';
        color = const Color(0xFF6366F1);
        break;
      case AssessmentQuestionType.shortAnswer:
        label = 'Short Answer';
        color = const Color(0xFF64748B);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildQuestionInputArea(LmsAssessmentQuestion q, bool isDark) {
    switch (q.questionType) {
      case AssessmentQuestionType.singleChoice:
        return _buildSingleChoiceOptions(q, isDark);
      case AssessmentQuestionType.multipleChoice:
        return _buildMultipleChoiceOptions(q, isDark);
      case AssessmentQuestionType.fillInTheBlanks:
        return _buildFillInBlanksInput(q, isDark);
      case AssessmentQuestionType.trueFalse:
        return _buildTrueFalseInput(q, isDark);
      case AssessmentQuestionType.shortAnswer:
        return _buildShortAnswerInput(q, isDark);
    }
  }

  Widget _buildSingleChoiceOptions(LmsAssessmentQuestion q, bool isDark) {
    final selectedVal = _userAnswers[q.id];

    return Column(
      children: q.options.map((opt) {
        final isSelected = selectedVal == opt.index.toString();
        final letter = String.fromCharCode(64 + opt.index);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF0F44B8).withAlpha(isDark ? 40 : 15)
                : (isDark ? AppColors.darkCardBg : Colors.white),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? const Color(0xFF0F44B8) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: InkWell(
            onTap: () => _selectSingleChoice(q.id, opt.index),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? const Color(0xFF0F44B8) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      letter,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      opt.text,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  Radio<String>(
                    value: opt.index.toString(),
                    groupValue: selectedVal,
                    activeColor: const Color(0xFF0F44B8),
                    onChanged: (val) => _selectSingleChoice(q.id, opt.index),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultipleChoiceOptions(LmsAssessmentQuestion q, bool isDark) {
    final currentStr = _userAnswers[q.id] ?? '';
    final selectedList = currentStr.isEmpty ? <String>[] : currentStr.split(',').map((e) => e.trim()).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select all options that apply:',
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        ...q.options.map((opt) {
          final isSelected = selectedList.contains(opt.index.toString());
          final letter = String.fromCharCode(64 + opt.index);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF10B981).withAlpha(isDark ? 40 : 15)
                  : (isDark ? AppColors.darkCardBg : Colors.white),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? const Color(0xFF10B981) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: InkWell(
              onTap: () => _toggleMultipleChoice(q.id, opt.index),
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? const Color(0xFF10B981) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        letter,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        opt.text,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    Checkbox(
                      value: isSelected,
                      activeColor: const Color(0xFF10B981),
                      onChanged: (val) => _toggleMultipleChoice(q.id, opt.index),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFillInBlanksInput(LmsAssessmentQuestion q, bool isDark) {
    final ctrl = _textControllers[q.id]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type your answer for the blank space:',
          style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          onChanged: (val) {
            _userAnswers[q.id] = val.trim();
          },
          decoration: InputDecoration(
            hintText: 'Type answer or select word from bank below...',
            filled: true,
            fillColor: isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF0F44B8), width: 2),
            ),
            prefixIcon: const Icon(Icons.edit_note_rounded, color: Color(0xFF0F44B8)),
          ),
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
        ),

        // Interactive Word Bank
        if (q.wordBank.isNotEmpty) ...[
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.extension_rounded, size: 16, color: Color(0xFF0F44B8)),
                    const SizedBox(width: 6),
                    Text(
                      'Word Bank (Click to insert):',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFF0F44B8)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: q.wordBank.map((word) {
                    final isInserted = ctrl.text.trim().toLowerCase() == word.trim().toLowerCase();

                    return InkWell(
                      onTap: () => _insertWordFromBank(q.id, word),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isInserted ? const Color(0xFF0F44B8) : (isDark ? AppColors.darkCardElevated : Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isInserted ? const Color(0xFF0F44B8) : (isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1)),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(isDark ? 20 : 6),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          word,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: isInserted ? Colors.white : (isDark ? Colors.white : const Color(0xFF1E293B)),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTrueFalseInput(LmsAssessmentQuestion q, bool isDark) {
    final selectedVal = _userAnswers[q.id]?.toLowerCase();

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _selectTrueFalse(q.id, true),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: selectedVal == 'true'
                    ? const Color(0xFF10B981).withAlpha(isDark ? 50 : 25)
                    : (isDark ? AppColors.darkCardBg : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selectedVal == 'true' ? const Color(0xFF10B981) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  width: selectedVal == 'true' ? 2.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 36,
                    color: selectedVal == 'true' ? const Color(0xFF10B981) : Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'TRUE',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: selectedVal == 'true' ? const Color(0xFF10B981) : (isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: InkWell(
            onTap: () => _selectTrueFalse(q.id, false),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: selectedVal == 'false'
                    ? const Color(0xFFEF4444).withAlpha(isDark ? 50 : 25)
                    : (isDark ? AppColors.darkCardBg : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selectedVal == 'false' ? const Color(0xFFEF4444) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  width: selectedVal == 'false' ? 2.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cancel_rounded,
                    size: 36,
                    color: selectedVal == 'false' ? const Color(0xFFEF4444) : Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'FALSE',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: selectedVal == 'false' ? const Color(0xFFEF4444) : (isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShortAnswerInput(LmsAssessmentQuestion q, bool isDark) {
    final ctrl = _textControllers[q.id]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type your detailed response:',
          style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          maxLines: 4,
          onChanged: (val) {
            _userAnswers[q.id] = val.trim();
          },
          decoration: InputDecoration(
            hintText: 'Enter your explanatory response here...',
            filled: true,
            fillColor: isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          style: GoogleFonts.inter(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildResultView(BuildContext context, bool isDark) {
    int correctCount = 0;
    for (var q in _questions) {
      if (_isAnswerCorrect(q)) {
        correctCount++;
      }
    }
    final scorePct = (_questions.isEmpty ? 0 : (correctCount / _questions.length) * 100).toInt();
    final isPassed = scorePct >= 65;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: const Text('Assessment Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Result Header Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 30 : 10),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (isPassed ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPassed ? Icons.emoji_events_rounded : Icons.pending_actions_rounded,
                      size: 56,
                      color: isPassed ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    isPassed ? 'Assessment Completed!' : 'Assessment Finished',
                    style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.courseTitle} - ${widget.testModule.title}',
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text('SCORE', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                              Text('$scorePct%', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900, color: const Color(0xFF0F44B8))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text('CORRECT', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                              Text('$correctCount / ${_questions.length}', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFF10B981))),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text('STATUS', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                              Text(isPassed ? 'PASSED' : 'PRACTICE', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w900, color: isPassed ? const Color(0xFF10B981) : const Color(0xFFF59E0B))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Detailed Question Review
            Text(
              'Detailed Answer Review',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),

            ..._questions.asMap().entries.map((entry) {
              final idx = entry.key;
              final q = entry.value;
              final isCorrect = _isAnswerCorrect(q);
              final userAns = _userAnswers[q.id] ?? '(Not answered)';

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCorrect ? const Color(0xFF10B981).withAlpha(120) : const Color(0xFFEF4444).withAlpha(120),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Q${idx + 1}. ${q.questionText}',
                            style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your Response: $userAns', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444))),
                          const SizedBox(height: 3),
                          Text('Correct Answer: ${q.correctAnswer}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF10B981))),
                          if (q.explanation.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text('Explanation: ${q.explanation}', style: GoogleFonts.inter(fontSize: 11.5, color: Colors.grey, height: 1.35)),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check_rounded),
              label: const Text('Return to Assessment Portal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F44B8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
