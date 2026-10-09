import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/course_models.dart';

class PdfViewerScreen extends StatefulWidget {
  final LmsResource resource;
  final String courseTitle;

  const PdfViewerScreen({
    super.key,
    required this.resource,
    required this.courseTitle,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  int _currentPage = 1;
  double _zoomLevel = 1.0;
  bool _isDarkReader = false;

  void _nextPage() {
    if (_currentPage < widget.resource.pages) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _prevPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
    }
  }

  void _downloadResource() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.download_done_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('Downloaded "${widget.resource.title}" (${widget.resource.fileSize})'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDarkReader || Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.resource.title,
              style: GoogleFonts.inter(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${widget.courseTitle} • ${widget.resource.type}',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkReader ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            tooltip: 'Toggle Reader Theme',
            onPressed: () {
              setState(() {
                _isDarkReader = !_isDarkReader;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.download_rounded, color: isDark ? Colors.white70 : Colors.black87),
            tooltip: 'Download File',
            onPressed: _downloadResource,
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. PDF DOCUMENT READING VIEWPORT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Transform.scale(
                  scale: _zoomLevel,
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 600),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(isDark ? 100 : 25),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F44B8).withAlpha(isDark ? 50 : 20),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.resource.type.toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0F44B8),
                                ),
                              ),
                            ),
                            Text(
                              'Page $_currentPage of ${widget.resource.pages}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Text(
                          '${widget.resource.title} — Part $_currentPage',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),

                        Text(
                          widget.resource.previewText,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            height: 1.7,
                            color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline_rounded, size: 20, color: Color(0xFF0F44B8)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'This document is officially licensed for ${widget.courseTitle}. Handouts are synced with current examination blueprints.',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.5,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. BOTTOM TOOLBAR FOR ZOOM & PAGE NAVIGATION
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              border: Border(
                top: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Zoom Controls
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.zoom_out_rounded, size: 20),
                      onPressed: _zoomLevel > 0.8
                          ? () {
                              setState(() {
                                _zoomLevel = (_zoomLevel - 0.1).clamp(0.8, 1.4);
                              });
                            }
                          : null,
                    ),
                    Text(
                      '${(_zoomLevel * 100).toInt()}%',
                      style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      icon: const Icon(Icons.zoom_in_rounded, size: 20),
                      onPressed: _zoomLevel < 1.4
                          ? () {
                              setState(() {
                                _zoomLevel = (_zoomLevel + 0.1).clamp(0.8, 1.4);
                              });
                            }
                          : null,
                    ),
                  ],
                ),

                // Page Navigation
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      onPressed: _currentPage > 1 ? _prevPage : null,
                    ),
                    Text(
                      '$_currentPage / ${widget.resource.pages}',
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: _currentPage < widget.resource.pages ? _nextPage : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
