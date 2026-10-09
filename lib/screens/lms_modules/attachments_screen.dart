import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class AttachmentsScreen extends StatefulWidget {
  const AttachmentsScreen({super.key});

  @override
  State<AttachmentsScreen> createState() => _AttachmentsScreenState();
}

class _AttachmentsScreenState extends State<AttachmentsScreen> {
  final List<Map<String, dynamic>> _documents = [
    {
      'title': 'CNIC Front',
      'isUploaded': true,
      'fileName': 'cnic_front_khalid.jpg',
      'updatedDate': '2026-09-12',
    },
    {
      'title': 'CNIC Rear',
      'isUploaded': true,
      'fileName': 'cnic_rear_khalid.jpg',
      'updatedDate': '2026-09-12',
    },
    {
      'title': 'Passport',
      'isUploaded': true,
      'fileName': 'passport_scan.pdf',
      'updatedDate': '2026-08-20',
    },
    {
      'title': 'Last Degree',
      'isUploaded': true,
      'fileName': 'bscs_degree_transcript.pdf',
      'updatedDate': '2026-08-15',
    },
    {
      'title': 'Other Document (PDF)',
      'isUploaded': false,
      'fileName': null,
      'updatedDate': null,
    },
  ];

  void _showUploadDialog(int index) {
    final doc = _documents[index];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Upload ${doc['title']}', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose image or PDF document to upload:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF0F44B8), style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF0F4FF),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_rounded, color: Color(0xFF0F44B8)),
                  SizedBox(width: 8),
                  Text('Select File from Device', style: TextStyle(color: Color(0xFF0F44B8), fontWeight: FontWeight.bold)),
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
                _documents[index]['isUploaded'] = true;
                _documents[index]['fileName'] = '${doc['title'].toString().toLowerCase().replaceAll(' ', '_')}_new.pdf';
                _documents[index]['updatedDate'] = '2026-10-09';
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${doc['title']} uploaded successfully!')),
              );
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  void _viewAttachment(Map<String, dynamic> doc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(doc['title'], style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.picture_as_pdf_rounded, size: 56, color: Color(0xFFE11D48)),
                  const SizedBox(height: 8),
                  Text(
                    doc['fileName'] ?? 'Document Preview',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    'Updated: ${doc['updatedDate'] ?? '-'}',
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
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
          "Student's Attachments",
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header description
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
                    const Icon(Icons.attach_file_rounded, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "STUDENT'S ATTACHMENTS",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Upload and view your verification documents',
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

              // Document list
              ...List.generate(_documents.length, (idx) {
                final doc = _documents[idx];
                final isUploaded = doc['isUploaded'] as bool;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardBg : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: (isUploaded ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isUploaded ? Icons.description_rounded : Icons.file_upload_outlined,
                          color: isUploaded ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc['title'],
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isUploaded ? (doc['fileName'] ?? 'Uploaded') : 'Not Uploaded',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: isUploaded ? const Color(0xFF15803D) : const Color(0xFFB45309),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isUploaded) ...[
                        OutlinedButton(
                          onPressed: () => _viewAttachment(doc),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF0F44B8)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'View',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF0F44B8),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      ElevatedButton(
                        onPressed: () => _showUploadDialog(idx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F44B8),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          isUploaded ? 'Replace' : 'Upload',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
