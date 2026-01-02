import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/language_selection_screen.dart';
import '../../features/auth/presentation/screens/phone_auth_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/navigation/presentation/screens/navigation_screen.dart';
import '../../features/sos/presentation/screens/sos_screen.dart';
import '../../features/contacts/presentation/screens/contacts_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/time_management/presentation/screens/time_management_screen.dart';
import '../../features/google_features/presentation/screens/google_features_screen.dart';
import '../../features/laws/presentation/screens/laws_library_screen.dart';
import '../../features/ai_assistant/presentation/screens/ai_assistant_screen.dart';
import '../../features/learning/presentation/screens/learning_hub_screen.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String languageSelection = '/language-selection';
  static const String phoneAuth = '/phone-auth';
  static const String home = '/home';
  static const String navigation = '/navigation';
  static const String sos = '/sos';
  static const String contacts = '/contacts';
  static const String settings = '/settings';
  static const String timeManagement = '/time-management';
  static const String googleFeatures = '/google-features';
  static const String lawsLibrary = '/laws-library';
  static const String aiAssistant = '/ai-assistant';
  static const String learningHub = '/learning-hub';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case languageSelection:
        return MaterialPageRoute(builder: (_) => const LanguageSelectionScreen());

      case phoneAuth:
        return MaterialPageRoute(builder: (_) => const PhoneAuthScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case navigation:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => NavigationScreen(
            destination: args?['destination'],
          ),
        );

      case sos:
        return MaterialPageRoute(
          builder: (_) => const SOSScreen(),
          fullscreenDialog: true,
        );

      case contacts:
        return MaterialPageRoute(builder: (_) => const ContactsScreen());

      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case timeManagement:
        return MaterialPageRoute(builder: (_) => const TimeManagementScreen());

      case googleFeatures:
        return MaterialPageRoute(builder: (_) => const GoogleFeaturesScreen());

      case lawsLibrary:
        return MaterialPageRoute(builder: (_) => const LawsLibraryScreen());

      case aiAssistant:
        return MaterialPageRoute(builder: (_) => const AiAssistantScreen());

      case learningHub:
        return MaterialPageRoute(builder: (_) => const LearningHubScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
