import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/lms_data.dart';
import '../../theme/app_theme.dart';
import 'assessment_test_runner_screen.dart';

class AssessmentTestScreen extends StatefulWidget {
  const AssessmentTestScreen({super.key});

  @override
  State<AssessmentTestScreen> createState() => _AssessmentTestScreenState();
}

class _AssessmentTestScreenState extends State<AssessmentTestScreen> {
  late List<LmsCourseAssessmentGroup> _groups;
  int _selectedGroupIndex = 0;
  int _selectedTestIndex = 0;

  @override
  void initState() {
    super.initState();
    _groups = LMSMockData.assessmentGroups;
  }

  LmsCourseAssessmentGroup get _selectedGroup =>
      _groups.isNotEmpty ? _groups[_selectedGroupIndex] : _groups[0];

  LmsAssessmentModuleItem get _selectedTest {
    final tests = _selectedGroup.tests;
    if (_selectedTestIndex >= tests.length) {
      return tests.isNotEmpty ? tests[0] : _groups[0].tests[0];
    }
    return tests[_selectedTestIndex];
  }

  void _startTest(LmsAssessmentModuleItem test, bool isSimulator) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AssessmentTestRunnerScreen(
          courseTitle: _selectedGroup.courseTitle,
          testModule: test,
          isSimulatorMode: isSimulator,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Blue Header Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F44B8), Color(0xFF1E5CD8)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F44B8).withAlpha(40),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.assignment_turned_in_rounded, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
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
                            'Course-level examinations, modular assessments & mock tests',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: Colors.white.withAlpha(210),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Course Selector Horizontal Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _groups.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final group = entry.value;
                    final isSelected = idx == _selectedGroupIndex;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        avatar: Icon(
                          Icons.school_rounded,
                          size: 16,
                          color: isSelected ? Colors.white : const Color(0xFF0F44B8),
                        ),
                        label: Text(
                          group.courseTitle,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0F44B8),
                        backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF0F44B8) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedGroupIndex = idx;
                              _selectedTestIndex = 0;
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Course Test Modules List
              Text(
                'Available Tests & Sections (${_selectedGroup.tests.length})',
                style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Column(
                  children: _selectedGroup.tests.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final test = entry.value;
                    final isSelected = idx == _selectedTestIndex;
                    final isLast = idx == _selectedGroup.tests.length - 1;

                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedTestIndex = idx;
                            });
                          },
                          borderRadius: BorderRadius.vertical(
                            top: idx == 0 ? const Radius.circular(16) : Radius.zero,
                            bottom: isLast ? const Radius.circular(16) : Radius.zero,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            color: isSelected
                                ? const Color(0xFF0F44B8).withAlpha(isDark ? 40 : 15)
                                : Colors.transparent,
                            child: Row(
                              children: [
                                Icon(
                                  test.isCourseLevel ? Icons.folder_rounded : Icons.bookmark_border_rounded,
                                  size: 18,
                                  color: isSelected ? const Color(0xFF0F44B8) : Colors.grey,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        test.title,
                                        style: GoogleFonts.inter(
                                          fontSize: 13.5,
                                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                          color: isSelected
                                              ? const Color(0xFF0F44B8)
                                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 3),
                                      _buildStatusChip(test.status, test.scheduledDate),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F44B8).withAlpha(isDark ? 40 : 20),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${test.questions.length}',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF0F44B8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 18,
                                  color: isSelected ? const Color(0xFF0F44B8) : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!isLast)
                          Divider(
                            height: 1,
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Active Selected Test Details Panel (Matches LMS Web View from Image)
              _buildSelectedTestCard(context, _selectedTest, isDark),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(AssessmentScheduleStatus status, String? scheduledDate) {
    String label;
    Color fg;
    IconData icon;

    switch (status) {
      case AssessmentScheduleStatus.availableToday:
        label = 'Available Today';
        fg = const Color(0xFF10B981);
        icon = Icons.check_circle_outline_rounded;
        break;
      case AssessmentScheduleStatus.upcoming:
        label = 'Upcoming (${scheduledDate ?? "Soon"})';
        fg = const Color(0xFFD97706);
        icon = Icons.lock_outline_rounded;
        break;
      case AssessmentScheduleStatus.closed:
        label = 'Closed';
        fg = Colors.grey;
        icon = Icons.event_busy_rounded;
        break;
      case AssessmentScheduleStatus.pendingSchedule:
        label = 'Pending Schedule';
        fg = const Color(0xFF64748B);
        icon = Icons.schedule_rounded;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: fg),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: fg),
        ),
      ],
    );
  }

  Widget _buildSelectedTestCard(BuildContext context, LmsAssessmentModuleItem test, bool isDark) {
    // Header for active test
    final titleText = 'ASSESSMENT TEST - ${_selectedGroup.courseTitle.toUpperCase()}';

    if (test.status == AssessmentScheduleStatus.pendingSchedule) {
      // Exactly matches media_1791553339165.png
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_box_rounded, color: Color(0xFF0F44B8), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titleText,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 25 : 6),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 56,
                  color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                ),
                const SizedBox(height: 14),
                Text(
                  'Test Schedule Pending',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'This assessment test date has not been assigned yet. Tests are only available on their assigned date.',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // Assigned date & time row
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ASSIGNED TEST DATE', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text('NOT SCHEDULED', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 32, color: isDark ? Colors.grey[800] : Colors.grey[300]),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TEST TIME', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text('TBA', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF0F44B8))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _startTest(test, true),
                    icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
                    label: const Text('Practice In Simulator Mode'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F44B8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (test.status == AssessmentScheduleStatus.upcoming) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_clock_rounded, color: Color(0xFFD97706), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titleText,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              children: [
                const Icon(Icons.lock_clock_rounded, size: 54, color: Color(0xFFD97706)),
                const SizedBox(height: 12),
                Text(
                  'Upcoming Assessment Test',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'This test is scheduled for a future date and will only be accessible on that day.',
                  style: GoogleFonts.inter(fontSize: 12.5, color: Colors.grey, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ASSIGNED TEST DATE', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(test.scheduledDate ?? 'Upcoming', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 32, color: isDark ? Colors.grey[800] : Colors.grey[300]),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TEST TIME', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(test.scheduledTime ?? 'TBA', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFFD97706))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _startTest(test, true),
                    icon: const Icon(Icons.fitness_center_rounded, size: 18),
                    label: const Text('Try Practice Simulator (Mock Questions)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F44B8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Available Today
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                titleText,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF10B981).withAlpha(120),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'AVAILABLE TODAY',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ),
                  Text(
                    '${test.questions.length} Questions',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                test.title,
                style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                test.remarks,
                style: GoogleFonts.inter(fontSize: 12.5, color: Colors.grey, height: 1.35),
              ),
              const SizedBox(height: 16),

              // Breakdown of question types included
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildQuestionTypeChip('Single Choice (MCQ)', const Color(0xFF0F44B8)),
                  _buildQuestionTypeChip('Fill In The Blanks', const Color(0xFFF59E0B)),
                  _buildQuestionTypeChip('True / False', const Color(0xFF6366F1)),
                  _buildQuestionTypeChip('Multiple Choice', const Color(0xFF10B981)),
                ],
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _startTest(test, false),
                  icon: const Icon(Icons.play_arrow_rounded, size: 20),
                  label: const Text('Start Assessment Test Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionTypeChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
