import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/questions/explanation_view.dart';

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  String _selectedChoice = '';
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Pick 1 daily question from bank
    final dailyQ = appState.allQuestions.isNotEmpty
        ? appState.allQuestions.first
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Challenge'),
      ),
      body: dailyQ == null
          ? const Center(child: Text('Loading today’s challenge...'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCard(
                    backgroundColor: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEEF2FF),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt_rounded, size: 36, color: AppColors.amber),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Today’s Challenge • +50 XP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('Streak: ${appState.user.streakDays} Days active', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                dailyQ.company,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 11),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${dailyQ.topic} • ${dailyQ.difficulty}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          dailyQ.questionText,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  ...['A', 'B', 'C', 'D'].map((choice) {
                    final isSel = _selectedChoice == choice;
                    final isCorr = dailyQ.correctAnswer == choice;

                    Color border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
                    if (_submitted) {
                      if (isCorr) {
                        border = AppColors.emerald;
                      } else if (isSel) {
                        border = AppColors.rose;
                      }
                    } else if (isSel) {
                      border = AppColors.primary;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: CustomCard(
                        border: Border.all(color: border, width: isSel || (_submitted && isCorr) ? 2 : 1),
                        onTap: () {
                          if (!_submitted) setState(() => _selectedChoice = choice);
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: isSel ? AppColors.primary : Colors.grey.shade300,
                              child: Text(choice, style: TextStyle(color: isSel ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: Text(dailyQ.getOption(choice))),
                          ],
                        ),
                      ),
                    );
                  }),

                  if (_submitted) ExplanationView(explanation: dailyQ.explanation),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: !_submitted
                          ? (_selectedChoice.isNotEmpty ? () => setState(() => _submitted = true) : null)
                          : () => Navigator.pop(context),
                      child: Text(!_submitted ? 'Submit Daily Answer' : 'Claim Daily Reward (+50 XP)'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
