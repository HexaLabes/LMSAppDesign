import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/course_models.dart';
import '../../theme/app_theme.dart';

class CourseRegisterScreen extends StatefulWidget {
  final LmsCourse course;

  const CourseRegisterScreen({
    super.key,
    required this.course,
  });

  @override
  State<CourseRegisterScreen> createState() => _CourseRegisterScreenState();
}

class _CourseRegisterScreenState extends State<CourseRegisterScreen> {
  String _selectedShift = 'Evening (04:00 PM - 06:00 PM)';
  String _deliveryMode = 'Online Live Interactive';
  String _paymentMethod = 'Online Bank Transfer / Card';

  final List<String> _shifts = [
    'Morning (10:00 AM - 12:00 PM)',
    'Afternoon (02:00 PM - 04:00 PM)',
    'Evening (04:00 PM - 06:00 PM)',
    'Night (06:00 PM - 08:00 PM)',
  ];

  final List<String> _modes = [
    'Online Live Interactive',
    'Physical On-Campus',
    'Hybrid (Online + Weekend Labs)',
  ];

  final List<String> _paymentMethods = [
    'Online Bank Transfer / Card',
    'EasyPaisa / JazzCash Direct',
    'Monthly Instalment Plan (3x)',
    'Bank Cash Voucher (Print & Pay)',
  ];

  void _submitRegistration() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCardBg : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'Enrollment Confirmed!',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your admission in ${widget.course.title} is activated.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F44B8).withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF0F44B8).withAlpha(40)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Student Roll No:', style: GoogleFonts.inter(fontSize: 11.5, color: Colors.grey[600])),
                        Text('ST-2026-042', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFF0F44B8))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Batch Shift:', style: GoogleFonts.inter(fontSize: 11.5, color: Colors.grey[600])),
                        Text(_selectedShift.split(' ')[0], style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Voucher Status:', style: GoogleFonts.inter(fontSize: 11.5, color: Colors.grey[600])),
                        Text('PAID / ACTIVE', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: const Color(0xFF10B981))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.pop(context); // return to courses
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F44B8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Go to My Courses', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
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
          'Course Registration',
          style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            // Course Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.course.thumbnailUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 70, height: 70, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.course.title,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.course.duration} • ${widget.course.modulesCount} Modules',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'PKR ${widget.course.courseFee.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F44B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Step 1: Batch Timing Selector
            Text(
              'Select Class Schedule / Shift',
              style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedShift,
                  isExpanded: true,
                  items: _shifts.map((s) {
                    return DropdownMenuItem(
                      value: s,
                      child: Text(s, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedShift = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Step 2: Delivery Mode Selector
            Text(
              'Select Delivery Mode',
              style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _deliveryMode,
                  isExpanded: true,
                  items: _modes.map((m) {
                    return DropdownMenuItem(
                      value: m,
                      child: Text(m, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _deliveryMode = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Step 3: Payment Method Selector
            Text(
              'Select Payment Plan',
              style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _paymentMethod,
                  isExpanded: true,
                  items: _paymentMethods.map((p) {
                    return DropdownMenuItem(
                      value: p,
                      child: Text(p, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _paymentMethod = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Fee Voucher Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Original Fee:', style: GoogleFonts.inter(fontSize: 12.5)),
                      Text('PKR ${widget.course.courseFee + 5000}', style: GoogleFonts.inter(fontSize: 12.5, decoration: TextDecoration.lineThrough)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('LMS Scholarship Discount:', style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF10B981))),
                      Text('- PKR 5,000', style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFF10B981))),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Payable:', style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w800)),
                      Text('PKR ${widget.course.courseFee}', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF0F44B8))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Enrollment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitRegistration,
                icon: const Icon(Icons.school_rounded, size: 20),
                label: Text('Confirm Admission & Register', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F44B8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
