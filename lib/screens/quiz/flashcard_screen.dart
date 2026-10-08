import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/mock_data.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class FlashcardScreen extends StatefulWidget {
  final bool savedOnly;

  const FlashcardScreen({super.key, this.savedOnly = false});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  late List<FlashcardModel> _cards;
  int _currentIndex = 0;
  bool _showDefinition = false;

  @override
  void initState() {
    super.initState();
    final all = MockData.sampleFlashcards;
    _cards = widget.savedOnly ? all.where((c) => c.isSaved).toList() : all;
    if (_cards.isEmpty) _cards = all;
  }

  void _flipCard() {
    setState(() {
      _showDefinition = !_showDefinition;
    });
  }

  void _nextCard() {
    if (_currentIndex < _cards.length - 1) {
      setState(() {
        _currentIndex++;
        _showDefinition = false;
      });
    }
  }

  void _prevCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showDefinition = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = _cards[_currentIndex];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.savedOnly ? 'Saved Flashcards' : 'LMS Flashcards',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Text(
                '${_currentIndex + 1}/${_cards.length}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                'Tap card to flip between term & definition',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Flip Card
              Expanded(
                child: GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Container(
                      key: ValueKey<bool>(_showDefinition),
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCardBg : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _showDefinition
                              ? AppColors.accentOrange.withAlpha(120)
                              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 50 : 15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: (_showDefinition ? AppColors.accentOrange : Theme.of(context).primaryColor)
                                  .withAlpha(isDark ? 50 : 25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _showDefinition ? 'DEFINITION' : 'TERM • ${card.subject}',
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: _showDefinition ? AppColors.accentOrange : Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _showDefinition ? card.definition : card.term,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: _showDefinition ? 18 : 26,
                              fontWeight: FontWeight.w800,
                              height: 1.4,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.touch_app_outlined,
                                size: 16,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Tap to flip',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Navigation controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filledTonal(
                    onPressed: _currentIndex > 0 ? _prevCard : null,
                    icon: const Icon(Icons.arrow_back_rounded),
                    iconSize: 26,
                    padding: const EdgeInsets.all(16),
                  ),
                  ElevatedButton.icon(
                    onPressed: _flipCard,
                    icon: const Icon(Icons.sync_rounded),
                    label: const Text('Flip Card'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: _currentIndex < _cards.length - 1 ? _nextCard : null,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    iconSize: 26,
                    padding: const EdgeInsets.all(16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
