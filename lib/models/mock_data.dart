import 'models.dart';

class MockData {
  static List<QuestionModel> sampleQuestions = [
    QuestionModel(
      id: 'q1',
      question: 'Which of the following is the primary purpose of a Training Needs Assessment (TNA)?',
      options: [
        'To establish punitive measures for underperforming staff',
        'To identify performance gaps that can be resolved through instructional training',
        'To calculate annual corporate training bonuses',
        'To purchase new LMS software licenses',
      ],
      correctIndex: 1,
      explanation: 'Training Needs Assessment (TNA) is designed systematically to uncover specific skill gaps and determine whether training is the appropriate solution.',
      category: 'Needs Assessment',
    ),
    QuestionModel(
      id: 'q2',
      question: 'In Bloom\'s Revised Taxonomy, which cognitive level corresponds to creating new patterns or structures?',
      options: [
        'Remembering',
        'Analyzing',
        'Creating',
        'Evaluating',
      ],
      correctIndex: 2,
      explanation: 'Creating represents the highest cognitive level where learners put elements together to form a coherent whole or create an original product.',
      category: 'Course Design',
    ),
    QuestionModel(
      id: 'q3',
      question: 'Which facilitation technique is most effective for encouraging quiet participants to share ideas?',
      options: [
        'Direct confrontational calling',
        'Think-Pair-Share small group discussions',
        'Assigning immediate pop quizzes',
        'Skipping their input to save time',
      ],
      correctIndex: 1,
      explanation: 'Think-Pair-Share provides low-stakes collaboration allowing introspective or shy learners to formulate thoughts before presenting to the larger group.',
      category: 'Communication and Facilitation Skills',
    ),
    QuestionModel(
      id: 'q4',
      question: 'In Kirkpatrick\'s 4-Level Training Evaluation Model, Level 3 measures:',
      options: [
        'Reaction of participants',
        'Learning acquisition',
        'Behavior & on-the-job application',
        'Return on Investment (ROI)',
      ],
      correctIndex: 2,
      explanation: 'Level 3 evaluates Behavior change, measuring how trainees apply their acquired learning directly to real job tasks.',
      category: 'Course Evaluation',
    ),
    QuestionModel(
      id: 'q5',
      question: 'Which formative assessment method allows real-time instructor adjustment during training delivery?',
      options: [
        'End-of-year certification exam',
        'Continuous polling and live comprehension checks',
        'Annual corporate performance review',
        'Course fee refund evaluation',
      ],
      correctIndex: 1,
      explanation: 'Formative assessments like live polls provide instant feedback to the trainer, enabling adaptive pacing and focused explanations.',
      category: 'Trainee Assessment',
    ),
  ];

  static List<FlashcardModel> sampleFlashcards = [
    FlashcardModel(
      id: 'f1',
      term: 'ADDIE Model',
      definition: 'A 5-stage instructional design framework: Analysis, Design, Development, Implementation, and Evaluation.',
      subject: 'Course Development',
      isSaved: true,
    ),
    FlashcardModel(
      id: 'f2',
      term: 'Formative vs Summative Assessment',
      definition: 'Formative checks occur during learning to improve instruction; Summative checks evaluate overall competency at the conclusion.',
      subject: 'Trainee Assessment',
      isSaved: false,
    ),
    FlashcardModel(
      id: 'f3',
      term: 'Andragogy',
      definition: 'The methods and principles used in adult education, emphasizing self-direction, experience-based learning, and practical application.',
      subject: 'Communication and Facilitation Skills',
      isSaved: true,
    ),
    FlashcardModel(
      id: 'f4',
      term: 'Kirkpatrick Level 2',
      definition: 'Learning: Measures whether trainees acquired the intended knowledge, skills, attitude, confidence, and commitment.',
      subject: 'Course Evaluation',
      isSaved: false,
    ),
  ];
}
