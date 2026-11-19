new_matching_code = '''  // -------------------------------------------------------------------------
  // 1. MATCHING: TACTILE PLAYFUL CARD MATCHING (DUOLINGO / STUDYCAT STYLE)
  // -------------------------------------------------------------------------
  Widget _buildMatchingGame() {
    final pairs = widget.activity.gameData['pairs'] as List<dynamic>;
    final totalPairs = pairs.length;
    final matchedCount = _matchedPairs.length;

    // Remaining items to match (Matched items disappear so screen stays clean!)
    final remainingVisuals = _shuffledVisualPairs.where((p) => !_matchedPairs.contains(p['english'])).toList();
    final remainingWords = _shuffledEnglishPairs.where((p) => !_matchedPairs.contains(p['english'])).toList();

    return Column(
      children: [
        // 1. LUSH STEPPING-STONE TRAIL (Organic & Tactile, No Form Borders)
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE1F5FE), Color(0xFFE8F5E9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Stepping stones
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(totalPairs, (i) {
                    final isDone = i < matchedCount;
                    final isCurrent = i == matchedCount;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isCurrent ? 44 : 36,
                      height: isCurrent ? 44 : 36,
                      decoration: BoxDecoration(
                        gradient: isDone
                            ? const LinearGradient(colors: [Color(0xFFFFD54F), Color(0xFFFFB300)])
                            : (isCurrent
                                ? const LinearGradient(colors: [Color(0xFF81C784), Color(0xFF4CAF50)])
                                : const LinearGradient(colors: [Color(0xFFE0E0E0), Color(0xFFBDBDBD)])),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isDone ? Colors.amber : (isCurrent ? Colors.green : Colors.black26)).withValues(alpha: 0.35),
                            blurRadius: isCurrent ? 8 : 4,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                      child: Center(
                        child: isDone
                            ? const Text("⭐", style: TextStyle(fontSize: 18))
                            : (isCurrent
                                ? ClipOval(
                                    child: Image.asset(
                                      'assets/images/user_mascot_transparent.png',
                                      width: 32,
                                      height: 32,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Text("🦒", style: TextStyle(fontSize: 18)),
                                    ),
                                  )
                                : Text(
                                    "${i + 1}",
                                    style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 14),
                                  )),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 8),
              // Goal Golden Leaves
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: matchedCount == totalPairs ? const Color(0xFFFFD54F) : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF81C784), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: const Center(
                  child: Text("🌿", style: TextStyle(fontSize: 22)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. PLAYFUL DUAL-COLUMN CARD MATCHING (Left: Pictures, Right: Sound Cards)
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LEFT COLUMN: Chunky Picture Cards (Toy-like 3D Buttons)
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: remainingVisuals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = remainingVisuals[index];
                    final pairId = item['id'] as String;
                    final icon = item['icon'] as String? ?? '⭐';
                    final isSelected = _selectedVisualId == pairId;

                    return GestureDetector(
                      onTap: () {
                        SoundService().playTap();
                        _handleVisualTap(pairId, item['english'] as String);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFFF9C4) : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFFB300) : const Color(0xFFFFE082),
                            width: isSelected ? 3.5 : 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? const Color(0xFFFFB300).withValues(alpha: 0.45)
                                  : const Color(0xFFFFCA28).withValues(alpha: 0.35),
                              offset: Offset(0, isSelected ? 1 : 5), // 3D Push-in feel
                              blurRadius: isSelected ? 2 : 0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(icon, style: const TextStyle(fontSize: 42)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 14),

              // RIGHT COLUMN: 3D Sound & Word Cards (Duolingo Tactile Buttons)
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: remainingWords.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = remainingWords[index];
                    final eng = item['english'] as String;
                    final pairId = item['id'] as String;
                    final isSelected = _selectedEnglish == eng;

                    return GestureDetector(
                      onTap: () {
                        SoundService().speakEnglish(eng);
                        _handleEnglishTap(eng, pairId);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFEDE7F6) : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF7E57C2) : const Color(0xFFD1C4E9),
                            width: isSelected ? 3.5 : 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? const Color(0xFF7E57C2).withValues(alpha: 0.45)
                                  : const Color(0xFFB39DDB).withValues(alpha: 0.38),
                              offset: Offset(0, isSelected ? 1 : 5), // 3D Push-in tactile feel
                              blurRadius: isSelected ? 2 : 0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3E5F5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.volume_up_rounded, color: Color(0xFF673AB7), size: 18),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                eng,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF311B92),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
'''

with open('lib/screens/lesson_screen.dart', 'r', encoding='utf-8') as f:
    lines = f.readlines()

start_idx = 310 # line 311
end_idx = 731   # line 732

before = lines[:start_idx]
after = lines[end_idx:]

new_file_lines = before + [new_matching_code + '\n'] + after

with open('lib/screens/lesson_screen.dart', 'w', encoding='utf-8') as f:
    f.writelines(new_file_lines)

print('Updated lesson_screen.dart successfully with tactile matching game!')
