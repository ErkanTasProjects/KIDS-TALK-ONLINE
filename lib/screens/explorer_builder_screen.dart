import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';
import 'main_layout.dart';

class ExplorerBuilderScreen extends StatefulWidget {
  const ExplorerBuilderScreen({super.key});

  @override
  State<ExplorerBuilderScreen> createState() => _ExplorerBuilderScreenState();
}

class _ExplorerBuilderScreenState extends State<ExplorerBuilderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _animals = [
    {'id': 'giraffe', 'emoji': '🦒', 'name': 'Gigi'},
    {'id': 'camel', 'emoji': '🐪', 'name': 'Camel'},
    {'id': 'rabbit', 'emoji': '🐰', 'name': 'Bunny'},
    {'id': 'bear', 'emoji': '🐻', 'name': 'Bear'},
    {'id': 'panda', 'emoji': '🐼', 'name': 'Panda'},
    {'id': 'lion', 'emoji': '🦁', 'name': 'Leo'},
    {'id': 'frog', 'emoji': '🐸', 'name': 'Frog'},
    {'id': 'fox', 'emoji': '🦊', 'name': 'Foxy'},
    {'id': 'koala', 'emoji': '🐨', 'name': 'Koala'},
  ];

  final List<Color> _colors = const [
    Color(0xFFFFD54F), // Yellow
    Color(0xFFFF6B81), // Coral Pink
    Color(0xFF4FC3F7), // Sky Blue
    Color(0xFF4CD964), // Mint Green
    Color(0xFFB39DDB), // Soft Lavender
    Color(0xFFFF8A65), // Tangerine Orange
  ];

  final List<Map<String, dynamic>> _accessories = [
    {'id': 'none', 'emoji': '🚫', 'name': 'None'},
    {'id': 'top_hat', 'emoji': '🎩', 'name': 'Top Hat'},
    {'id': 'cap', 'emoji': '🧢', 'name': 'Cap'},
    {'id': 'crown', 'emoji': '👑', 'name': 'Crown'},
    {'id': 'bow', 'emoji': '🎀', 'name': 'Bow'},
  ];

  late String _selectedAnimal;
  late Color _selectedColor;
  late String _selectedAccessory;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    final appState = context.read<AppState>();
    _selectedAnimal = appState.avatarAnimal;
    _selectedColor = Color(appState.avatarColor);
    _selectedAccessory = appState.avatarAccessory;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _saveAndProceed() {
    SoundService().playVictory();
    context.read<AppState>().setExplorer(
      animal: _selectedAnimal,
      color: _selectedColor.value,
      accessory: _selectedAccessory,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainLayout()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentAnimal = _animals.firstWhere(
      (a) => a['id'] == _selectedAnimal,
      orElse: () => _animals[0],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8FD),
      body: SafeArea(
        child: Stack(
          children: [
            // Floating Decorative Clouds Background
            Positioned(top: 20, right: -20, child: _buildCloud(110, 50)),
            Positioned(top: 100, left: -30, child: _buildCloud(130, 60)),
            Positioned(top: 260, right: 10, child: _buildCloud(90, 42)),

            Column(
              children: [
                // Top App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          SoundService().playTap();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF2D3748), size: 24),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🌍', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 6),
                            const Text(
                              'Explorers',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF334E68),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 44), // Symmetry spacer
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Column(
                      children: [
                        const SizedBox(height: 4),
                        const Text(
                          'Build your explorer!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF243B53),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Centerpiece: Selected Avatar Preview in Colored Circle
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + (_pulseController.value * 0.03),
                              child: child,
                            );
                          },
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: _selectedColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _selectedColor.withValues(alpha: 0.45),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Animal Avatar
                                if (_selectedAnimal == 'giraffe')
                                  ClipOval(
                                    child: Image.asset(
                                      'assets/images/user_mascot_optimized.png',
                                      width: 96,
                                      height: 96,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) =>
                                          Text(currentAnimal['emoji'], style: const TextStyle(fontSize: 70)),
                                    ),
                                  )
                                else
                                  Text(
                                    currentAnimal['emoji'],
                                    style: const TextStyle(fontSize: 70),
                                  ),

                                // Accessory Overlay
                                if (_selectedAccessory != 'none')
                                  Positioned(
                                    top: 14,
                                    child: Text(
                                      _accessories.firstWhere((a) => a['id'] == _selectedAccessory)['emoji'],
                                      style: const TextStyle(fontSize: 34),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Row 1: Animals Selector
                        SizedBox(
                          height: 58,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _animals.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              final item = _animals[index];
                              final isSelected = item['id'] == _selectedAnimal;

                              return GestureDetector(
                                onTap: () {
                                  SoundService().playPop();
                                  SoundService().speakEnglish(item['name']);
                                  setState(() => _selectedAnimal = item['id']);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFFFF6F61) : Colors.transparent,
                                      width: isSelected ? 3.0 : 1.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isSelected
                                            ? const Color(0xFFFF6F61).withValues(alpha: 0.3)
                                            : Colors.black.withValues(alpha: 0.04),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      item['emoji'],
                                      style: TextStyle(fontSize: isSelected ? 28 : 24),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Row 2: Colors Palette
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _colors.map((color) {
                            final isSelected = color.value == _selectedColor.value;

                            return GestureDetector(
                              onTap: () {
                                SoundService().playTap();
                                setState(() => _selectedColor = color);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                margin: const EdgeInsets.symmetric(horizontal: 7),
                                width: isSelected ? 42 : 36,
                                height: isSelected ? 42 : 36,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.6),
                                    width: isSelected ? 3.5 : 2.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.4),
                                      blurRadius: isSelected ? 8 : 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 18),

                        // Row 3: Accessories Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _accessories.map((acc) {
                            final isSelected = acc['id'] == _selectedAccessory;

                            return GestureDetector(
                              onTap: () {
                                SoundService().playPop();
                                setState(() => _selectedAccessory = acc['id']);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFFFF6F61) : Colors.transparent,
                                    width: isSelected ? 3.0 : 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isSelected
                                          ? const Color(0xFFFF6F61).withValues(alpha: 0.3)
                                          : Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    acc['emoji'],
                                    style: TextStyle(fontSize: isSelected ? 24 : 20),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 28),

                        // Join Button (Big Coral-Orange Pill)
                        GestureDetector(
                          onTap: _saveAndProceed,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF7A6A), Color(0xFFFF5252)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF5252).withValues(alpha: 0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'Join the explorers!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Safety Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('✨', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(
                              'Ready to Play • 100% Kid Safe & Ad-Free',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloud(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.lightBlue.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}
