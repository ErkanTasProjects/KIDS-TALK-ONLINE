new_drag_drop_code = '''  // -------------------------------------------------------------------------
  // 2. PLAYFUL DRAG & DROP BOARD (WOODEN TRAY & TARGET SLOTS)
  // -------------------------------------------------------------------------
  Widget _buildDragDropGame() {
    final targets = widget.activity.gameData['targets'] as List<dynamic>;

    // Color palettes for playful slots
    final slotColors = [
      {'bg': const Color(0xFFE1F5FE), 'border': const Color(0xFF039BE5), 'iconBg': const Color(0xFFB3E5FC)},
      {'bg': const Color(0xFFFFF3E0), 'border': const Color(0xFFFF9800), 'iconBg': const Color(0xFFFFE0B2)},
      {'bg': const Color(0xFFFCE4EC), 'border': const Color(0xFFEC407A), 'iconBg': const Color(0xFFF8BBD0)},
      {'bg': const Color(0xFFEDE7F6), 'border': const Color(0xFF7E57C2), 'iconBg': const Color(0xFFD1C4E9)},
      {'bg': const Color(0xFFE8F5E9), 'border': const Color(0xFF43A047), 'iconBg': const Color(0xFFC8E6C9)},
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // LEFT COLUMN: TARGET SLOTS ("Place Card Here!")
        Expanded(
          flex: 6,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
            itemCount: targets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final target = targets[index];
              final isPlaced = _placedTargets.containsKey(index);
              final colors = slotColors[index % slotColors.length];

              return DragTarget<String>(
                onWillAcceptWithDetails: (details) => !isPlaced,
                onAcceptWithDetails: (details) {
                  final droppedSentence = details.data;
                  if (droppedSentence == target['sentence']) {
                    SoundService().playCorrect();
                    setState(() {
                      _placedTargets[index] = droppedSentence;
                      _characterFeedback = 'Awesome! Perfect match! 🏆';
                    });
                    SoundService().speakEnglish(droppedSentence);
                    if (_placedTargets.length == targets.length) {
                      _triggerSuccess();
                    }
                  } else {
                    SoundService().playWrong();
                    setState(() {
                      _characterFeedback = 'Not this box, try again! 🤔';
                    });
                    context.read<AppState>().useHeart();
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  final isHovered = candidateData.isNotEmpty;

                  return GestureDetector(
                    onTap: () {
                      if (_selectedSentence != null && !isPlaced) {
                        if (_selectedSentence == target['sentence']) {
                          setState(() {
                            _placedTargets[index] = _selectedSentence!;
                            _selectedSentence = null;
                            _characterFeedback = 'Awesome match! You did it! 🏆';
                          });
                          SoundService().speakEnglish(target['sentence']);
                          if (_placedTargets.length == targets.length) {
                            _triggerSuccess();
                          }
                        } else {
                          setState(() {
                            _characterFeedback = 'Try a different box! 🤔';
                          });
                          context.read<AppState>().useHeart();
                        }
                      } else if (isPlaced) {
                        SoundService().speakEnglish(_placedTargets[index]!);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: isPlaced
                            ? const Color(0xFFE8F5E9)
                            : (isHovered ? const Color(0xFFFFF9C4) : colors['bg'] as Color),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isPlaced
                              ? const Color(0xFF43A047)
                              : (isHovered ? Colors.amber.shade800 : colors['border'] as Color),
                          width: isHovered ? 3.0 : 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (colors['border'] as Color).withValues(alpha: 0.25),
                            offset: const Offset(0, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Round Icon Badge
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: colors['iconBg'] as Color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Center(
                              child: Text(target['icon'] as String? ?? '⏰', style: const TextStyle(fontSize: 24)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Target Drop Zone / Placed Text
                          Expanded(
                            child: isPlaced
                                ? Text(
                                    _placedTargets[index]!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1B5E20),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.7),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: (colors['border'] as Color).withValues(alpha: 0.45),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text('👆 ', style: TextStyle(fontSize: 13)),
                                        Flexible(
                                          child: Text(
                                            isHovered ? 'Drop Here!' : 'Place Card Here!',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: (colors['border'] as Color),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        const SizedBox(width: 8),

        // RIGHT COLUMN: PLAYFUL WOODEN TRAY FOR CARDS
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD7CCC8), Color(0xFFBCAAA4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF8D6E63), width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withValues(alpha: 0.35),
                  offset: const Offset(0, 6),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Builder(
              builder: (context) {
                final unplacedTargets = targets.where((t) => !_placedTargets.containsValue(t['sentence'])).toList();

                if (unplacedTargets.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🎉', style: TextStyle(fontSize: 48)),
                        SizedBox(height: 8),
                        Text(
                          'ALL PLACED!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: unplacedTargets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, idx) {
                    final target = unplacedTargets[idx];
                    final sentence = target['sentence'] as String;
                    final isSelected = _selectedSentence == sentence;
                    final cardColor = slotColors[idx % slotColors.length]['border'] as Color;

                    final cardWidget = Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: cardColor, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: cardColor.withValues(alpha: 0.35),
                            offset: const Offset(0, 4),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              sentence,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF263238),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              SoundService().playTap();
                              SoundService().speakEnglish(sentence);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: cardColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.volume_up_rounded, color: cardColor, size: 16),
                            ),
                          ),
                        ],
                      ),
                    );

                    return Draggable<String>(
                      data: sentence,
                      feedback: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: 170,
                          child: cardWidget,
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.25,
                        child: cardWidget,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          SoundService().playTap();
                          SoundService().speakEnglish(sentence);
                          setState(() {
                            _selectedSentence = (_selectedSentence == sentence) ? null : sentence;
                          });
                        },
                        child: cardWidget,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
'''

with open('lib/screens/lesson_screen.dart', 'r', encoding='utf-8') as f:
    lines = f.readlines()

start_idx = -1
end_idx = -1
for i, line in enumerate(lines):
    if 'Widget _buildDragDropGame()' in line:
        start_idx = i - 2
    if 'Widget _buildListenChooseGame()' in line:
        end_idx = i - 2

before = lines[:start_idx]
after = lines[end_idx:]

new_file_lines = before + [new_drag_drop_code + '\n'] + after

with open('lib/screens/lesson_screen.dart', 'w', encoding='utf-8') as f:
    f.writelines(new_file_lines)

print(f'Updated drag_drop game from line {start_idx} to {end_idx}!')
