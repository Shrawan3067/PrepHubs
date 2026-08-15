import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_card.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  int _selectedPlan = 1; // 0 = Monthly (₹299/mo), 1 = Annual (₹1499/yr - Save 60%)
  bool _isProcessing = false;

  void _subscribeNow() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1200)); // Simulate gateway

    if (mounted) {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.upgradeToPro();

      if (mounted) {
        setState(() => _isProcessing = false);

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.workspace_premium_rounded, color: AppColors.gold),
                SizedBox(width: 8),
                Text('Welcome to Pro!'),
              ],
            ),
            content: const Text(
              'You now have unlimited access to company mock exams, step-by-step video explanations, and priority analytics.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text('Start Practicing'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PlacementPrep Pro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFEF3C7),
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                size: 54,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Crack Your Dream Placement',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Get 10x higher selection rate with company-specific archives',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Plan Selectors
            GestureDetector(
              onTap: () => setState(() => _selectedPlan = 1),
              child: CustomCard(
                backgroundColor: _selectedPlan == 1
                    ? AppColors.gold.withValues(alpha: 0.12)
                    : (isDark ? AppColors.darkCard : AppColors.lightCard),
                border: Border.all(
                  color: _selectedPlan == 1 ? AppColors.gold : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  width: _selectedPlan == 1 ? 2 : 1,
                ),
                child: Row(
                  children: [
                    Icon(
                      _selectedPlan == 1 ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                      color: _selectedPlan == 1 ? AppColors.gold : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Annual Pass', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: AppColors.rose, borderRadius: BorderRadius.all(Radius.circular(4))),
                                child: Text('SAVE 60%', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          Text('₹1,499 / Year (Just ₹124/month)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            GestureDetector(
              onTap: () => setState(() => _selectedPlan = 0),
              child: CustomCard(
                backgroundColor: _selectedPlan == 0
                    ? AppColors.gold.withValues(alpha: 0.12)
                    : (isDark ? AppColors.darkCard : AppColors.lightCard),
                border: Border.all(
                  color: _selectedPlan == 0 ? AppColors.gold : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  width: _selectedPlan == 0 ? 2 : 1,
                ),
                child: Row(
                  children: [
                    Icon(
                      _selectedPlan == 0 ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                      color: _selectedPlan == 0 ? AppColors.gold : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Monthly Pass', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('₹299 / Month', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Feature Checklist
            const Text('Everything Included in Pro:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),

            _buildProFeature('Unlimited Company Mock Exams (TCS, Infosys, Accenture)'),
            _buildProFeature('Step-by-Step Solution Explanations & Tricks'),
            _buildProFeature('Pro Hints for Hard Coding Questions'),
            _buildProFeature('Placement Readiness Percentile Scorecard'),
            _buildProFeature('Export PDF Performance Reports'),
            _buildProFeature('Ad-Free Learning Experience'),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _subscribeNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(_selectedPlan == 1 ? 'Subscribe Annual • ₹1,499' : 'Subscribe Monthly • ₹299'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Purchases restored successfully.')),
                );
              },
              child: const Text('Restore Purchases'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
