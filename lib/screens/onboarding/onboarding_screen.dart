import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../navigation/main_navigation_wrapper.dart';
import '../auth/auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Company-Specific Questions',
      'description':
          'Master actual questions asked in TCS, Infosys, Wipro, Accenture, Cognizant, and top tech drives.',
      'icon': 'domain',
    },
    {
      'title': 'Simulated Placement Exams',
      'description':
          'Experience real countdown timers, question palettes, section switching, and confidence scores.',
      'icon': 'timer',
    },
    {
      'title': 'Readiness Score Analytics',
      'description':
          'Track your accuracy, speed, weak topics, and predict your campus placement selection probability.',
      'icon': 'analytics',
    },
    {
      'title': 'PlacementPrep Pro',
      'description':
          'Unlock step-by-step video solutions, premium question archives, daily challenges, and priority updates.',
      'icon': 'verified',
    },
  ];

  void _finishOnboarding(BuildContext context, bool isGuest) async {
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.completeOnboarding();

    if (context.mounted) {
      if (isGuest) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar Skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.school, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'PlacementPrep',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _finishOnboarding(context, true),
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.2),
                                AppColors.accent.withValues(alpha: 0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(
                            _getSlideIcon(slide['icon']!),
                            size: 64,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide['description']!,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? AppColors.primary
                        : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentIndex < _slides.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _finishOnboarding(context, false);
                        }
                      },
                      child: Text(
                        _currentIndex == _slides.length - 1
                            ? 'Get Started'
                            : 'Continue',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _finishOnboarding(context, true),
                      child: const Text('Continue as Guest'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSlideIcon(String name) {
    switch (name) {
      case 'domain':
        return Icons.domain_rounded;
      case 'timer':
        return Icons.timer_rounded;
      case 'analytics':
        return Icons.analytics_rounded;
      case 'verified':
        return Icons.verified_user_rounded;
      default:
        return Icons.school_rounded;
    }
  }
}
