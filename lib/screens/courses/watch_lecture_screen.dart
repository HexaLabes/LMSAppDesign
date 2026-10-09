import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/course_models.dart';
import '../../theme/app_theme.dart';

class WatchLectureScreen extends StatefulWidget {
  final LmsCourse course;
  final LmsModule module;
  final LmsLecture initialLecture;

  const WatchLectureScreen({
    super.key,
    required this.course,
    required this.module,
    required this.initialLecture,
  });

  @override
  State<WatchLectureScreen> createState() => _WatchLectureScreenState();
}

class _WatchLectureScreenState extends State<WatchLectureScreen> with SingleTickerProviderStateMixin {
  late LmsLecture _currentLecture;
  late int _currentIndex;
  late TabController _tabController;

  bool _isPlaying = false;
  double _playbackPosition = 0.35; // 35% through
  double _playbackSpeed = 1.0;
  final List<double> _speeds = [0.75, 1.0, 1.25, 1.5, 2.0];
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentLecture = widget.initialLecture;
    _currentIndex = widget.module.lectures.indexWhere((l) => l.id == _currentLecture.id);
    if (_currentIndex == -1) _currentIndex = 0;
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _switchLecture(int index) {
    if (index >= 0 && index < widget.module.lectures.length) {
      setState(() {
        _currentIndex = index;
        _currentLecture = widget.module.lectures[index];
        _playbackPosition = 0.0;
        _isPlaying = true;
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    final mins = (_playbackPosition * 25).toInt();
    final secs = ((_playbackPosition * 25 * 60) % 60).toInt();
    final timeStr = '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

    setState(() {
      _currentLecture.notes.insert(
        0,
        LectureNote(
          id: 'note-${DateTime.now().millisecondsSinceEpoch}',
          timestamp: timeStr,
          content: text,
          createdAt: DateTime.now(),
        ),
      );
      _noteController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note saved at current timestamp!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _markAsCompleted() {
    setState(() {
      _currentLecture.isCompleted = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Lecture marked as completed!'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
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
          _currentLecture.title,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _currentLecture.isCompleted ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
              color: _currentLecture.isCompleted ? const Color(0xFF10B981) : (isDark ? Colors.white70 : Colors.black87),
            ),
            tooltip: 'Mark Completed',
            onPressed: _markAsCompleted,
          ),
          IconButton(
            icon: const Icon(Icons.playlist_play_rounded),
            tooltip: 'Playlist',
            onPressed: () => _showPlaylistDrawer(context, isDark),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. VIDEO PLAYER VIEWPORT
          _buildVideoPlayerViewport(isDark),

          // 2. VIDEO CONTROLS & TIMELINE
          _buildPlayerControls(isDark),

          // 3. TAB NAVIGATION
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: const Color(0xFF0F44B8),
            unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            indicatorColor: const Color(0xFF0F44B8),
            labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13),
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'My Notes'),
              Tab(text: 'Transcript'),
              Tab(text: 'Playlist'),
            ],
          ),

          // 4. TAB CONTENTS
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(isDark),
                _buildNotesTab(isDark),
                _buildTranscriptTab(isDark),
                _buildPlaylistTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayerViewport(bool isDark) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video Poster / Simulation
            Image.network(
              _currentLecture.previewThumbnail,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF1E293B),
                child: const Center(
                  child: Icon(Icons.video_library_rounded, size: 48, color: Colors.white54),
                ),
              ),
            ),

            // Semi-dark gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(90),
                    Colors.transparent,
                    Colors.black.withAlpha(160),
                  ],
                ),
              ),
            ),

            // Center Play/Pause Button
            GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F44B8).withAlpha(220),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(100),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ),

            // Top overlay tags
            Positioned(
              top: 12,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(180),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Module ${widget.module.moduleNumber} • Lec ${_currentLecture.lectureNumber}',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Quality & Speed badge top right
            Positioned(
              top: 12,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(180),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '1080p HD • ${_playbackSpeed}x',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerControls(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      color: isDark ? AppColors.darkCardBg : Colors.white,
      child: Column(
        children: [
          // Slider Timeline
          Row(
            children: [
              Text(
                '08:45',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                    activeTrackColor: const Color(0xFF0F44B8),
                    inactiveTrackColor: isDark ? Colors.grey[800] : Colors.grey[300],
                    thumbColor: const Color(0xFF0F44B8),
                  ),
                  child: Slider(
                    value: _playbackPosition,
                    onChanged: (val) {
                      setState(() {
                        _playbackPosition = val;
                      });
                    },
                  ),
                ),
              ),
              Text(
                _currentLecture.duration,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),

          // Playback Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous
              IconButton(
                icon: const Icon(Icons.skip_previous_rounded),
                tooltip: 'Previous Lecture',
                onPressed: _currentIndex > 0 ? () => _switchLecture(_currentIndex - 1) : null,
              ),

              // Replay 10s
              IconButton(
                icon: const Icon(Icons.replay_10_rounded),
                tooltip: 'Rewind 10s',
                onPressed: () {
                  setState(() {
                    _playbackPosition = (_playbackPosition - 0.05).clamp(0.0, 1.0);
                  });
                },
              ),

              // Play / Pause
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded),
                iconSize: 34,
                color: const Color(0xFF0F44B8),
                onPressed: _togglePlayPause,
              ),

              // Forward 10s
              IconButton(
                icon: const Icon(Icons.forward_10_rounded),
                tooltip: 'Forward 10s',
                onPressed: () {
                  setState(() {
                    _playbackPosition = (_playbackPosition + 0.05).clamp(0.0, 1.0);
                  });
                },
              ),

              // Next Lecture
              IconButton(
                icon: const Icon(Icons.skip_next_rounded),
                tooltip: 'Next Lecture',
                onPressed: _currentIndex < widget.module.lectures.length - 1 ? () => _switchLecture(_currentIndex + 1) : null,
              ),

              // Speed Selector
              PopupMenuButton<double>(
                tooltip: 'Speed',
                initialValue: _playbackSpeed,
                onSelected: (spd) {
                  setState(() {
                    _playbackSpeed = spd;
                  });
                },
                itemBuilder: (context) => _speeds.map((s) {
                  return PopupMenuItem<double>(
                    value: s,
                    child: Text('${s}x', style: GoogleFonts.inter(fontWeight: s == _playbackSpeed ? FontWeight.w800 : FontWeight.w500)),
                  );
                }).toList(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCardElevated : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_playbackSpeed}x',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF0F44B8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          _currentLecture.title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withAlpha(30),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Module ${widget.module.moduleNumber}: ${widget.module.title}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF10B981),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Duration: ${_currentLecture.duration}',
              style: GoogleFonts.inter(
                fontSize: 11.5,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Lecture Overview',
          style: GoogleFonts.inter(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _currentLecture.overview,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            height: 1.5,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.course.instructorAvatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course.instructorName,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      widget.course.instructorRole,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        // Add Note Input Box
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Take Note at Current Timestamp (08:45)',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F44B8),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Type key points or exam formula here...',
                  hintStyle: GoogleFonts.inter(fontSize: 12.5),
                  border: InputBorder.none,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _addNote,
                  icon: const Icon(Icons.bookmark_add_rounded, size: 16),
                  label: const Text('Save Note'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F44B8),
                    foregroundColor: Colors.white,
                    textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        Text(
          'Saved Notes (${_currentLecture.notes.length})',
          style: GoogleFonts.inter(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 10),

        if (_currentLecture.notes.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No notes added for this lecture yet.\nAdd your first note above!',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),
          )
        else
          ..._currentLecture.notes.map((note) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F44B8).withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      note.timestamp,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F44B8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      note.content,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildTranscriptTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Text(
          'Lecture Transcript & Captions',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Text(
            _currentLecture.transcript,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              height: 1.6,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaylistTab(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: widget.module.lectures.length,
      itemBuilder: (context, index) {
        final lec = widget.module.lectures[index];
        final isSelected = index == _currentIndex;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF1E3A8A).withAlpha(80) : const Color(0xFFEFF6FF))
                : (isDark ? AppColors.darkCardBg : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF0F44B8) : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          child: ListTile(
            onTap: () => _switchLecture(index),
            leading: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    lec.previewThumbnail,
                    width: 50,
                    height: 38,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(width: 50, height: 38, color: Colors.grey),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 22)
                else if (lec.isCompleted)
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
              ],
            ),
            title: Text(
              '${lec.lectureNumber}. ${lec.title}',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF0F44B8)
                    : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              lec.duration,
              style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
            ),
            trailing: isSelected
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F44B8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'PLAYING',
                      style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }

  void _showPlaylistDrawer(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Module Playlist (${widget.module.lectures.length} Lectures)',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _buildPlaylistTab(isDark),
              ),
            ],
          ),
        );
      },
    );
  }
}
