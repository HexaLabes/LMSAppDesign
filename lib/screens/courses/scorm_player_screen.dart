import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/course_models.dart';

class ScormPlayerScreen extends StatefulWidget {
  final LmsCourse course;
  final LmsModule module;
  final LmsScormPackage scormPackage;

  const ScormPlayerScreen({
    super.key,
    required this.course,
    required this.module,
    required this.scormPackage,
  });

  @override
  State<ScormPlayerScreen> createState() => _ScormPlayerScreenState();
}

class _ScormPlayerScreenState extends State<ScormPlayerScreen> {
  late int _currentChapterIndex;
  late List<int?> _selectedAnswers;
  late List<bool> _answeredCorrectly;

  @override
  void initState() {
    super.initState();
    _currentChapterIndex = widget.scormPackage.currentChapterIndex;
    _selectedAnswers = List.filled(widget.scormPackage.chapters.length, null);
    _answeredCorrectly = List.filled(widget.scormPackage.chapters.length, false);
  }

  double get _progressPercent {
    if (widget.scormPackage.chapters.isEmpty) return 1.0;
    return (_currentChapterIndex + 1) / widget.scormPackage.chapters.length;
  }

  void _nextChapter() {
    if (_currentChapterIndex < widget.scormPackage.chapters.length - 1) {
      setState(() {
        _currentChapterIndex++;
        widget.scormPackage.currentChapterIndex = _currentChapterIndex;
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _prevChapter() {
    if (_currentChapterIndex > 0) {
      setState(() {
        _currentChapterIndex--;
        widget.scormPackage.currentChapterIndex = _currentChapterIndex;
      });
    }
  }

  void _selectQuizOption(int optionIndex) {
    final chapter = widget.scormPackage.chapters[_currentChapterIndex];
    if (chapter.correctAnswerIndex == null) return;

    setState(() {
      _selectedAnswers[_currentChapterIndex] = optionIndex;
      final isCorrect = optionIndex == chapter.correctAnswerIndex;
      _answeredCorrectly[_currentChapterIndex] = isCorrect;
    });
  }

  void _showCompletionDialog() {
    setState(() {
      widget.scormPackage.status = 'Completed';
      widget.scormPackage.score = 95.0;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withAlpha(120),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 18),
              Text(
                'SCORM Package Completed!',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You have successfully passed all interactive checkpoints in ${widget.scormPackage.title}',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withAlpha(30)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('Score', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                        Text('95%', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF10B981))),
                      ],
                    ),
                    Container(width: 1, height: 28, color: Colors.white24),
                    Column(
                      children: [
                        Text('SCORM CMI', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                        Text('PASSED', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF38BDF8))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.pop(context); // exit player
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Return to Course Module', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chapter = widget.scormPackage.chapters[_currentChapterIndex];
    final selectedAnswer = _selectedAnswers[_currentChapterIndex];
    final hasQuiz = chapter.quizQuestion != null;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            // 1. SCORM GLASSMORPHIC HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                border: Border(
                  bottom: BorderSide(color: Color(0xFF334155), width: 1),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF38BDF8).withAlpha(40),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'SCORM 1.2 PLAYER',
                                style: GoogleFonts.inter(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF38BDF8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Chap ${_currentChapterIndex + 1}/${widget.scormPackage.chapters.length}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.scormPackage.title,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Progress indicator
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${(_progressPercent * 100).toInt()}%',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 60,
                        height: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: _progressPercent,
                            backgroundColor: const Color(0xFF334155),
                            valueColor: const AlwaysStoppedAnimation(Color(0xFF10B981)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. SCORM CONTENT BODY
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Chapter Title Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3A8A), Color(0xFF1E293B)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF3B82F6).withAlpha(80)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withAlpha(50),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.school_rounded, color: Color(0xFF60A5FA), size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            chapter.title,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Content Body Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Learning Concept & Directives',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF93C5FD),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          chapter.content,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            height: 1.6,
                            color: const Color(0xFFE2E8F0),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFF334155)),
                        const SizedBox(height: 12),
                        Text(
                          'Key Takeaways:',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...chapter.keyPoints.map((point) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981), size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    point,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      color: const Color(0xFFCBD5E1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Interactive Quiz Checkpoint (If present in SCORM package)
                  if (hasQuiz)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selectedAnswer != null
                              ? (selectedAnswer == chapter.correctAnswerIndex
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444))
                              : const Color(0xFFF59E0B).withAlpha(120),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF59E0B).withAlpha(40),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'SCORM KNOWLEDGE CHECK',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFF59E0B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            chapter.quizQuestion!,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Quiz Options
                          ...List.generate(chapter.quizOptions!.length, (optIndex) {
                            final isChosen = selectedAnswer == optIndex;
                            final isCorrect = optIndex == chapter.correctAnswerIndex;

                            Color borderCol = const Color(0xFF334155);
                            Color bgCol = const Color(0xFF0F172A);

                            if (selectedAnswer != null) {
                              if (isCorrect) {
                                borderCol = const Color(0xFF10B981);
                                bgCol = const Color(0xFF10B981).withAlpha(30);
                              } else if (isChosen) {
                                borderCol = const Color(0xFFEF4444);
                                bgCol = const Color(0xFFEF4444).withAlpha(30);
                              }
                            }

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: bgCol,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: borderCol),
                              ),
                              child: ListTile(
                                onTap: selectedAnswer == null ? () => _selectQuizOption(optIndex) : null,
                                dense: true,
                                leading: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: const Color(0xFF334155),
                                  child: Text(
                                    String.fromCharCode(65 + optIndex),
                                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  chapter.quizOptions![optIndex],
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    color: Colors.white,
                                    fontWeight: isChosen ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                                trailing: selectedAnswer != null
                                    ? (isCorrect
                                        ? const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20)
                                        : (isChosen ? const Icon(Icons.cancel_rounded, color: Color(0xFFEF4444), size: 20) : null))
                                    : null,
                              ),
                            );
                          }),

                          if (selectedAnswer != null && chapter.explanation != null) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFF334155)),
                              ),
                              child: Text(
                                'Explanation: ${chapter.explanation!}',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // 3. BOTTOM NAVIGATION BAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                border: Border(top: BorderSide(color: Color(0xFF334155), width: 1)),
              ),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _currentChapterIndex > 0 ? _prevChapter : null,
                    icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
                    label: const Text('Previous'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Color(0xFF475569)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _nextChapter,
                    icon: Icon(
                      _currentChapterIndex == widget.scormPackage.chapters.length - 1
                          ? Icons.check_circle_rounded
                          : Icons.arrow_forward_ios_rounded,
                      size: 14,
                    ),
                    label: Text(
                      _currentChapterIndex == widget.scormPackage.chapters.length - 1 ? 'Finish SCORM' : 'Next Chapter',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
