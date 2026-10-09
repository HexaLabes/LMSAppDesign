import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/lms_data.dart';
import '../../theme/app_theme.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  late List<AssignmentItem> _assignments;

  @override
  void initState() {
    super.initState();
    _assignments = LMSMockData.assignments;
  }

  void _submitAssignment(AssignmentItem assignment) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Submit Assignment', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assignment: ${assignment.title}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Upload your completed project file (PDF, ZIP, DOCX):'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF0F44B8)),
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF0F4FF),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file_rounded, color: Color(0xFF0F44B8)),
                  SizedBox(width: 8),
                  Text('Choose File (assignment_khalid.zip)', style: TextStyle(color: Color(0xFF0F44B8), fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F44B8)),
            onPressed: () {
              setState(() {
                assignment.status = 'Submitted';
                assignment.submissionFile = 'khalid_solution_v1.zip';
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Assignment submitted successfully!'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            child: const Text('Submit Task'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          'Assignments',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
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
                  const Icon(Icons.assignment_rounded, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COURSE ASSIGNMENTS',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Submit homework, download briefs, and check marks',
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

            ..._assignments.map((asg) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Title Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F44B8),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.school_rounded, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            asg.courseTitle,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  asg.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                              ),
                              _buildStatusBadge(asg.status),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            asg.description,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Due date and Marks row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.event_outlined, size: 16, color: Color(0xFFE95D34)),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Due: ${asg.dueDate}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              if (asg.marks != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F44B8).withAlpha(isDark ? 40 : 20),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Marks: ${asg.marks}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF0F44B8),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          // Remarks if checked
                          if (asg.remarks != null) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkCardElevated : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.rate_review_rounded, size: 18, color: Color(0xFF10B981)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Trainer Feedback: ${asg.remarks}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 14),
                          // Action buttons
                          Row(
                            children: [
                              if (asg.taskFile != null) ...[
                                OutlinedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Downloading ${asg.taskFile}...')),
                                    );
                                  },
                                  icon: const Icon(Icons.file_download_rounded, size: 16),
                                  label: const Text('Brief PDF'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF10B981),
                                    side: const BorderSide(color: Color(0xFF10B981)),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              const Spacer(),
                              if (asg.status == 'Pending' || asg.status == 'Overdue')
                                ElevatedButton.icon(
                                  onPressed: () => _submitAssignment(asg),
                                  icon: const Icon(Icons.send_rounded, size: 16),
                                  label: const Text('Submit Task'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0F44B8),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                              if (asg.status == 'Submitted' || asg.status == 'Checked')
                                Text(
                                  'File: ${asg.submissionFile ?? "Uploaded"}',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    color: const Color(0xFF10B981),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    IconData? icon;

    switch (status) {
      case 'Submitted':
        bg = const Color(0xFF198754);
        icon = Icons.check_circle_rounded;
        break;
      case 'Checked':
        bg = const Color(0xFFFD7E14);
        icon = Icons.done_all_rounded;
        break;
      case 'Overdue':
        bg = const Color(0xFFDC3545);
        icon = Icons.error_outline_rounded;
        break;
      default:
        bg = const Color(0xFF6C757D);
        icon = Icons.hourglass_top_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            status,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
