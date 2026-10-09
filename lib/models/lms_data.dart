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
}
