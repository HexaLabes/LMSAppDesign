import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/course_models.dart';
import '../../models/mock_courses_data.dart';
import '../../theme/app_theme.dart';
import 'course_detail_screen.dart';
import 'course_module_screen.dart';
import 'scorm_player_screen.dart';

class CoursesHubScreen extends StatefulWidget {
  final int initialTabIndex;

  const CoursesHubScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<CoursesHubScreen> createState() => _CoursesHubScreenState();
}

class _CoursesHubScreenState extends State<CoursesHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Professional Certification',
    'Health & Safety Management',
    'Computer Science & Software',
    'Language & Communication',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<LmsCourse> get _filteredCourses {
    return MockCoursesData.courses.where((course) {
      final matchesQuery = course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.instructorName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || course.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          'LMS Course Portal',
          style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF0F44B8),
          unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          indicatorColor: const Color(0xFF0F44B8),
          indicatorWeight: 3,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: const [
            Tab(text: 'Enrolled Courses'),
            Tab(text: 'Explore Catalog'),
            Tab(text: 'SCORM Packages'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search & Category Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCardBg : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search courses, lectures, instructors...',
                        hintStyle: GoogleFonts.inter(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF0F44B8)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(
                              cat,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: const Color(0xFF0F44B8),
                            backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedCategory = cat);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEnrolledTab(isDark),
                  _buildCatalogTab(isDark),
                  _buildScormTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnrolledTab(bool isDark) {
    final enrolled = _filteredCourses.where((c) => c.isEnrolled).toList();

    if (enrolled.isEmpty) {
      return Center(
        child: Text(
          'No enrolled courses found.',
          style: GoogleFonts.inter(color: isDark ? Colors.white60 : Colors.black54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      itemCount: enrolled.length,
      itemBuilder: (context, index) {
        final course = enrolled[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 30 : 10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CourseDetailScreen(course: course),
                ),
              );
            },
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      child: Image.network(
                        course.thumbnailUrl,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(height: 140, color: const Color(0xFF0F44B8)),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F44B8),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          course.category,
                          style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),
                    if (course.hasScorm)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF38BDF8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'SCORM 1.2',
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.black),
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Instructor: ${course.instructorName}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: course.progress,
                                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                                valueColor: const AlwaysStoppedAnimation(Color(0xFF10B981)),
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${(course.progress * 100).toInt()}%',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFF10B981)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${course.modulesCount} Modules • ${course.lecturesCount} Lectures',
                            style: GoogleFonts.inter(fontSize: 11.5, color: Colors.grey),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CourseModuleScreen(course: course),
                                ),
                              );
                            },
                            icon: const Icon(Icons.play_arrow_rounded, size: 16),
                            label: const Text('Resume'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F44B8),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
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
        );
      },
    );
  }

  Widget _buildCatalogTab(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      itemCount: _filteredCourses.length,
      itemBuilder: (context, index) {
        final course = _filteredCourses[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CourseDetailScreen(course: course),
                ),
              );
            },
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      course.thumbnailUrl,
                      width: 85,
                      height: 85,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 85, height: 85, color: const Color(0xFF0F44B8)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F44B8).withAlpha(20),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            course.level,
                            style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: const Color(0xFF0F44B8)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course.title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                            const SizedBox(width: 2),
                            Text('${course.rating}', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 8),
                            Text('• ${course.duration}', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'PKR ${course.courseFee}',
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF0F44B8)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScormTab(bool isDark) {
    final scormCourses = _filteredCourses.where((c) => c.hasScorm).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      itemCount: scormCourses.length,
      itemBuilder: (context, index) {
        final course = scormCourses[index];
        final scormModule = course.modules.firstWhere((m) => m.scormPackage != null, orElse: () => course.modules.first);
        final scorm = scormModule.scormPackage;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                  : [const Color(0xFFEFF6FF), const Color(0xFFF8FAFC)],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF3B82F6).withAlpha(120)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withAlpha(isDark ? 60 : 30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.extension_rounded, color: Color(0xFF3B82F6), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SCORM 1.2 DIGITAL MODULE',
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF3B82F6)),
                        ),
                        Text(
                          course.title,
                          style: GoogleFonts.inter(
                            fontSize: 14.5,
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
                scorm?.description ?? 'Interactive safety and instructional design SCORM simulation.',
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
                    if (scorm != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ScormPlayerScreen(
                            course: course,
                            module: scormModule,
                            scormPackage: scorm,
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.play_circle_fill_rounded, size: 18),
                  label: const Text('Play Interactive SCORM Package'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
