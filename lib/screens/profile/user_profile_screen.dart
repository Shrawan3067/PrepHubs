import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/pro_badge.dart';
import '../pro/paywall_screen.dart';
import '../referral/referral_screen.dart';
import '../submit_question/submit_question_screen.dart';
import '../settings/settings_screen.dart';
import '../auth/auth_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Header Card
            CustomCard(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'S',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (user.isPro) ...[
                        const SizedBox(width: 8),
                        const ProBadge(compact: true),
                      ],
                    ],
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  if (user.isGuest)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AuthScreen()),
                        );
                      },
                      icon: const Icon(Icons.login_rounded, size: 16),
                      label: const Text('Create Account to Sync Progress'),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Profile Goal Banner
            CustomCard(
              backgroundColor: AppColors.primary.withValues(alpha: 0.08),
              child: Row(
                children: [
                  const Icon(Icons.flag_rounded, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Target: ${user.dreamCompany}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('Target Role: ${user.targetRole}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Quick Menu Items
            _buildMenuItem(
              context,
              icon: Icons.workspace_premium_rounded,
              title: user.isPro ? 'PlacementPrep Pro Active' : 'Upgrade to Pro',
              subtitle: 'Unlock unlimited tests & detailed video solutions',
              iconColor: AppColors.gold,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaywallScreen()),
                );
              },
            ),

            _buildMenuItem(
              context,
              icon: Icons.card_giftcard_rounded,
              title: 'Refer & Earn Pro',
              subtitle: 'Invite batchmates & earn free Pro access',
              iconColor: AppColors.accent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReferralScreen()),
                );
              },
            ),

            _buildMenuItem(
              context,
              icon: Icons.add_circle_outline_rounded,
              title: 'Contribute a Question',
              subtitle: 'Submit placement questions for review',
              iconColor: AppColors.emerald,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubmitQuestionScreen()),
                );
              },
            ),

            _buildMenuItem(
              context,
              icon: Icons.tune_rounded,
              title: 'App Settings & Preferences',
              subtitle: 'Theme, offline sync & account management',
              iconColor: AppColors.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CustomCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
