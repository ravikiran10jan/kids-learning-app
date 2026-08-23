import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KidsLearnApp());
}

class KidsLearnApp extends StatelessWidget {
  const KidsLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..init(),
      child: MaterialApp(
        title: 'KidsLearn',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const _Gate(),
        routes: {
          '/home': (_) => const HomeScreen(),
        },
      ),
    );
  }
}

class _Gate extends StatelessWidget {
  const _Gate();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (!state.loaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    // If no profile set, show welcome
    final prefs = state.profile.id;
    if (prefs == 'default' && state.loaded) {
      return const WelcomeScreen();
    }
    return const HomeScreen();
  }
}
