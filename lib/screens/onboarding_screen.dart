import 'package:flutter/material.dart';
import '../widgets/bouncy_button.dart';
import '../widgets/piko_chat.dart';
import 'main_layout.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  final int _totalSteps = 3;

  String _userName = "";
  String? _selectedSource;
  String? _selectedLevel;
  
  // "Diger" secildiginde kullanicinin yazacagi metni tutar
  final TextEditingController _otherSourceController = TextEditingController();

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainLayout()),
      );
    }
  }

  // Senin tasarimindaki o seffaf, 3D, cam (glassy) metin kutusu stili
  Widget _buildGlassyTextField({
    required String hint, 
    Function(String)? onChanged, 
    TextEditingController? controller
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Hafif gri/beyaz cam efekti
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // Dis Golgeler
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 4,
            spreadRadius: -2,
            offset: Offset(0, -2), // İç parlaması
          )
        ],
        border: Border.all(color: Colors.white, width: 2), // Beyaz çerçeve
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 18),
          border: InputBorder.none, // Kendi dış borderımızı yaptık, içtekini kapattık
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = (_currentStep + 1) / (_totalSteps + 1);

    return Scaffold(
      backgroundColor: Colors.white, // Resmin beyaz kutusunu gizlemek için tam beyaz yapıldı
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.grey),
                onPressed: () => setState(() => _currentStep--),
              )
            : null,
        title: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.lightBlue),
            minHeight: 12,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: _buildStepContent(),
                ),
              ),
              const SizedBox(height: 16),
              BouncyButton(
                text: "DEVAM ET",
                color: Colors.lightBlue,
                shadowColor: Colors.blue.shade700,
                isActive: _isCurrentStepValid(),
                onPressed: _nextStep,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Column(
          children: [
            const GigiChat(text: "Hello! I am Gigi the Giraffe 🦒! I will guide you on your English adventure. What is your name?"),
            const SizedBox(height: 40),
            _buildGlassyTextField(
              hint: "Type your name here...",
              onChanged: (value) => setState(() => _userName = value),
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            GigiChat(text: "Welcome, $_userName! So happy to meet you! Let's answer a few quick questions to get started."),
          ],
        );
      case 2:
        return Column(
          children: [
            const GigiChat(text: "How did you hear about Kids Talk Online?"),
            const SizedBox(height: 30),
            _buildOptionList(
              options: ["TikTok", "Instagram / Facebook", "Google Search", "Other"],
              selectedValue: _selectedSource,
              onSelected: (value) {
                setState(() {
                  _selectedSource = value;
                  if (value != "Other") _otherSourceController.clear();
                });
              },
            ),
            // EGER DIGER SECILDIYSE YAZI ALANI CIKSIN
            if (_selectedSource == "Other") ...[
              const SizedBox(height: 20),
              _buildGlassyTextField(
                hint: "Please tell us where you heard about us...",
                controller: _otherSourceController,
                onChanged: (val) => setState(() {}),
              ),
            ]
          ],
        );
      case 3:
        return Column(
          children: [
            const GigiChat(text: "What would you like to explore? Choose what fits you best:"),
            const SizedBox(height: 30),
            _buildOptionList(
              options: [
                "Start English from the beginning ⭐",
                "Practice and improve my English 🚀"
              ],
              selectedValue: _selectedLevel,
              onSelected: (value) => setState(() => _selectedLevel = value),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  bool _isCurrentStepValid() {
    if (_currentStep == 0) return _userName.trim().isNotEmpty;
    if (_currentStep == 1) return true;
    if (_currentStep == 2) {
      if (_selectedSource == null) return false;
      if (_selectedSource == "Other" && _otherSourceController.text.trim().isEmpty) return false;
      return true;
    }
    if (_currentStep == 3) return _selectedLevel != null;
    return false;
  }

  // Secenek kutulari (Seffaf/Glassy tasarim)
  Widget _buildOptionList({
    required List<String> options,
    required String? selectedValue,
    required Function(String) onSelected,
  }) {
    return Column(
      children: options.map((option) {
        final isSelected = selectedValue == option;
        return GestureDetector(
          onTap: () => onSelected(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isSelected ? Colors.lightBlue.withOpacity(0.15) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: isSelected ? Colors.lightBlue : Colors.grey.shade200,
                width: isSelected ? 3 : 2,
              ),
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.lightBlue.shade700 : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
