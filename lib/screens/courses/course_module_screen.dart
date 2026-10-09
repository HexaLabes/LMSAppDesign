import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/course_models.dart';
import '../../theme/app_theme.dart';
import '../quiz/quiz_screen.dart';
import 'pdf_viewer_screen.dart';
import 'scorm_player_screen.dart';
import 'watch_lecture_screen.dart';

class CourseModuleScreen extends StatefulWidget {
  final LmsCourse course;
  final int initialModuleIndex;

  const CourseModuleScreen({
    super.key,
    required this.course,
    this.initialModuleIndex = 0,
  });

  @override
  State<CourseModuleScreen> createState() => _CourseModuleScreenState();
}

class _CourseModuleScreenState extends State<CourseModuleScreen> {
  late int _activeModuleIndex;

  @override
  void initState() {
    super.initState();
    _activeModuleIndex = widget.initialModuleIndex;
    if (_activeModuleIndex >= widget.course.modules.length) {
      _activeModuleIndex = 0;
    }
  }

  LmsModule get _activeModule => widget.course.modules[_activeModuleIndex];

  void _selectModule(int index) {
    if (index >= 0 && index < widget.course.modules.length) {
      setState(() {
        _activeModuleIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.course.title,
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Module ${_activeModule.moduleNumber}: ${_activeModule.title}',
              style: GoogleFonts.inter(
                fontSize: 11.5,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.view_sidebar_rounded),
              tooltip: 'All Modules',
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: _buildModuleSidebar(isDark),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            // 1. MODULE BANNER & PROGRESS
            _buildModuleBanner(isDark),
            const SizedBox(height: 20),

            // 2. VIDEO LECTURES SECTION
            _buildLecturesSection(isDark),
            const SizedBox(height: 20),

            // 3. SCORM 1.2 SIMULATION (IF AVAILABLE)
            if (_activeModule.scormPackage != null) ...[
              _buildScormSection(isDark),
              const SizedBox(height: 20),
            ],

            // 4. MODULE QUIZZES & ASSESSMENTS
            _buildAssessmentSection(isDark),
            const SizedBox(height: 20),

            // 5. MODULE RESOURCES & HANDOUTS
            if (_activeModule.resources.isNotEmpty) ...[
              _buildResourcesSection(isDark),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  // Sidebar Drawer for switching modules (Matches LMS _CourseModuleSidebar.cshtml)
  Widget _buildModuleSidebar(bool isDark) {
    return Drawer(
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Course Syllabus',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.course.modules.length} Modules in this course',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: widget.course.modules.length,
                itemBuilder: (context, index) {
                  final mod = widget.course.modules[index];
                  final isSelected = index == _activeModuleIndex;

                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? const Color(0xFF1E3A8A).withAlpha(60) : const Color(0xFFEFF6FF))
                          : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: isSelected ? const Color(0xFF0F44B8) : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context); // close drawer
                        _selectModule(index);
                      },
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: isSelected
                            ? const Color(0xFF0F44B8)
                            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        child: Text(
                          '${mod.moduleNumber}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                      ),
                      title: Text(
                        mod.title,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFF0F44B8)
                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        ),
                      ),
                      subtitle: Text(
                        '${mod.lectures.length} Lectures • ${mod.duration}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      trailing: mod.progress >= 1.0
                          ? const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0F44B8),
            const Color(0xFF1E5CD8),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F44B8).withAlpha(isDark ? 80 : 50),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
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
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'MODULE ${_activeModule.moduleNumber} OF ${widget.course.modules.length}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.timer_outlined, color: Colors.white70, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    _activeModule.duration,
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _activeModule.title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _activeModule.description,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: Colors.white.withAlpha(220),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          // Progress Bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _activeModule.progress,
                    backgroundColor: Colors.white.withAlpha(40),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF10B981)),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(_activeModule.progress * 100).toInt()}% Done',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLecturesSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Video Lectures (${_activeModule.lectures.length})',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            Text(
              '${_activeModule.lectures.where((l) => l.isCompleted).length}/${_activeModule.lectures.length} Completed',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF10B981),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        ..._activeModule.lectures.map((lec) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WatchLectureScreen(
                      course: widget.course,
                      module: _activeModule,
                      initialLecture: lec,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            lec.previewThumbnail,
                            width: 80,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 80, height: 60, color: Colors.grey),
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(160),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Lecture ${lec.lectureNumber}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F44B8),
                                ),
                              ),
                              const Spacer(),
                              if (lec.isCompleted)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withAlpha(30),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'COMPLETED',
                                    style: GoogleFonts.inter(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            lec.title,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 13,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                lec.duration,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildScormSection(bool isDark) {
    final scorm = _activeModule.scormPackage!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFEFF6FF), const Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF3B82F6).withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withAlpha(isDark ? 60 : 30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.extension_rounded, color: Color(0xFF3B82F6), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SCORM 1.2 Digital Package',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF3B82F6),
                      ),
                    ),
                    Text(
                      scorm.title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            scorm.description,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ScormPlayerScreen(
                      course: widget.course,
                      module: _activeModule,
                      scormPackage: scorm,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
              label: Text(
                scorm.status == 'Completed' ? 'Replay SCORM Module' : 'Launch Interactive SCORM Player',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Module Quizzes & Assessments',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 12),

        ..._activeModule.quizzes.map((quiz) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withAlpha(isDark ? 50 : 25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.quiz_rounded, color: Color(0xFFF59E0B), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz.title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${quiz.questionCount} Questions • ${quiz.timeLimitMinutes} Mins • Pass: ${quiz.passingScore}%',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(title: quiz.title),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F44B8),
                    foregroundColor: Colors.white,
                    textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(quiz.isCompleted ? 'Retry' : 'Attempt'),
                ),
              ],
            ),
          );
        }),

        if (_activeModule.assessmentTest != null)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF10B981).withAlpha(120)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withAlpha(isDark ? 50 : 25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.assignment_turned_in_rounded, color: Color(0xFF10B981), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _activeModule.assessmentTest!.title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Total Marks: ${_activeModule.assessmentTest!.totalMarks} • Due: ${_activeModule.assessmentTest!.dueDate}',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Starting ${_activeModule.assessmentTest!.title}...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Start Test'),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildResourcesSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Handouts & Presentations (${_activeModule.resources.length})',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 12),

        ..._activeModule.resources.map((res) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withAlpha(isDark ? 50 : 25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF6366F1), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        res.title,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${res.type} • ${res.fileSize} • ${res.pages} Pages',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_red_eye_rounded, color: Color(0xFF6366F1)),
                  tooltip: 'View in App',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PdfViewerScreen(
                          resource: res,
                          courseTitle: widget.course.title,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
