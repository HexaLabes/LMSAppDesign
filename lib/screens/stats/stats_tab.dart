import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/stat_chart_painter.dart';
import '../quiz/quiz_screen.dart';

class StatsTab extends StatefulWidget {
  const StatsTab({super.key});

  @override
  State<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Daily';

  final List<String> _periods = ['Daily', 'Week', 'Month', 'Quarter'];

  final Map<String, List<double>> _chartDataByPeriod = {
    'Daily': [0.15, 0.45, 0.85, 0.65],
    'Week': [0.20, 0.35, 0.70, 0.80],
    'Month': [0.10, 0.50, 0.60, 0.85],
    'Quarter': [0.25, 0.40, 0.65, 0.90],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = context.watch<AppStateProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Stats
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 4),
              child: Text(
                'Stats',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ),

            // Segmented Tab Bar: Common | Exam Simulation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      width: 1,
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelPadding: const EdgeInsets.only(right: 24),
                  indicatorColor: isDark ? AppColors.darkTextPrimary : Colors.black,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent,
                  labelColor: isDark ? AppColors.darkTextPrimary : Colors.black,
                  unselectedLabelColor: isDark ? AppColors.darkTextSecondary : const Color(0xFF6B7280),
                  labelStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
                  tabs: const [
                    Tab(text: 'Common'),
                    Tab(text: 'Exam Simulation'),
                  ],
                ),
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCommonTab(isDark, state),
                  _buildExamSimulationTab(isDark, state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommonTab(bool isDark, AppStateProvider state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Passing Probability Card
          Card(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Passing Probability',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        '${state.passingProbability.toInt()}%',
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: state.passingProbability / 100,
                        minHeight: 6,
                        backgroundColor: isDark ? AppColors.darkCardElevated : const Color(0xFFE5E7EB),
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    state.passingProbability == 0
                        ? 'Complete more quizzes to see your passing probability'
                        : 'Based on your simulated scores and historical accuracy.',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 2x2 Grid Metric Cards
          Row(
            children: [
              Expanded(
                child: StatMetricBox(
                  title: 'Daily Streak',
                  value: '${state.dailyStreak}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatMetricBox(
                  title: 'Days Before Exam',
                  value: '${state.daysBeforeExam}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatMetricBox(
                  title: 'Quizzes Passed',
                  value: '${state.quizzesPassed}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatMetricBox(
                  title: 'Total Time Spent',
                  value: state.totalTimeSpent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Progression of correct answers Card with Interactive Chart
          Card(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progression of correct answers, %',
                    style: GoogleFonts.inter(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Period Filter Buttons (Daily, Week, Month, Quarter)
                  Row(
                    children: _periods.map((p) {
                      final isSelected = _selectedPeriod == p;
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPeriod = p;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : (isDark ? AppColors.darkCardElevated : const Color(0xFFF3F4F6)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              p,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // Custom Paint Chart
                  SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: CurveChartPainter(
                        dataPoints: _chartDataByPeriod[_selectedPeriod] ?? [0.2, 0.4, 0.7, 0.8],
                        isDark: isDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Info indicator
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.accentOrange, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Complete more quizzes to see your progress over time in diagram',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Subject Analytics Section
          Text(
            'Subject Analytics',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 14),

          // Detailed Analytics Cards per Subject
          ...state.subjects.map((subject) {
            final title = subject['title'] as String;
            final progress = (subject['progress'] as double?) ?? 0.0;
            final avgTime = subject['avgTime'] ?? '00:00';
            final timeSpent = subject['totalTime'] ?? '00:00';
            final correct = subject['correct'] ?? 0;
            final incorrect = subject['incorrect'] ?? 0;

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              child: Card(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: GoogleFonts.inter(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                          ),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 5,
                          backgroundColor: isDark ? AppColors.darkCardElevated : const Color(0xFFE5E7EB),
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Metrics 2x2 inside card
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricItem(isDark, avgTime, 'Average Time Spent'),
                          ),
                          Expanded(
                            child: _buildMetricItem(isDark, timeSpent, 'Time Spent'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricItem(isDark, '$correct', 'Correct Answers'),
                          ),
                          Expanded(
                            child: _buildMetricItem(isDark, '$incorrect', 'Incorrect Answers'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMetricItem(bool isDark, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildExamSimulationTab(bool isDark, AppStateProvider state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner: No exam simulation attempts yet
          Card(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.accentOrange, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No exam simulation attempts yet',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Progression of correct answers Card
          Card(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progression of correct answers, %',
                    style: GoogleFonts.inter(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: CurveChartPainter(
                        dataPoints: [0.85, 0.25, 0.60, 0.78],
                        isDark: isDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.accentOrange, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Take more exam simulations to track your progress over time in the diagram',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Take Exam Simulation CTA Button with Buy Attempts badge
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const QuizScreen(
                      title: 'Official Simulation Attempt',
                      isSimulator: true,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Take Exam Simulation',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 10),
                  const AppBadge(type: BadgeType.buyAttempts),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
