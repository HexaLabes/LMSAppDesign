import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/course_models.dart';
import '../../theme/app_theme.dart';
import 'course_discussion_screen.dart';
import 'course_module_screen.dart';
import 'course_register_screen.dart';
import 'pdf_viewer_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final LmsCourse course;

  const CourseDetailScreen({
    super.key,
    required this.course,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final course = widget.course;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(120),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(120),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.forum_outlined, size: 18, color: Colors.white),
                  ),
                  tooltip: 'Course Q&A Discussions',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CourseDiscussionScreen(course: course),
                      ),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      course.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: const Color(0xFF0F44B8)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withAlpha(60),
                            Colors.black.withAlpha(180),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 18,
                      right: 18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F44B8),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  course.category.toUpperCase(),
                                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                              ),
                              if (course.hasScorm) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF38BDF8),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'SCORM 1.2 READY',
                                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            course.title,
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF0F44B8),
                  unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  indicatorColor: const Color(0xFF0F44B8),
                  indicatorWeight: 3,
                  labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 13),
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Curriculum'),
                    Tab(text: 'Instructor'),
                    Tab(text: 'Resources'),
                  ],
                ),
                isDark,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(course, isDark),
            _buildCurriculumTab(course, isDark),
            _buildInstructorTab(course, isDark),
            _buildResourcesTab(course, isDark),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(course, isDark),
    );
  }

  Widget _buildOverviewTab(LmsCourse course, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        // Stats row
        Row(
          children: [
            _buildStatBadge(Icons.star_rounded, '${course.rating}', '(${course.ratingCount} reviews)', const Color(0xFFF59E0B), isDark),
            const SizedBox(width: 10),
            _buildStatBadge(Icons.people_alt_rounded, '${course.studentsCount}', 'Enrolled', const Color(0xFF0F44B8), isDark),
            const SizedBox(width: 10),
            _buildStatBadge(Icons.timer_rounded, course.duration, 'Total Hours', const Color(0xFF10B981), isDark),
          ],
        ),
        const SizedBox(height: 18),

        // Progress Box (If enrolled)
        if (course.isEnrolled)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Course Progress', style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700)),
                    Text('${(course.progress * 100).toInt()}% Completed', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF10B981))),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: course.progress,
                    backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF10B981)),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 20),

        // About Course
        Text(
          'About Course',
          style: GoogleFonts.inter(
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          course.description,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            height: 1.6,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 20),

        // What you will learn
        Text(
          'What You Will Learn',
          style: GoogleFonts.inter(
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 10),
        ...course.whatYouWillLearn.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.4,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCurriculumTab(LmsCourse course, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: course.modules.length,
      itemBuilder: (context, index) {
        final mod = course.modules[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: index == 0,
              leading: CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF0F44B8).withAlpha(isDark ? 60 : 25),
                child: Text(
                  '${mod.moduleNumber}',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: const Color(0xFF0F44B8)),
                ),
              ),
              title: Text(
                mod.title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              subtitle: Text(
                '${mod.lectures.length} Lectures • ${mod.duration}',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CourseModuleScreen(
                        course: course,
                        initialModuleIndex: index,
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
                child: const Text('Open'),
              ),
              children: [
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mod.description,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...mod.lectures.map((lec) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                lec.isCompleted ? Icons.check_circle_rounded : Icons.play_circle_outline_rounded,
                                size: 16,
                                color: lec.isCompleted ? const Color(0xFF10B981) : const Color(0xFF0F44B8),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  lec.title,
                                  style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                lec.duration,
                                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstructorTab(LmsCourse course, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(course.instructorAvatar),
              ),
              const SizedBox(height: 12),
              Text(
                course.instructorName,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                course.instructorRole,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Courses', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                      Text('6', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Students', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                      Text('4,500+', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Rating', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                      Text('4.9 ★', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFFF59E0B))),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CourseDiscussionScreen(course: course),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
            label: const Text('Ask Instructor in Q&A Forum'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0F44B8),
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Color(0xFF0F44B8)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResourcesTab(LmsCourse course, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: course.resources.length,
      itemBuilder: (context, index) {
        final res = course.resources[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
                child: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF6366F1), size: 24),
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
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PdfViewerScreen(
                        resource: res,
                        courseTitle: course.title,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
                ),
                child: const Text('Read'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatBadge(IconData icon, String value, String subtitle, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBg : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(value, style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w800)),
            Text(subtitle, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(LmsCourse course, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : Colors.white,
        border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (!course.isEnrolled) ...[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Course Fee', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                  Text('PKR ${course.courseFee}', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF0F44B8))),
                ],
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (course.isEnrolled) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CourseModuleScreen(course: course),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CourseRegisterScreen(course: course),
                      ),
                    );
                  }
                },
                icon: Icon(course.isEnrolled ? Icons.play_arrow_rounded : Icons.school_rounded, size: 20),
                label: Text(
                  course.isEnrolled ? 'Resume Course (Modules)' : 'Enroll in Course',
                  style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800),
                ),
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
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final bool _isDark;

  _SliverTabBarDelegate(this._tabBar, this._isDark);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: _isDark ? AppColors.darkBg : AppColors.lightBg,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
