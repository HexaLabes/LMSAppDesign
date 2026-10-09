class StudentProfileData {
  String name;
  String fatherName;
  String gender;
  String dob;
  String contact;
  String emergencyContact;
  String email;
  String qualification;
  String cnic;
  String passport;
  String country;
  String address;

  StudentProfileData({
    this.name = 'KHALID',
    this.fatherName = 'Muhammad Ali',
    this.gender = 'Male',
    this.dob = '2001-05-14',
    this.contact = '+92 300 1234567',
    this.emergencyContact = '+92 321 7654321',
    this.email = 'khalid@hexalabes.com',
    this.qualification = 'Bachelors in Computer Science',
    this.cnic = '35201-1234567-1',
    this.passport = 'PK8923411',
    this.country = 'Pakistan',
    this.address = 'Hexa Labes Tech Park, Lahore, Pakistan',
  });
}

class FeeDetailItem {
  final String course;
  final String courseFee;
  final String finalFee;
  final String feeDay;
  final String nextDueAmount;
  final String paymentMethod;
  final String paymentMode;
  final String balance;

  FeeDetailItem({
    required this.course,
    required this.courseFee,
    required this.finalFee,
    required this.feeDay,
    required this.nextDueAmount,
    required this.paymentMethod,
    required this.paymentMode,
    required this.balance,
  });
}

class CourseTimingItem {
  final String course;
  final String startDate;
  final String duration;
  final String timeShift;
  final String shift;

  CourseTimingItem({
    required this.course,
    required this.startDate,
    required this.duration,
    required this.timeShift,
    required this.shift,
  });
}

class AttendanceRecord {
  final String rollNumber;
  final String course;
  final String date;
  final String status; // Present, Absent, Leave
  final String deliveryMode;

  AttendanceRecord({
    required this.rollNumber,
    required this.course,
    required this.date,
    required this.status,
    required this.deliveryMode,
  });
}

class ResultItem {
  final String examDate;
  final String attendance;
  final String onlinePhy;
  final String l;
  final String r;
  final String w;
  final String s;
  final String overall;

  ResultItem({
    required this.examDate,
    required this.attendance,
    required this.onlinePhy,
    required this.l,
    required this.r,
    required this.w,
    required this.s,
    required this.overall,
  });
}

class CourseResultGroup {
  final String courseTitle;
  final String rollNumber;
  final bool isIelts;
  final List<ResultItem> results;

  CourseResultGroup({
    required this.courseTitle,
    required this.rollNumber,
    required this.isIelts,
    required this.results,
  });
}

class AssignmentItem {
  final String id;
  final String courseTitle;
  final String title;
  final String description;
  final String? taskFile;
  final String dueDate;
  String status; // Submitted, Checked, Pending, Overdue
  String? submissionFile;
  String? marks;
  String? remarks;

  AssignmentItem({
    required this.id,
    required this.courseTitle,
    required this.title,
    required this.description,
    this.taskFile,
    required this.dueDate,
    required this.status,
    this.submissionFile,
    this.marks,
    this.remarks,
  });
}

class LMSMockData {
  static StudentProfileData profile = StudentProfileData();

  static List<FeeDetailItem> feeDetails = [
    FeeDetailItem(
      course: 'Advanced Problem Solving',
      courseFee: 'N/A',
      finalFee: 'N/A',
      feeDay: 'N/A',
      nextDueAmount: 'N/A',
      paymentMethod: 'N/A',
      paymentMode: 'N/A',
      balance: 'N/A',
    ),
    FeeDetailItem(
      course: 'Elementary Level 50 & 60WPM',
      courseFee: 'N/A',
      finalFee: 'N/A',
      feeDay: 'N/A',
      nextDueAmount: 'N/A',
      paymentMethod: 'N/A',
      paymentMode: 'N/A',
      balance: 'N/A',
    ),
    FeeDetailItem(
      course: 'IELTS',
      courseFee: 'N/A',
      finalFee: 'N/A',
      feeDay: 'N/A',
      nextDueAmount: 'N/A',
      paymentMethod: 'N/A',
      paymentMode: 'N/A',
      balance: 'N/A',
    ),
    FeeDetailItem(
      course: 'Secondary Level 70 & 80WPM',
      courseFee: 'N/A',
      finalFee: 'N/A',
      feeDay: 'N/A',
      nextDueAmount: 'N/A',
      paymentMethod: 'N/A',
      paymentMode: 'N/A',
      balance: 'N/A',
    ),
    FeeDetailItem(
      course: 'Web Development',
      courseFee: '45000',
      finalFee: '40000',
      feeDay: '5',
      nextDueAmount: '7000',
      paymentMethod: 'instalment',
      paymentMode: 'online',
      balance: '34000',
    ),
  ];

  static List<CourseTimingItem> courseTimings = [
    CourseTimingItem(
      course: 'Web Development',
      startDate: '2026-08-15',
      duration: '3 Months',
      timeShift: '04:00 PM - 06:00 PM',
      shift: 'Evening',
    ),
    CourseTimingItem(
      course: 'IELTS Preparation',
      startDate: '2026-09-01',
      duration: '2 Months',
      timeShift: '10:00 AM - 12:00 PM',
      shift: 'Morning',
    ),
    CourseTimingItem(
      course: 'Advanced Problem Solving',
      startDate: '2026-09-10',
      duration: '1 Month',
      timeShift: '06:00 PM - 08:00 PM',
      shift: 'Night',
    ),
    CourseTimingItem(
      course: 'Elementary Level 50 & 60WPM',
      startDate: '2026-07-20',
      duration: '2 Months',
      timeShift: '02:00 PM - 04:00 PM',
      shift: 'Afternoon',
    ),
  ];

  static List<AttendanceRecord> attendanceRecords = [
    AttendanceRecord(
      rollNumber: 'HEXA-WD-042',
      course: 'Web Development',
      date: '2026-10-08',
      status: 'Present',
      deliveryMode: 'Online',
    ),
    AttendanceRecord(
      rollNumber: 'HEXA-WD-042',
      course: 'Web Development',
      date: '2026-10-07',
      status: 'Present',
      deliveryMode: 'Online',
    ),
    AttendanceRecord(
      rollNumber: 'HEXA-WD-042',
      course: 'Web Development',
      date: '2026-10-06',
      status: 'Leave',
      deliveryMode: 'Online',
    ),
    AttendanceRecord(
      rollNumber: 'HEXA-WD-042',
      course: 'Web Development',
      date: '2026-10-05',
      status: 'Present',
      deliveryMode: 'Online',
    ),
    AttendanceRecord(
      rollNumber: 'HEXA-IELTS-19',
      course: 'IELTS',
      date: '2026-10-04',
      status: 'Present',
      deliveryMode: 'Physical',
    ),
    AttendanceRecord(
      rollNumber: 'HEXA-IELTS-19',
      course: 'IELTS',
      date: '2026-10-03',
      status: 'Absent',
      deliveryMode: 'Physical',
    ),
    AttendanceRecord(
      rollNumber: 'HEXA-IELTS-19',
      course: 'IELTS',
      date: '2026-10-02',
      status: 'Present',
      deliveryMode: 'Physical',
    ),
    AttendanceRecord(
      rollNumber: 'HEXA-WD-042',
      course: 'Web Development',
      date: '2026-10-01',
      status: 'Present',
      deliveryMode: 'Online',
    ),
  ];

  static List<CourseResultGroup> resultsSummary = [
    CourseResultGroup(
      courseTitle: 'IELTS Academic Preparation',
      rollNumber: 'HEXA-IELTS-19',
      isIelts: true,
      results: [
        ResultItem(
          examDate: '2026-09-28',
          attendance: 'Present',
          onlinePhy: 'Physical',
          l: '7.5',
          r: '7.0',
          w: '6.5',
          s: '7.5',
          overall: '7.0',
        ),
        ResultItem(
          examDate: '2026-09-14',
          attendance: 'Present',
          onlinePhy: 'Physical',
          l: '7.0',
          r: '6.5',
          w: '6.5',
          s: '7.0',
          overall: '7.0',
        ),
      ],
    ),
    CourseResultGroup(
      courseTitle: 'Web Development - React & Node.js',
      rollNumber: 'HEXA-WD-042',
      isIelts: false,
      results: [],
    ),
  ];

  static List<AssignmentItem> assignments = [
    AssignmentItem(
      id: 'asg-1',
      courseTitle: 'Web Development',
      title: 'Responsive Portfolio Website',
      description: 'Build a modern responsive portfolio website using HTML5, CSS Grid/Flexbox and JS.',
      taskFile: 'portfolio_guidelines.pdf',
      dueDate: '2026-10-15',
      status: 'Submitted',
      submissionFile: 'khalid_portfolio_v1.zip',
      marks: '92/100',
      remarks: 'Excellent responsiveness and clean CSS architecture! Great job.',
    ),
    AssignmentItem(
      id: 'asg-2',
      courseTitle: 'Web Development',
      title: 'CRUD REST API with Node & Express',
      description: 'Create API endpoints for student course registration and implement JWT authentication.',
      taskFile: 'api_specs.pdf',
      dueDate: '2026-10-22',
      status: 'Pending',
    ),
    AssignmentItem(
      id: 'asg-3',
      courseTitle: 'IELTS Preparation',
      title: 'Task 2 Essay Writing - Environmental Policies',
      description: 'Write a 250-word essay discussing government vs individual responsibility on climate change.',
      taskFile: 'essay_prompt.pdf',
      dueDate: '2026-10-10',
      status: 'Checked',
      submissionFile: 'essay_task2_khalid.pdf',
      marks: 'Band 7.5',
      remarks: 'Strong vocabulary and cohesive paragraphing. Work slightly on conclusion summary.',
    ),
    AssignmentItem(
      id: 'asg-4',
      courseTitle: 'Advanced Problem Solving',
      title: 'Binary Tree Algorithms & Complexity',
      description: 'Implement AVL tree rotations and compute time complexity comparisons.',
      dueDate: '2026-09-30',
      status: 'Overdue',
    ),
  ];

  static List<LmsCourseAssessmentGroup> assessmentGroups = [
    LmsCourseAssessmentGroup(
      courseId: 'aps-01',
      courseTitle: 'Advanced Problem Solving',
      tests: [
        LmsAssessmentModuleItem(
          id: 'aps-test-1',
          title: 'Course Assessment Test',
          isCourseLevel: true,
          status: AssessmentScheduleStatus.pendingSchedule,
          scheduledDate: 'Not Scheduled',
          scheduledTime: 'TBA',
          remarks: 'This assessment test date has not been assigned yet. Tests are only available on their assigned date.',
          questions: [
            LmsAssessmentQuestion(
              id: 101,
              questionType: AssessmentQuestionType.singleChoice,
              questionText: 'What is the worst-case time complexity of QuickSort when the pivot is always chosen as the smallest or largest element in an already sorted array?',
              options: [
                AssessmentOption(index: 1, text: 'O(1) Constant Time'),
                AssessmentOption(index: 2, text: 'O(n log n) Log-Linear Time'),
                AssessmentOption(index: 3, text: 'O(n^2) Quadratic Time'),
                AssessmentOption(index: 4, text: 'O(2^n) Exponential Time'),
              ],
              correctAnswer: '3',
              explanation: 'When the partition is unbalanced at each step, the recursion depth becomes O(n) and comparisons total n*(n-1)/2 = O(n^2).',
            ),
            LmsAssessmentQuestion(
              id: 102,
              questionType: AssessmentQuestionType.fillInTheBlanks,
              questionText: 'In dynamic programming, storing previously calculated subproblem results in a lookup table to avoid redundant computation is known as _______.',
              wordBank: ['memoization', 'tabulation', 'greedy', 'backtracking'],
              correctAnswer: 'memoization',
              explanation: 'Memoization is a top-down dynamic programming technique where solved subproblem outputs are cached.',
            ),
            LmsAssessmentQuestion(
              id: 103,
              questionType: AssessmentQuestionType.trueFalse,
              questionText: 'A Red-Black Tree is a self-balancing binary search tree where every node is either red or black and the root is always black.',
              correctAnswer: 'True',
              explanation: 'By Red-Black tree properties, the root node is always black and no two adjacent red nodes can exist.',
            ),
            LmsAssessmentQuestion(
              id: 104,
              questionType: AssessmentQuestionType.multipleChoice,
              questionText: 'Which of the following data structures guarantee O(1) amortized insertion time? (Select all that apply)',
              options: [
                AssessmentOption(index: 1, text: 'Dynamic Array (ArrayList / List) append operation'),
                AssessmentOption(index: 2, text: 'Hash Table (HashMap) without hash collisions'),
                AssessmentOption(index: 3, text: 'Unbalanced Binary Search Tree (BST) insertion'),
                AssessmentOption(index: 4, text: 'Min-Heap binary tree insertion'),
              ],
              correctAnswer: '1,2',
              explanation: 'Dynamic arrays double in capacity giving O(1) amortized append, and HashTables provide O(1) average/amortized insert.',
            ),
          ],
        ),
        LmsAssessmentModuleItem(
          id: 'aps-mod-1',
          title: 'Arrays & Dynamic Programming Test',
          isCourseLevel: false,
          status: AssessmentScheduleStatus.availableToday,
          scheduledDate: 'Today (Active)',
          scheduledTime: 'Open Access (30 mins)',
          remarks: 'Modular assessment test for core dynamic programming and array manipulation.',
          questions: [
            LmsAssessmentQuestion(
              id: 105,
              questionType: AssessmentQuestionType.singleChoice,
              questionText: 'Which algorithmic approach solves the 0/1 Knapsack Problem with optimal substructure in O(N*W) time?',
              options: [
                AssessmentOption(index: 1, text: 'Dynamic Programming (2D Table / 1D Optimized)'),
                AssessmentOption(index: 2, text: 'Greedy Algorithm by Value-to-Weight Ratio'),
                AssessmentOption(index: 3, text: 'Simple Linear Search Scan'),
                AssessmentOption(index: 4, text: 'Dijkstra Shortest Path'),
              ],
              correctAnswer: '1',
              explanation: 'The 0/1 Knapsack requires Dynamic Programming because items cannot be divided.',
            ),
            LmsAssessmentQuestion(
              id: 106,
              questionType: AssessmentQuestionType.trueFalse,
              questionText: 'Kadane algorithm computes the maximum subarray sum in O(n) single pass time complexity.',
              correctAnswer: 'True',
              explanation: 'Kadane algorithm tracks the maximum ending at each position in O(n) time and O(1) auxiliary space.',
            ),
            LmsAssessmentQuestion(
              id: 107,
              questionType: AssessmentQuestionType.fillInTheBlanks,
              questionText: 'A subsequence where all elements are strictly increasing in order is called the Longest _______ Subsequence (LIS).',
              wordBank: ['Increasing', 'Contiguous', 'Alternating', 'Decreasing'],
              correctAnswer: 'Increasing',
              explanation: 'LIS stands for Longest Increasing Subsequence, solvable in O(n log n) with patience sorting/binary search.',
            ),
          ],
        ),
      ],
    ),
    LmsCourseAssessmentGroup(
      courseId: 'elem-01',
      courseTitle: 'Elementary Level 50 & 60WPM',
      tests: [
        LmsAssessmentModuleItem(
          id: 'elem-test-1',
          title: 'Course Assessment Test',
          isCourseLevel: true,
          status: AssessmentScheduleStatus.pendingSchedule,
          scheduledDate: 'Not Scheduled',
          scheduledTime: 'TBA',
          remarks: 'This assessment test date has not been assigned yet. Tests are only available on their assigned date.',
          questions: [
            LmsAssessmentQuestion(
              id: 201,
              questionType: AssessmentQuestionType.singleChoice,
              questionText: 'Which finger is placed on the "F" key on a standard QWERTY keyboard in the home row position?',
              options: [
                AssessmentOption(index: 1, text: 'Left hand index finger'),
                AssessmentOption(index: 2, text: 'Right hand index finger'),
                AssessmentOption(index: 3, text: 'Left hand thumb'),
                AssessmentOption(index: 4, text: 'Right hand pinky finger'),
              ],
              correctAnswer: '1',
              explanation: 'F has a physical raised tactile bump for the left index finger.',
            ),
          ],
        ),
        LmsAssessmentModuleItem(
          id: 'elem-mod-1',
          title: 'Touch Typing Speed & Accuracy Assessment',
          isCourseLevel: false,
          status: AssessmentScheduleStatus.availableToday,
          scheduledDate: 'Today (Active)',
          scheduledTime: 'Open Access',
          remarks: 'Evaluate standard typing posture, home row discipline, and net accuracy.',
          questions: [
            LmsAssessmentQuestion(
              id: 202,
              questionType: AssessmentQuestionType.trueFalse,
              questionText: 'In professional touch typing, you should keep your eyes on the screen rather than looking down at the keyboard.',
              correctAnswer: 'True',
              explanation: 'Touch typing relies on muscle memory without visual keyboard guidance.',
            ),
            LmsAssessmentQuestion(
              id: 203,
              questionType: AssessmentQuestionType.fillInTheBlanks,
              questionText: 'The standard typing measurement metric WPM stands for Words Per _______.',
              wordBank: ['Minute', 'Hour', 'Second', 'Milestone'],
              correctAnswer: 'Minute',
              explanation: 'WPM stands for Words Per Minute, standardizing a word as 5 keystrokes.',
            ),
            LmsAssessmentQuestion(
              id: 204,
              questionType: AssessmentQuestionType.singleChoice,
              questionText: 'Which thumb should primarily be used to strike the Spacebar in touch typing?',
              options: [
                AssessmentOption(index: 1, text: 'The thumb of your dominant hand (or both alternatively)'),
                AssessmentOption(index: 2, text: 'Left pinky finger'),
                AssessmentOption(index: 3, text: 'Right index finger'),
                AssessmentOption(index: 4, text: 'Palm heel'),
              ],
              correctAnswer: '1',
              explanation: 'Spacebar is actuated smoothly using either the right or left thumb.',
            ),
          ],
        ),
      ],
    ),
    LmsCourseAssessmentGroup(
      courseId: 'ielts-01',
      courseTitle: 'IELTS',
      tests: [
        LmsAssessmentModuleItem(
          id: 'ielts-test-1',
          title: 'Course Assessment Test',
          isCourseLevel: true,
          status: AssessmentScheduleStatus.upcoming,
          scheduledDate: '08 Nov 2026',
          scheduledTime: '10:00 AM - 11:30 AM PST',
          remarks: 'Official mock assessment examination. Biometric check and student verification active.',
          questions: [
            LmsAssessmentQuestion(
              id: 301,
              questionType: AssessmentQuestionType.singleChoice,
              questionText: 'In IELTS Academic Reading, how many total sections and questions are included in the 60-minute test?',
              options: [
                AssessmentOption(index: 1, text: '3 passages, 40 questions total'),
                AssessmentOption(index: 2, text: '4 passages, 30 questions total'),
                AssessmentOption(index: 3, text: '2 passages, 50 questions total'),
                AssessmentOption(index: 4, text: '5 passages, 40 questions total'),
              ],
              correctAnswer: '1',
              explanation: 'IELTS Reading features 3 complex academic passages with 40 questions to answer in 60 minutes.',
            ),
          ],
        ),
        LmsAssessmentModuleItem(
          id: 'ielts-mod-writing',
          title: 'Writing',
          isCourseLevel: false,
          status: AssessmentScheduleStatus.upcoming,
          scheduledDate: '08 Nov 2026',
          scheduledTime: '11:45 AM - 01:00 PM PST',
          remarks: 'Covers Academic Task 1 report writing and Task 2 formal discursive essay.',
          questions: [
            LmsAssessmentQuestion(
              id: 302,
              questionType: AssessmentQuestionType.fillInTheBlanks,
              questionText: 'In IELTS Academic Writing Task 1, you must write an objective factual _______ of the given visual data without personal opinions.',
              wordBank: ['summary', 'argument', 'critique', 'story'],
              correctAnswer: 'summary',
              explanation: 'Task 1 requires summarizing main features and making comparisons where relevant.',
            ),
            LmsAssessmentQuestion(
              id: 303,
              questionType: AssessmentQuestionType.trueFalse,
              questionText: 'In IELTS Writing Task 2, using clear topic sentences and linking cohesive devices directly boosts your Coherence & Cohesion band score.',
              correctAnswer: 'True',
              explanation: 'Coherence and Cohesion evaluates paragraph development, flow, and logical transitions.',
            ),
            LmsAssessmentQuestion(
              id: 304,
              questionType: AssessmentQuestionType.multipleChoice,
              questionText: 'Which four official assessment criteria are used to score IELTS Writing tasks? (Select all that apply)',
              options: [
                AssessmentOption(index: 1, text: 'Task Achievement / Task Response'),
                AssessmentOption(index: 2, text: 'Coherence and Cohesion'),
                AssessmentOption(index: 3, text: 'Lexical Resource (Vocabulary)'),
                AssessmentOption(index: 4, text: 'Grammatical Range and Accuracy'),
              ],
              correctAnswer: '1,2,3,4',
              explanation: 'All four criteria are equally weighted at 25% each of your writing band score.',
            ),
          ],
        ),
        LmsAssessmentModuleItem(
          id: 'ielts-mod-reading',
          title: 'Reading & Listening Practice Assessment',
          isCourseLevel: false,
          status: AssessmentScheduleStatus.availableToday,
          scheduledDate: 'Today (Active)',
          scheduledTime: 'Open Access',
          remarks: 'Master key skills: skimming, scanning, predicting, and identifying True/False/Not Given.',
          questions: [
            LmsAssessmentQuestion(
              id: 305,
              questionType: AssessmentQuestionType.singleChoice,
              questionText: 'In IELTS Reading questions, what is the key difference between "False" and "Not Given"?',
              options: [
                AssessmentOption(index: 1, text: 'False directly contradicts the text; Not Given is neither confirmed nor contradicted'),
                AssessmentOption(index: 2, text: 'False means the author agrees; Not Given means the author disagrees'),
                AssessmentOption(index: 3, text: 'There is no difference in scoring'),
                AssessmentOption(index: 4, text: 'Not Given is only for headlines'),
              ],
              correctAnswer: '1',
              explanation: 'False implies a clear factual contradiction in the passage; Not Given means insufficient information exists.',
            ),
            LmsAssessmentQuestion(
              id: 306,
              questionType: AssessmentQuestionType.trueFalse,
              questionText: 'In IELTS Listening, exact spelling errors and wrong singular/plural forms will result in losing the mark for that question.',
              correctAnswer: 'True',
              explanation: 'IELTS Listening requires precise spelling and adherence to word limits (e.g. NO MORE THAN TWO WORDS).',
            ),
            LmsAssessmentQuestion(
              id: 307,
              questionType: AssessmentQuestionType.fillInTheBlanks,
              questionText: 'Reading the questions before the audio plays in IELTS Listening is called _______ the answers.',
              wordBank: ['predicting', 'memorizing', 'translating', 'ignoring'],
              correctAnswer: 'predicting',
              explanation: 'Predicting keywords and word forms (nouns, dates, numbers) improves listening accuracy.',
            ),
          ],
        ),
      ],
    ),
    LmsCourseAssessmentGroup(
      courseId: 'wd-01',
      courseTitle: 'Web Development',
      tests: [
        LmsAssessmentModuleItem(
          id: 'wd-test-1',
          title: 'Course Assessment Test',
          isCourseLevel: true,
          status: AssessmentScheduleStatus.availableToday,
          scheduledDate: 'Today (Active)',
          scheduledTime: 'Open Access (45 mins)',
          remarks: 'Full stack assessment covering HTML5, Modern CSS, ES6 JavaScript, REST APIs and React architecture.',
          questions: [
            LmsAssessmentQuestion(
              id: 401,
              questionType: AssessmentQuestionType.singleChoice,
              questionText: 'Which React hook is designed for executing side effects such as data fetching, subscriptions, or DOM mutations?',
              options: [
                AssessmentOption(index: 1, text: 'useState'),
                AssessmentOption(index: 2, text: 'useEffect'),
                AssessmentOption(index: 3, text: 'useMemo'),
                AssessmentOption(index: 4, text: 'useContext'),
              ],
              correctAnswer: '2',
              explanation: 'useEffect handles component lifecycle operations and side-effects after rendering.',
            ),
            LmsAssessmentQuestion(
              id: 402,
              questionType: AssessmentQuestionType.fillInTheBlanks,
              questionText: 'In JavaScript ES6+, the _______ keyword declares a block-scoped variable that can be reassigned.',
              wordBank: ['let', 'const', 'var', 'static'],
              correctAnswer: 'let',
              explanation: 'let provides block-scoping and allows variable reassignment, unlike const.',
            ),
            LmsAssessmentQuestion(
              id: 403,
              questionType: AssessmentQuestionType.trueFalse,
              questionText: 'In CSS Flexbox, setting "flex-direction: column" changes the main axis to vertical and cross axis to horizontal.',
              correctAnswer: 'True',
              explanation: 'The main axis follows the flex-direction; column makes the main axis run top to bottom.',
            ),
            LmsAssessmentQuestion(
              id: 404,
              questionType: AssessmentQuestionType.multipleChoice,
              questionText: 'Which HTTP methods are defined as idempotent in HTTP specification? (Select all that apply)',
              options: [
                AssessmentOption(index: 1, text: 'GET (Safe & Idempotent)'),
                AssessmentOption(index: 2, text: 'PUT (Idempotent update/replace)'),
                AssessmentOption(index: 3, text: 'DELETE (Idempotent resource removal)'),
                AssessmentOption(index: 4, text: 'POST (Non-idempotent creation)'),
              ],
              correctAnswer: '1,2,3',
              explanation: 'GET, PUT, and DELETE produce the same side-effects on subsequent identical calls, whereas POST creates new entries.',
            ),
            LmsAssessmentQuestion(
              id: 405,
              questionType: AssessmentQuestionType.singleChoice,
              questionText: 'Which HTTP status code indicates that a new resource has been successfully created on the server?',
              options: [
                AssessmentOption(index: 1, text: '200 OK'),
                AssessmentOption(index: 2, text: '201 Created'),
                AssessmentOption(index: 3, text: '204 No Content'),
                AssessmentOption(index: 4, text: '304 Not Modified'),
              ],
              correctAnswer: '2',
              explanation: '201 Created is the standard response status for successful POST resource creations.',
            ),
            LmsAssessmentQuestion(
              id: 406,
              questionType: AssessmentQuestionType.fillInTheBlanks,
              questionText: 'A database _______ is a specialized data structure (like B-Tree) that dramatically accelerates table search queries.',
              wordBank: ['index', 'trigger', 'procedure', 'constraint'],
              correctAnswer: 'index',
              explanation: 'Database indexes speed up lookups at the expense of extra storage and slight write overhead.',
            ),
          ],
        ),
      ],
    ),
  ];
}

enum AssessmentQuestionType {
  singleChoice,
  multipleChoice,
  fillInTheBlanks,
  trueFalse,
  shortAnswer,
}

class AssessmentOption {
  final int index;
  final String text;
  final String? imageUrl;

  AssessmentOption({
    required this.index,
    required this.text,
    this.imageUrl,
  });
}

class LmsAssessmentQuestion {
  final int id;
  final AssessmentQuestionType questionType;
  final String questionText;
  final List<AssessmentOption> options;
  final String correctAnswer;
  final List<String> wordBank;
  final int timeLimitSeconds;
  final String explanation;
  final String? imageUrl;

  LmsAssessmentQuestion({
    required this.id,
    required this.questionType,
    required this.questionText,
    this.options = const [],
    required this.correctAnswer,
    this.wordBank = const [],
    this.timeLimitSeconds = 30,
    this.explanation = '',
    this.imageUrl,
  });
}

enum AssessmentScheduleStatus {
  availableToday,
  pendingSchedule,
  upcoming,
  closed,
}

class LmsAssessmentModuleItem {
  final String id;
  final String title;
  final bool isCourseLevel;
  final AssessmentScheduleStatus status;
  final String? scheduledDate;
  final String? scheduledTime;
  final String remarks;
  final List<LmsAssessmentQuestion> questions;

  LmsAssessmentModuleItem({
    required this.id,
    required this.title,
    this.isCourseLevel = false,
    required this.status,
    this.scheduledDate,
    this.scheduledTime,
    this.remarks = '',
    required this.questions,
  });
}

class LmsCourseAssessmentGroup {
  final String courseId;
  final String courseTitle;
  final List<LmsAssessmentModuleItem> tests;

  LmsCourseAssessmentGroup({
    required this.courseId,
    required this.courseTitle,
    required this.tests,
  });
}

