import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/lms_data.dart';
import '../../theme/app_theme.dart';

class CourseProgressScreen extends StatefulWidget {
  const CourseProgressScreen({super.key});

  @override
  State<CourseProgressScreen> createState() => _CourseProgressScreenState();
}

class _CourseProgressScreenState extends State<CourseProgressScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          'Course Progress',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tabs Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : const Color(0xFFEFF2FE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFF0F44B8),
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: isDark ? Colors.white70 : const Color(0xFF475569),
                labelStyle: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700),
                unselectedLabelStyle: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Quizzes'),
                  Tab(text: 'Assessment'),
                  Tab(text: 'Attendance'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildQuizzesTab(isDark),
                  _buildAssessmentTab(isDark),
                  _buildAttendanceTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizzesTab(bool isDark) {
    final courseProgress = [
      {
        'course': 'Web Development',
        'attempted': 32,
        'total': 40,
        'percent': 80.0,
        'attempts': 6,
        'avgScore': 91.5,
      },
      {
        'course': 'IELTS Preparation',
        'attempted': 28,
        'total': 40,
        'percent': 70.0,
        'attempts': 4,
        'avgScore': 85.0,
      },
      {
        'course': 'Advanced Problem Solving',
        'attempted': 12,
        'total': 30,
        'percent': 40.0,
        'attempts': 2,
        'avgScore': 78.0,
      },
      {
        'course': 'Elementary Level 50 & 60WPM',
        'attempted': 18,
        'total': 20,
        'percent': 90.0,
        'attempts': 3,
        'avgScore': 95.0,
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        // Overall Summary Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'OVERALL QUIZ PROGRESS',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '76.92%',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F44B8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '90 / 130 questions attempted across all enrolled courses',
                style: GoogleFonts.inter(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        Text(
          'Quiz Attempts by Course',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),

        ...courseProgress.map((item) {
          final pct = (item['percent'] as double) / 100;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
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
                    Expanded(
                      child: Text(
                        item['course'] as String,
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      '${item['percent']}%',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF0F44B8)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 6,
                    backgroundColor: isDark ? AppColors.darkCardElevated : const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F44B8)),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Attempted: ${item['attempted']} / ${item['total']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('Avg Score: ${item['avgScore']}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF10B981))),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAssessmentTab(bool isDark) {
    final assignments = LMSMockData.assignments;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: assignments.map((asg) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      asg.title,
                      style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: asg.status == 'Submitted' || asg.status == 'Checked' ? const Color(0xFF198754) : const Color(0xFFDC3545),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      asg.status,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('Course: ${asg.courseTitle} • Due: ${asg.dueDate}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              if (asg.marks != null) ...[
                const SizedBox(height: 6),
                Text('Obtained Marks: ${asg.marks}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F44B8))),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAttendanceTab(bool isDark) {
    final records = LMSMockData.attendanceRecords;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ATTENDANCE SUMMARY', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text('87.5%', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w900, color: const Color(0xFF10B981))),
                    Text('7 / 8 sessions attended', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.check_circle_outline_rounded, size: 48, color: Color(0xFF10B981)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...records.map((r) {
          final isPresent = r.status == 'Present';

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.course, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text('Date: ${r.date} • Mode: ${r.deliveryMode}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPresent ? const Color(0xFF10B981).withAlpha(30) : const Color(0xFFEF4444).withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    r.status,
                    style: TextStyle(
                      color: isPresent ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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
}
