import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppStateProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _soundsEnabled = true;
  bool _vibrationEnabled = true;
  int _selectedThemeIndex = 0; // 0 = Royal Sapphire (Universal Blue)
  DateTime _examDate = DateTime(2026, 11, 8);
  String _currentExam = 'CIT Exam';
  int _dailyStreak = 3;
  int _dailyGoalCurrent = 4;
  final int _dailyGoalTarget = 10;
  int _quizzesPassed = 12;
  String _totalTimeSpent = '04:35';
  double _passingProbability = 78.0;

  // Selected subjects and status
  final List<Map<String, dynamic>> _subjects = [
    {
      'title': 'Communication and Facilitation Skills',
      'progress': 0.65,
      'correct': 13,
      'total': 20,
      'avgTime': '01:20',
      'totalTime': '26:40',
      'incorrect': 7,
    },
    {
      'title': 'Course Implementation',
      'progress': 0.40,
      'correct': 8,
      'total': 20,
      'avgTime': '01:45',
      'totalTime': '35:00',
      'incorrect': 12,
    },
    {
      'title': 'Course Evaluation',
      'progress': 0.85,
      'correct': 17,
      'total': 20,
      'avgTime': '00:55',
      'totalTime': '18:20',
      'incorrect': 3,
    },
    {
      'title': 'Trainee Assessment',
      'progress': 0.30,
      'correct': 6,
      'total': 20,
      'avgTime': '02:10',
      'totalTime': '43:20',
      'incorrect': 14,
    },
    {
      'title': 'Course Development',
      'progress': 0.50,
      'correct': 10,
      'total': 20,
      'avgTime': '01:30',
      'totalTime': '30:00',
      'incorrect': 10,
    },
    {
      'title': 'Needs Assessment',
      'progress': 0.70,
      'correct': 14,
      'total': 20,
      'avgTime': '01:15',
      'totalTime': '25:00',
      'incorrect': 6,
    },
    {
      'title': 'Course Design',
      'progress': 0.55,
      'correct': 11,
      'total': 20,
      'avgTime': '01:25',
      'totalTime': '28:20',
      'incorrect': 9,
    },
  ];

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get soundsEnabled => _soundsEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  int get selectedThemeIndex => _selectedThemeIndex;
  InstituteThemePreset get currentPreset => AppColors.presets[_selectedThemeIndex % AppColors.presets.length];
  Color get primaryColor => currentPreset.primary;
  Color get primaryColorLight => currentPreset.primaryLight;
  Color get accentColor => currentPreset.accent;

  DateTime get examDate => _examDate;
  String get currentExam => _currentExam;
  int get dailyStreak => _dailyStreak;
  int get dailyGoalCurrent => _dailyGoalCurrent;
  int get dailyGoalTarget => _dailyGoalTarget;
  int get quizzesPassed => _quizzesPassed;
  String get totalTimeSpent => _totalTimeSpent;
  double get passingProbability => _passingProbability;
  List<Map<String, dynamic>> get subjects => _subjects;

  int get daysBeforeExam {
    final now = DateTime.now();
    final difference = _examDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }

  // Setters & Actions
  void setThemeIndex(int index) {
    if (index >= 0 && index < AppColors.presets.length) {
      _selectedThemeIndex = index;
      notifyListeners();
    }
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void toggleSounds(bool value) {
    _soundsEnabled = value;
    notifyListeners();
  }

  void toggleVibration(bool value) {
    _vibrationEnabled = value;
    notifyListeners();
  }

  void setExamDate(DateTime date) {
    _examDate = date;
    notifyListeners();
  }

  void setCurrentExam(String exam) {
    _currentExam = exam;
    notifyListeners();
  }

  void resetProgress() {
    _dailyStreak = 0;
    _dailyGoalCurrent = 0;
    _quizzesPassed = 0;
    _totalTimeSpent = '00:00';
    _passingProbability = 0.0;
    for (var subject in _subjects) {
      subject['progress'] = 0.0;
      subject['correct'] = 0;
      subject['incorrect'] = 0;
      subject['avgTime'] = '00:00';
      subject['totalTime'] = '00:00';
    }
    notifyListeners();
  }

  void recordQuizCompletion({required int correct, required int total}) {
    _dailyGoalCurrent = (_dailyGoalCurrent + total).clamp(0, _dailyGoalTarget);
    _quizzesPassed += 1;
    _passingProbability = ((_passingProbability * 0.7) + ((correct / total) * 100 * 0.3)).clamp(0.0, 100.0);
    notifyListeners();
  }
}
