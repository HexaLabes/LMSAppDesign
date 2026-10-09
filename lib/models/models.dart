class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String avatarUrl;
  final bool isPro;
  final String selectedCategory;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl = '',
    this.isPro = true,
    this.selectedCategory = 'CIT Exam Prep',
  });
}

class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String category;

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.category,
  });
}

class QuestionReviewItem {
  final String questionText;
  final List<String> options;
  final int selectedAnswerIndex;
  final int correctAnswerIndex;
  final String explanation;

  QuestionReviewItem({
    required this.questionText,
    required this.options,
    required this.selectedAnswerIndex,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

class QuizAttemptResult {
  final String id;
  final String quizTitle;
  final int score;
  final int totalQuestions;
  final double percentage;
  final bool isPassed;
  final DateTime attemptedAt;
  final String timeTaken;
  final List<QuestionReviewItem> questions;

  QuizAttemptResult({
    required this.id,
    required this.quizTitle,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.isPassed,
    required this.attemptedAt,
    required this.timeTaken,
    required this.questions,
  });
}

class FlashcardModel {
  final String id;
  final String term;
  final String definition;
  final String subject;
  final bool isSaved;

  FlashcardModel({
    required this.id,
    required this.term,
    required this.definition,
    required this.subject,
    this.isSaved = false,
  });
}
