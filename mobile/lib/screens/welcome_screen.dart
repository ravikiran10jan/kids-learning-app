import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _controller = TextEditingController();
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _step == 0 ? _buildIntro() : _buildNameEntry(),
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return Padding(
      key: const ValueKey('intro'),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: Text('🎓', style: TextStyle(fontSize: 60)),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'KidsLearn',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'Learn Math & English\nthe fun way!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
          ),
          const Spacer(),
          // Feature pills
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _featurePill('🔢', 'Math'),
              _featurePill('📖', 'English'),
              _featurePill('⭐', 'Earn Coins'),
              _featurePill('🏆', 'Track Progress'),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => setState(() => _step = 1),
            child: const Text('GET STARTED'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNameEntry() {
    return Padding(
      key: const ValueKey('name'),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text('👋', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 24),
          Text(
            "What's your name?",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            ),
            style: const TextStyle(fontSize: 18),
            autofocus: true,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _submit,
            child: const Text("LET'S GO!"),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _featurePill(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    context.read<AppState>().setProfileName(name);
    Navigator.pushReplacementNamed(context, '/home');
  }
}
