import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/course_models.dart';
import '../../theme/app_theme.dart';
import '../quiz/quiz_screen.dart';
import 'pdf_viewer_screen.dart';
import 'watch_lecture_screen.dart';

class CourseModuleScreen extends StatefulWidget {
  final LmsCourse course;
  final int initialModuleIndex;
  final bool initialShowResources;

  const CourseModuleScreen({
    super.key,
    required this.course,
    this.initialModuleIndex = 0,
    this.initialShowResources = false,
  });

  @override
  State<CourseModuleScreen> createState() => _CourseModuleScreenState();
}

class _CourseModuleScreenState extends State<CourseModuleScreen> {
  late int _activeModuleIndex;
  bool _showingCourseResources = false;

  @override
  void initState() {
    super.initState();
    _showingCourseResources = widget.initialShowResources;
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
        _showingCourseResources = false;
      });
    }
  }

  void _showResourcesView() {
    setState(() {
      _showingCourseResources = true;
    });
  }

  void _showInstructorProfile() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
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
              const SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: NetworkImage(widget.course.instructorAvatar),
                    onBackgroundImageError: (_, __) {},
                    child: widget.course.instructorAvatar.isEmpty
                        ? const Icon(Icons.person, size: 36)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.course.instructorName,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.course.instructorRole,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF0F44B8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                widget.course.instructorEmail,
                                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Instructor Overview',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Certified master trainer with extensive experience delivering international curriculums, assessments, and corporate training programs for leading institutions.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  height: 1.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Message request sent to ${widget.course.instructorName}'),
                        backgroundColor: const Color(0xFF0F44B8),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text('Contact Instructor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F44B8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _downloadResource(LmsResource res) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.downloading_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Downloading "${res.title}" (${res.fileSize})...',
                style: GoogleFonts.inter(fontSize: 12.5),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
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
              '${widget.course.title} Modules',
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _showingCourseResources
                  ? 'Course Resources'
                  : 'Module ${_activeModule.moduleNumber}: ${_activeModule.title}',
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
              icon: const Icon(Icons.menu_book_rounded),
              tooltip: 'Module Navigation',
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: _buildModuleDrawer(isDark),
      bottomNavigationBar: _buildBottomNavToolbar(isDark),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Instructor Button + Course Quick Switcher
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _showInstructorProfile,
                      icon: const Icon(Icons.account_circle_outlined, size: 17),
                      label: const Text('COURSE INSTRUCTOR PROFILE'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F44B8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        textStyle: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w800, letterSpacing: 0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Tab Selector for Fast Switching (Course Resources & Modules)
            _buildHorizontalSelector(isDark),

            // Main Content Area
            Expanded(
              child: _showingCourseResources
                  ? _buildCourseResourcesView(isDark)
                  : _buildActiveModuleView(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalSelector(bool isDark) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: [
          // Course Resources Tab
          _buildSelectorPill(
            title: '📁 Course Resources',
            isSelected: _showingCourseResources,
            onTap: _showResourcesView,
            isDark: isDark,
          ),
          const SizedBox(width: 8),

          // Modules Tabs
          ...widget.course.modules.asMap().entries.map((entry) {
            final idx = entry.key;
            final mod = entry.value;
            final isSelected = !_showingCourseResources && _activeModuleIndex == idx;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildSelectorPill(
                title: '${mod.title} >',
                isSelected: isSelected,
                onTap: () => _selectModule(idx),
                isDark: isDark,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSelectorPill({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0F44B8)
              : (isDark ? const Color(0xFF334155) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0F44B8)
                : (isDark ? Colors.transparent : Colors.grey.withAlpha(40)),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseResourcesView(bool isDark) {
    final resources = widget.course.resources;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Section Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F44B8).withAlpha(isDark ? 50 : 20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.folder_open_rounded, color: Color(0xFF0F44B8), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Course Resources',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    '${resources.length} textbooks, presentations & study handouts available',
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
        const SizedBox(height: 16),

        if (resources.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            child: Text(
              'No course resources uploaded for this course yet.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          )
        else
          ...resources.map((res) => _buildResourceCard(res, isDark)),
      ],
    );
  }

  Widget _buildResourceCard(LmsResource res, bool isDark) {
    IconData iconData = Icons.picture_as_pdf_rounded;
    Color badgeColor = const Color(0xFF6366F1);

    if (res.type.toLowerCase().contains('book')) {
      iconData = Icons.menu_book_rounded;
      badgeColor = const Color(0xFF0F44B8);
    } else if (res.type.toLowerCase().contains('presentation')) {
      iconData = Icons.slideshow_rounded;
      badgeColor = const Color(0xFFE11D48);
    } else if (res.type.toLowerCase().contains('study')) {
      iconData = Icons.library_books_rounded;
      badgeColor = const Color(0xFF10B981);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 10),
            blurRadius: 8,
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: badgeColor.withAlpha(isDark ? 50 : 25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(iconData, color: badgeColor, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: badgeColor.withAlpha(isDark ? 40 : 20),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              res.type.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: badgeColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            res.fileSize,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        res.title,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      if (res.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          res.description,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _downloadResource(res),
                  icon: const Icon(Icons.download_rounded, size: 16),
                  label: const Text('DOWNLOAD'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? Colors.white70 : Colors.black87,
                    side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    textStyle: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
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
                  icon: const Icon(Icons.visibility_rounded, size: 16),
                  label: const Text('VIEW'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F44B8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
  }

  Widget _buildActiveModuleView(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Module Banner & Header
        _buildModuleHeader(isDark),
        const SizedBox(height: 18),

        // Video Lectures Section
        _buildLecturesSection(isDark),
        const SizedBox(height: 18),

        // Module Quizzes & Assessments (if any)
        if (_activeModule.quizzes.isNotEmpty || _activeModule.assessmentTest != null) ...[
          _buildAssessmentSection(isDark),
          const SizedBox(height: 18),
        ],

        // Module Handouts (if any)
        if (_activeModule.resources.isNotEmpty) ...[
          _buildModuleHandoutsSection(isDark),
          const SizedBox(height: 18),
        ],
      ],
    );
  }

  Widget _buildModuleHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F44B8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'MODULE ${_activeModule.moduleNumber}',
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    _activeModule.duration,
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _activeModule.title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          if (_activeModule.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              _activeModule.description,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _activeModule.progress,
                    backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
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
                  color: const Color(0xFF10B981),
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
              'Module Lectures (${_activeModule.lectures.length})',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            Text(
              'Video & Notes',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (_activeModule.lectures.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'No video lectures posted for this module yet.',
              style: GoogleFonts.inter(fontSize: 12.5, color: Colors.grey),
            ),
          )
        else
          ..._activeModule.lectures.map((lec) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        lec.previewThumbnail,
                        width: 70,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 70, height: 50, color: const Color(0xFF0F44B8)),
                      ),
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(150),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ),
                title: Text(
                  'Lecture ${lec.lectureNumber}: ${lec.title}',
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(lec.duration, style: GoogleFonts.inter(fontSize: 11.5, color: Colors.grey)),
                      const SizedBox(width: 10),
                      if (lec.isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withAlpha(30),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Completed',
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF10B981)),
                          ),
                        ),
                    ],
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F44B8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                  child: const Text('Watch'),
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildAssessmentSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quizzes & Assessment',
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
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${quiz.questionCount} Questions • ${quiz.timeLimitMinutes} mins • Pass: ${quiz.passingScore}%',
                        style: GoogleFonts.inter(fontSize: 11.5, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(title: '${widget.course.title} Quiz'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    foregroundColor: Colors.white,
                    textStyle: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(quiz.isCompleted ? 'Retake' : 'Start'),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildModuleHandoutsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Module Handouts (${_activeModule.resources.length})',
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
                        style: GoogleFonts.inter(fontSize: 11.5, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_red_eye_rounded, color: Color(0xFF0F44B8)),
                  tooltip: 'View',
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

  Widget _buildBottomNavToolbar(bool isDark) {
    final hasPrev = !_showingCourseResources && _activeModuleIndex > 0;
    final hasNext = !_showingCourseResources && _activeModuleIndex < widget.course.modules.length - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 10),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Module Arrow Button
            OutlinedButton.icon(
              onPressed: hasPrev
                  ? () => _selectModule(_activeModuleIndex - 1)
                  : (_showingCourseResources && widget.course.modules.isNotEmpty
                      ? () => _selectModule(0)
                      : null),
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
              label: const Text('Previous'),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : Colors.black87,
                disabledForegroundColor: Colors.grey.withAlpha(100),
                side: BorderSide(
                  color: hasPrev || (_showingCourseResources && widget.course.modules.isNotEmpty)
                      ? (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                      : Colors.transparent,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),

            // Resources Shortcut Pill
            InkWell(
              onTap: _showResourcesView,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: _showingCourseResources
                      ? const Color(0xFF0F44B8)
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.folder_open_rounded,
                      size: 16,
                      color: _showingCourseResources
                          ? Colors.white
                          : (isDark ? Colors.white70 : const Color(0xFF0F44B8)),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Resources',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _showingCourseResources
                            ? Colors.white
                            : (isDark ? Colors.white70 : const Color(0xFF0F44B8)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Next Module Arrow Button
            ElevatedButton.icon(
              onPressed: _showingCourseResources
                  ? () => _selectModule(0)
                  : (hasNext ? () => _selectModule(_activeModuleIndex + 1) : null),
              icon: const Text('Next'),
              label: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F44B8),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.withAlpha(50),
                disabledForegroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleDrawer(bool isDark) {
    return Drawer(
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.course.title,
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Course Navigation',
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Course Resources Entry
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F44B8).withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.folder_open_rounded, color: Color(0xFF0F44B8), size: 20),
              ),
              title: Text(
                'Course Resources',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: _showingCourseResources ? FontWeight.w800 : FontWeight.w600,
                  color: _showingCourseResources ? const Color(0xFF0F44B8) : null,
                ),
              ),
              subtitle: Text(
                '${widget.course.resources.length} textbooks & handouts',
                style: GoogleFonts.inter(fontSize: 11.5, color: Colors.grey),
              ),
              trailing: const Icon(Icons.chevron_right_rounded, size: 20),
              selected: _showingCourseResources,
              selectedTileColor: const Color(0xFF0F44B8).withAlpha(15),
              onTap: () {
                Navigator.pop(context);
                _showResourcesView();
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'MODULES',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1),
              ),
            ),

            // Modules list
            Expanded(
              child: ListView.builder(
                itemCount: widget.course.modules.length,
                itemBuilder: (ctx, idx) {
                  final mod = widget.course.modules[idx];
                  final isCurrent = !_showingCourseResources && _activeModuleIndex == idx;

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: isCurrent ? const Color(0xFF0F44B8) : Colors.grey.withAlpha(40),
                      child: Text(
                        '${mod.moduleNumber}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isCurrent ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                    ),
                    title: Text(
                      mod.title,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                        color: isCurrent ? const Color(0xFF0F44B8) : null,
                      ),
                    ),
                    subtitle: Text(
                      '${mod.lectures.length} Lectures • ${mod.duration}',
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                    selected: isCurrent,
                    selectedTileColor: const Color(0xFF0F44B8).withAlpha(15),
                    onTap: () {
                      Navigator.pop(context);
                      _selectModule(idx);
                    },
                  );
                },
              ),
            ),

            // Bottom instructor button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showInstructorProfile();
                  },
                  icon: const Icon(Icons.person_rounded, size: 16),
                  label: const Text('Instructor Profile'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
