import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_card.dart';
import '../admin/admin_dashboard_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Preferences'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Appearance & Theme', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),

          CustomCard(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Sleek dark theme for night study sessions'),
              value: themeProvider.isDarkMode,
              activeThumbColor: AppColors.primary,
              onChanged: (val) {
                themeProvider.toggleTheme(val);
              },
            ),
          ),

          const SizedBox(height: 20),
          const Text('Developer & Admin Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),

          CustomCard(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Admin Mode', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Enable submission review & app metrics portal'),
                  value: appState.user.isAdmin,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) {
                    appState.toggleAdminMode(val);
                  },
                ),
                if (appState.user.isAdmin) ...[
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary),
                    title: const Text('Open Admin Console', style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text('Data & Cache', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),

          CustomCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.sync_rounded, color: AppColors.secondary),
                  title: const Text('Offline Sync Status'),
                  subtitle: const Text('All 20+ question archives cached locally'),
                  trailing: const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 20),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.delete_outline_rounded, color: AppColors.rose),
                  title: const Text('Reset Exam Progress', style: TextStyle(color: AppColors.rose, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Clear test history and reset daily streak'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Reset All Progress?'),
                        content: const Text('This will clear your test history and reset your streak. Bookmarks will be kept.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                          ElevatedButton(
                            onPressed: () {
                              appState.resetProgress();
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Progress reset successfully')),
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.rose),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text('About & Legal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),

          CustomCard(
            child: Column(
              children: [
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('PlacementPrep Version'),
                  trailing: Text('v1.0.0 (Build 2026)', style: TextStyle(color: Colors.grey)),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Terms of Service & Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
