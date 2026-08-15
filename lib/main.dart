import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/navigation/main_navigation_wrapper.dart';
import 'widgets/common/skeleton_loader.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const PlacementPrepApp(),
    ),
  );
}

class PlacementPrepApp extends StatelessWidget {
  const PlacementPrepApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'PlacementPrep',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const RootScreenController(),
    );
  }
}

class RootScreenController extends StatelessWidget {
  const RootScreenController({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    if (appState.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SkeletonLoader(width: 80, height: 80, borderRadius: 40),
              SizedBox(height: 20),
              SkeletonLoader(width: 180, height: 20),
            ],
          ),
        ),
      );
    }

    if (!appState.isOnboardingComplete) {
      return const OnboardingScreen();
    }

    return const MainNavigationWrapper();
  }
}