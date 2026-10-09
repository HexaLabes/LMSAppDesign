import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/course_models.dart';
import '../../theme/app_theme.dart';

class CourseDiscussionScreen extends StatefulWidget {
  final LmsCourse course;

  const CourseDiscussionScreen({
    super.key,
    required this.course,
  });

  @override
  State<CourseDiscussionScreen> createState() => _CourseDiscussionScreenState();
}

class _CourseDiscussionScreenState extends State<CourseDiscussionScreen> {
  final TextEditingController _questionTopicController = TextEditingController();
  final TextEditingController _questionBodyController = TextEditingController();

  @override
  void dispose() {
    _questionTopicController.dispose();
    _questionBodyController.dispose();
    super.dispose();
  }

  void _upvoteDiscussion(LmsDiscussion disc) {
    setState(() {
      disc.upvotes++;
    });
  }

  void _showAskQuestionModal(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ask Course Instructor & Peers',
                    style: GoogleFonts.inter(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _questionTopicController,
                decoration: InputDecoration(
                  labelText: 'Topic / Module Tag (e.g. Module 2: Blooms Taxonomy)',
                  labelStyle: GoogleFonts.inter(fontSize: 13),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _questionBodyController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Your Question Details...',
                  labelStyle: GoogleFonts.inter(fontSize: 13),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final topic = _questionTopicController.text.trim();
                    final body = _questionBodyController.text.trim();
                    if (topic.isNotEmpty && body.isNotEmpty) {
                      setState(() {
                        widget.course.discussions.insert(
                          0,
                          LmsDiscussion(
                            id: 'disc-${DateTime.now().millisecondsSinceEpoch}',
                            studentName: 'Khalid Ahmed',
                            studentAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&auto=format&fit=crop&q=80',
                            date: 'Just now',
                            topic: topic,
                            question: body,
                            upvotes: 1,
                            answers: [],
                          ),
                        );
                        _questionTopicController.clear();
                        _questionBodyController.clear();
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Question posted successfully! Instructor has been notified.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: Text('Post Question', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F44B8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          'Q&A Discussion Forum',
          style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAskQuestionModal(context, isDark),
        backgroundColor: const Color(0xFF0F44B8),
        icon: const Icon(Icons.question_answer_rounded, color: Colors.white),
        label: Text('Ask Question', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            // Header Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(widget.course.instructorAvatar),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Direct Instructor Office Hours',
                          style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700, color: const Color(0xFF0F44B8)),
                        ),
                        Text(
                          '${widget.course.instructorName} answers questions regularly.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            Text(
              'Questions & Answers (${widget.course.discussions.length})',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),

            if (widget.course.discussions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'No questions yet.\nBe the first to ask a question!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              )
            else
              ...widget.course.discussions.map((disc) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardBg : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(disc.studentAvatar),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                disc.studentName,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              Text(
                                disc.date,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () => _upvoteDiscussion(disc),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F44B8).withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.thumb_up_rounded, size: 14, color: Color(0xFF0F44B8)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${disc.upvotes}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0F44B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withAlpha(isDark ? 40 : 20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          disc.topic,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        disc.question,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),

                      // Answers Section
                      if (disc.answers.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        const Divider(),
                        const SizedBox(height: 10),
                        ...disc.answers.map((ans) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ans.isInstructor
                                  ? (isDark ? const Color(0xFF1E3A8A).withAlpha(40) : const Color(0xFFF0FDF4))
                                  : (isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC)),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: ans.isInstructor
                                    ? const Color(0xFF10B981).withAlpha(80)
                                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      ans.authorName,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: ans.isInstructor ? const Color(0xFF10B981) : (isDark ? Colors.white : Colors.black87),
                                      ),
                                    ),
                                    if (ans.isInstructor) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981).withAlpha(40),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'INSTRUCTOR',
                                          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: const Color(0xFF10B981)),
                                        ),
                                      ),
                                    ],
                                    const Spacer(),
                                    Text(
                                      ans.date,
                                      style: GoogleFonts.inter(
                                        fontSize: 10.5,
                                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  ans.answerText,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    height: 1.4,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
