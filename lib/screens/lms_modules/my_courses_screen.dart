import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/mock_courses_data.dart';
import '../../theme/app_theme.dart';
import '../courses/course_detail_screen.dart';
import '../courses/course_module_screen.dart';
import '../courses/courses_hub_screen.dart';
import '../courses/scorm_player_screen.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final courses = MockCoursesData.courses;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          'My Courses',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.explore_outlined),
            tooltip: 'Course Catalog',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CoursesHubScreen(initialTabIndex: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F44B8), Color(0xFF1E5CD8)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F44B8).withAlpha(isDark ? 80 : 40),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.school_rounded, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MY ENROLLED COURSES',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Access your lectures, SCORM modules and exams',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: Colors.white.withAlpha(220),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ...courses.map((course) {
              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 30 : 6),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
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
                      // Banner thumbnail with badge
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                            child: Image.network(
                              course.thumbnailUrl,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(height: 120, color: const Color(0xFF0F44B8)),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F44B8),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                course.category,
                                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ),
                          ),
                          if (course.hasScorm)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF38BDF8),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'SCORM 1.2',
                                  style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w800, color: Colors.black87),
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

                            // Progress row
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
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Action buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${course.modulesCount} Modules • ${course.lecturesCount} Lectures',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (course.hasScorm) ...[
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          final scormMod = course.modules.firstWhere((m) => m.scormPackage != null, orElse: () => course.modules.first);
                                          if (scormMod.scormPackage != null) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => ScormPlayerScreen(
                                                  course: course,
                                                  module: scormMod,
                                                  scormPackage: scormMod.scormPackage!,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.extension_rounded, size: 14),
                                        label: const Text('SCORM'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(0xFF38BDF8),
                                          side: const BorderSide(color: Color(0xFF38BDF8)),
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          textStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => CourseModuleScreen(course: course),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.play_arrow_rounded, size: 16),
                                      label: const Text('Modules'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0F44B8),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        textStyle: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
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
            }),
          ],
        ),
      ),
    );
  }
}
