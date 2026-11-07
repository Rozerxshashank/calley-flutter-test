import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_state_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/list_provider.dart';
import 'ui/screens/language_selection_screen.dart';
import 'ui/screens/register_screen.dart';
import 'ui/screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const CalleyApp());
}

class CalleyApp extends StatelessWidget {
  const CalleyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()..init()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..initAuth()),
        ChangeNotifierProvider(create: (_) => ListProvider()),
      ],
      child: Consumer2<AppStateProvider, AuthProvider>(
        builder: (context, appState, auth, _) {
          return MaterialApp(
            title: 'Calley - Automatic Call Dialer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: Locale(appState.selectedLanguage),
            home: _getInitialScreen(appState, auth),
          );
        },
      ),
    );
  }

  Widget _getInitialScreen(AppStateProvider appState, AuthProvider auth) {
    // If user is already authenticated, go to Dashboard
    if (auth.isAuthenticated) {
      return const MainNavigationScreen();
    }

    // If language is chosen, go to Register screen
    if (appState.isLanguageSet) {
      return const RegisterScreen();
    }

    // Default: Start at Language Selection (Screen 01 in Figma)
    return const LanguageSelectionScreen();
  }
}
