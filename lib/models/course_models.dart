
class LmsCourse {
  final String id;
  final String title;
  final String category;
  final String level;
  final String thumbnailUrl;
  final double rating;
  final int ratingCount;
  final int studentsCount;
  double progress; // 0.0 to 1.0
  final String instructorName;
  final String instructorRole;
  final String instructorAvatar;
  final String instructorEmail;
  final String duration;
  final int modulesCount;
  final int lecturesCount;
  final bool isCertified;
  final bool hasScorm;
  final String description;
  final List<String> whatYouWillLearn;
  final List<String> requirements;
  final List<LmsModule> modules;
  final List<LmsResource> resources;
  final List<LmsDiscussion> discussions;
  final int courseFee;
  final bool isEnrolled;

  LmsCourse({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    required this.thumbnailUrl,
    required this.rating,
    required this.ratingCount,
    required this.studentsCount,
    required this.progress,
    required this.instructorName,
    required this.instructorRole,
    required this.instructorAvatar,
    required this.instructorEmail,
    required this.duration,
    required this.modulesCount,
    required this.lecturesCount,
    required this.isCertified,
    required this.hasScorm,
    required this.description,
    required this.whatYouWillLearn,
    required this.requirements,
    required this.modules,
    required this.resources,
    required this.discussions,
    required this.courseFee,
    this.isEnrolled = true,
  });
}

class LmsModule {
  final String id;
  final String courseId;
  final int moduleNumber;
  final String title;
  final String description;
  final String duration;
  bool isUnlocked;
  double progress;
  final List<LmsLecture> lectures;
  final LmsScormPackage? scormPackage;
  final List<LmsQuizRef> quizzes;
  final LmsAssessmentRef? assessmentTest;
  final List<LmsResource> resources;

  LmsModule({
    required this.id,
    required this.courseId,
    required this.moduleNumber,
    required this.title,
    required this.description,
    required this.duration,
    this.isUnlocked = true,
    this.progress = 0.0,
    required this.lectures,
    this.scormPackage,
    required this.quizzes,
    this.assessmentTest,
    required this.resources,
  });
}

class LmsLecture {
  final String id;
  final String moduleId;
  final int lectureNumber;
  final String title;
  final String duration;
  final String videoUrl;
  final String previewThumbnail;
  bool isCompleted;
  bool isLocked;
  final String overview;
  final String transcript;
  List<LectureNote> notes;
  final List<LmsResource> resources;

  LmsLecture({
    required this.id,
    required this.moduleId,
    required this.lectureNumber,
    required this.title,
    required this.duration,
    required this.videoUrl,
    required this.previewThumbnail,
    this.isCompleted = false,
    this.isLocked = false,
    required this.overview,
    required this.transcript,
    required this.notes,
    required this.resources,
  });
}

class LectureNote {
  final String id;
  final String timestamp;
  final String content;
  final DateTime createdAt;

  LectureNote({
    required this.id,
    required this.timestamp,
    required this.content,
    required this.createdAt,
  });
}

class LmsScormPackage {
  final String id;
  final String title;
  final String description;
  String status; // 'Not Started', 'In Progress', 'Completed'
  double score;
  int currentChapterIndex;
  final List<ScormChapter> chapters;

  LmsScormPackage({
    required this.id,
    required this.title,
    required this.description,
    this.status = 'In Progress',
    this.score = 75.0,
    this.currentChapterIndex = 0,
    required this.chapters,
  });
}

class ScormChapter {
  final String title;
  final String content;
  final List<String> keyPoints;
  final String? quizQuestion;
  final List<String>? quizOptions;
  final int? correctAnswerIndex;
  final String? explanation;

  ScormChapter({
    required this.title,
    required this.content,
    required this.keyPoints,
    this.quizQuestion,
    this.quizOptions,
    this.correctAnswerIndex,
    this.explanation,
  });
}

class LmsResource {
  final String id;
  final String title;
  final String type; // 'Presentation', 'Book', 'Study Material', 'Handout', 'PDF'
  final String fileSize;
  final int pages;
  final String description;
  final String previewText;

  LmsResource({
    required this.id,
    required this.title,
    required this.type,
    required this.fileSize,
    required this.pages,
    required this.description,
    required this.previewText,
  });
}

class LmsQuizRef {
  final String id;
  final String title;
  final int questionCount;
  final int timeLimitMinutes;
  final int passingScore;
  bool isCompleted;
  int? userScore;

  LmsQuizRef({
    required this.id,
    required this.title,
    required this.questionCount,
    required this.timeLimitMinutes,
    required this.passingScore,
    this.isCompleted = false,
    this.userScore,
  });
}

class LmsAssessmentRef {
  final String id;
  final String title;
  final int totalMarks;
  final int timeLimitMinutes;
  final String dueDate;
  final bool isUnlocked;
  bool isSubmitted;
  int? scoredMarks;

  LmsAssessmentRef({
    required this.id,
    required this.title,
    required this.totalMarks,
    required this.timeLimitMinutes,
    required this.dueDate,
    this.isUnlocked = true,
    this.isSubmitted = false,
    this.scoredMarks,
  });
}

class LmsDiscussion {
  final String id;
  final String studentName;
  final String studentAvatar;
  final String date;
  final String topic;
  final String question;
  int upvotes;
  final List<DiscussionAnswer> answers;

  LmsDiscussion({
    required this.id,
    required this.studentName,
    required this.studentAvatar,
    required this.date,
    required this.topic,
    required this.question,
    required this.upvotes,
    required this.answers,
  });
}

class DiscussionAnswer {
  final String id;
  final String authorName;
  final bool isInstructor;
  final String date;
  final String answerText;
  int upvotes;

  DiscussionAnswer({
    required this.id,
    required this.authorName,
    required this.isInstructor,
    required this.date,
    required this.answerText,
    required this.upvotes,
  });
}
