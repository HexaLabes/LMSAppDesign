import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import 'quiz_screen.dart';

class CustomQuizDialog extends StatefulWidget {
  const CustomQuizDialog({super.key});

  @override
  State<CustomQuizDialog> createState() => _CustomQuizDialogState();
}

class _CustomQuizDialogState extends State<CustomQuizDialog> {
  int _questionCount = 10;
  int _timeLimitMinutes = 15;
  String _mode = 'Study Mode';
  final Set<String> _selectedTopics = {
    'Communication and Facilitation Skills',
    'Course Implementation',
  };

  final List<String> _allTopics = [
    'Communication and Facilitation Skills',
    'Course Implementation',
    'Course Evaluation',
    'Trainee Assessment',
    'Course Development',
    'Needs Assessment',
    'Course Design',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create Custom Quiz 🎯',
                    style: GoogleFonts.inter(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Number of questions selector
              Text(
                'Number of Questions: $_questionCount',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Slider(
                value: _questionCount.toDouble(),
                min: 5,
                max: 50,
                divisions: 9,
                activeColor: Theme.of(context).primaryColor,
                label: '$_questionCount Questions',
                onChanged: (val) {
                  setState(() => _questionCount = val.toInt());
                },
              ),
              const SizedBox(height: 12),

              // Time Limit
              Text(
                'Time Limit: $_timeLimitMinutes Minutes',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              Slider(
                value: _timeLimitMinutes.toDouble(),
                min: 5,
                max: 60,
                divisions: 11,
                activeColor: AppColors.accentOrange,
                label: '$_timeLimitMinutes min',
                onChanged: (val) {
                  setState(() => _timeLimitMinutes = val.toInt());
                },
              ),
              const SizedBox(height: 12),

              // Mode selector
              Text(
                'Quiz Mode',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['Study Mode', 'Exam Simulation'].map((m) {
                  final isSel = _mode == m;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(m),
                        selected: isSel,
                        selectedColor: Theme.of(context).primaryColor,
                        labelStyle: GoogleFonts.inter(
                          color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                        onSelected: (_) => setState(() => _mode = m),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Topics
              Text(
                'Select Subjects',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _allTopics.map((topic) {
                  final isSelected = _selectedTopics.contains(topic);
                  return FilterChip(
                    label: Text(topic),
                    selected: isSelected,
                    selectedColor: Theme.of(context).primaryColor.withAlpha(50),
                    checkmarkColor: Theme.of(context).primaryColor,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? (isDark ? Colors.white : Theme.of(context).primaryColor)
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedTopics.add(topic);
                        } else if (_selectedTopics.length > 1) {
                          _selectedTopics.remove(topic);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Start button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(
                          title: 'Custom Quiz ($_mode)',
                          isSimulator: _mode == 'Exam Simulation',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Start Custom Quiz',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
