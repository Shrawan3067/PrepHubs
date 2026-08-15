import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ExplanationView extends StatelessWidget {
  final String explanation;
  final bool isProOnly;
  final bool isUserPro;
  final VoidCallback? onUpgradeTap;

  const ExplanationView({
    super.key,
    required this.explanation,
    this.isProOnly = false,
    this.isUserPro = true,
    this.onUpgradeTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isProOnly && !isUserPro) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.lock_rounded, color: AppColors.gold),
                SizedBox(width: 8),
                Text(
                  'Detailed Pro Explanation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Unlock step-by-step solution breakdown, shortcut tricks, and complexity analysis with PlacementPrep Pro.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onUpgradeTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.white,
              ),
              child: const Text('Unlock Pro Explanations'),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDark.withValues(alpha: 0.2) : AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.primaryLight.withValues(alpha: 0.3) : AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_rounded,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Explanation & Solution',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            explanation,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
