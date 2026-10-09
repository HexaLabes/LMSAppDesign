import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class TrainerFeedbackScreen extends StatefulWidget {
  const TrainerFeedbackScreen({super.key});

  @override
  State<TrainerFeedbackScreen> createState() => _TrainerFeedbackScreenState();
}

class _TrainerFeedbackScreenState extends State<TrainerFeedbackScreen> {
  String _selectedCourse = 'Web Development';

  final Map<String, Map<String, dynamic>> _trainerResponses = {
    'Web Development': {
      'trainer': 'Engr. M. Farooq',
      'overallRating': '4.8 / 5.0',
      'engagement': 'Excellent (95%)',
      'punctuality': 'Always on time',
      'remarks': 'Khalid is an exceptional learner with strong analytical skills. Consistently submits assignments before deadlines. Recommended to start contributing to open-source full-stack projects.',
      'strengths': ['Fast problem solving', 'Clean code conventions', 'Active participation'],
      'improvements': ['Explore advanced database indexing & GraphQL'],
    },
    'IELTS Academic Preparation': {
      'trainer': 'Sarah Jenkins',
      'overallRating': '4.5 / 5.0',
      'engagement': 'Very Good (88%)',
      'punctuality': 'Regular',
      'remarks': 'Demonstrates high fluency in speaking and strong listening comprehension. Writing coherence is solid with high academic vocabulary.',
      'strengths': ['Fluency & Pronunciation', 'Listening Section 4 mastery'],
      'improvements': ['Refine Task 1 overview summaries'],
    },
    'Advanced Problem Solving': {
      'trainer': 'Dr. Usman Tariq',
      'overallRating': '4.2 / 5.0',
      'engagement': 'Active',
      'punctuality': 'Regular',
      'remarks': 'Good understanding of recursion and dynamic programming fundamentals. Keep practicing Graph BFS/DFS traversal.',
      'strengths': ['Binary search algorithms', 'Time complexity analysis'],
      'improvements': ['Dijkstra & Topological sorting implementation speed'],
    },
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final feedback = _trainerResponses[_selectedCourse] ?? _trainerResponses['Web Development']!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          'Trainer Feedback',
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
              // Blue Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F44B8), Color(0xFF1E5CD8)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.assignment_turned_in_rounded, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TRAINER FEEDBACK RESPONSE',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'View evaluation, remarks & guidance from your trainer',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: Colors.white.withAlpha(210),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Course Selector
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
                    Text('Select Enrolled Course', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedCourse,
                      items: _trainerResponses.keys.map((c) {
                        return DropdownMenuItem(value: c, child: Text(c));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCourse = val);
                      },
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Feedback Card
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
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0F44B8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feedback['trainer'] as String,
                                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                'Lead Course Instructor',
                                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            feedback['overallRating'] as String,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF10B981),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    Text(
                      'Trainer Evaluation & Remarks',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      feedback['remarks'] as String,
                      style: GoogleFonts.inter(fontSize: 13.5, height: 1.4, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Key Strengths',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF10B981)),
                    ),
                    const SizedBox(height: 6),
                    ...(feedback['strengths'] as List<String>).map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF10B981)),
                              const SizedBox(width: 6),
                              Text(s, style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        )),
                    const SizedBox(height: 14),

                    Text(
                      'Areas of Improvement',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFE95D34)),
                    ),
                    const SizedBox(height: 6),
                    ...(feedback['improvements'] as List<String>).map((imp) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFFE95D34)),
                              const SizedBox(width: 6),
                              Text(imp, style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
