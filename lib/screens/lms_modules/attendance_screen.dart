import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/lms_data.dart';
import '../../theme/app_theme.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final records = LMSMockData.attendanceRecords;

    final presentCount = records.where((r) => r.status == 'Present').length;
    final absentCount = records.where((r) => r.status == 'Absent').length;
    final leaveCount = records.where((r) => r.status == 'Leave').length;
    final percentage = ((presentCount / records.length) * 100).toInt();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          'Attendence',
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
            // Attendance Summary Box
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ATTENDANCE SUMMARY',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$percentage%',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$presentCount / ${records.length} sessions attended',
                    style: GoogleFonts.inter(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _buildMiniBadge('Present: $presentCount', const Color(0xFF10B981)),
                      const SizedBox(width: 8),
                      _buildMiniBadge('Absent: $absentCount', const Color(0xFFEF4444)),
                      const SizedBox(width: 8),
                      _buildMiniBadge('Leave: $leaveCount', const Color(0xFFF59E0B)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Class Attendance History',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            ...records.map((r) {
              Color statusColor;
              if (r.status == 'Present') {
                statusColor = const Color(0xFF10B981);
              } else if (r.status == 'Absent') {
                statusColor = const Color(0xFFEF4444);
              } else {
                statusColor = const Color(0xFFF59E0B);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        r.status == 'Present' ? Icons.check_circle_rounded : (r.status == 'Absent' ? Icons.cancel_rounded : Icons.pause_circle_rounded),
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.course,
                            style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Roll: ${r.rollNumber} • Mode: ${r.deliveryMode}',
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            r.status,
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r.date,
                          style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                        ),
                      ],
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

  Widget _buildMiniBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(color: color, fontSize: 11.5, fontWeight: FontWeight.bold),
      ),
    );
  }
}
