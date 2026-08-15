import 'package:flutter/material.dart';
import '../../models/test_result.dart';
import '../../models/question.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/questions/explanation_view.dart';
import '../navigation/main_navigation_wrapper.dart';

class TestResultScreen extends StatelessWidget {
  final TestResult result;
  final List<Question> questions;

  const TestResultScreen({
    super.key,
    required this.result,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    final isPassed = result.scorePercentage >= 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Scorecard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score Banner Card
            CustomCard(
              backgroundColor: isPassed
                  ? AppColors.emerald.withValues(alpha: 0.1)
                  : AppColors.rose.withValues(alpha: 0.1),
              border: Border.all(
                color: isPassed ? AppColors.emerald : AppColors.rose,
              ),
              child: Column(
                children: [
                  Icon(
                    isPassed ? Icons.emoji_events_rounded : Icons.warning_amber_rounded,
                    size: 48,
                    color: isPassed ? AppColors.emerald : AppColors.rose,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isPassed ? 'Placement Qualified 🎉' : 'Needs Practice',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isPassed ? AppColors.emerald : AppColors.rose,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${result.scorePercentage.toStringAsFixed(1)}% Score (${result.correctCount}/${result.totalQuestions} Correct)',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Accuracy', '${result.accuracyPercentage.toStringAsFixed(0)}%', AppColors.primary),
                      _buildStatItem('Time Taken', '${(result.totalTimeSeconds / 60).toStringAsFixed(1)} m', AppColors.accent),
                      _buildStatItem('Speed', '${result.avgSecondsPerQuestion}s/Q', AppColors.secondary),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Performance Breakdown Grid
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    child: Column(
                      children: [
                        const Text('Correct', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          '${result.correctCount}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.emerald),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomCard(
                    child: Column(
                      children: [
                        const Text('Incorrect', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          '${result.incorrectCount}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.rose),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomCard(
                    child: Column(
                      children: [
                        const Text('Skipped', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          '${result.skippedCount}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.amber),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const MainNavigationWrapper()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.home_rounded),
                    label: const Text('Back to Home'),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Score card exported as PDF')),
                    );
                  },
                  icon: const Icon(Icons.share_rounded),
                  label: const Text('Share Score'),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Detailed Solution Review
            const Text(
              'Detailed Solution Review',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...List.generate(questions.length, (index) {
              final q = questions[index];
              final ans = result.answers.firstWhere(
                (a) => a.questionId == q.id,
                orElse: () => QuestionAnswer(
                  questionId: q.id,
                  selectedOption: '',
                  correctAnswer: q.correctAnswer,
                  isCorrect: false,
                  timeSpentSeconds: 0,
                ),
              );

              final isCorrect = ans.isCorrect;
              final isSkipped = ans.selectedOption.isEmpty;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                child: CustomCard(
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(
                      'Q${index + 1}: ${q.questionText}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isSkipped
                                  ? AppColors.amber.withValues(alpha: 0.2)
                                  : (isCorrect ? AppColors.emerald.withValues(alpha: 0.2) : AppColors.rose.withValues(alpha: 0.2)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isSkipped ? 'Skipped' : (isCorrect ? 'Correct' : 'Incorrect'),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isSkipped
                                    ? AppColors.amber
                                    : (isCorrect ? AppColors.emerald : AppColors.rose),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('Your: ${ans.selectedOption.isEmpty ? "None" : ans.selectedOption} | Ans: ${q.correctAnswer}',
                              style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Option A: ${q.optionA}', style: _optStyle(q.correctAnswer == 'A', ans.selectedOption == 'A')),
                            Text('Option B: ${q.optionB}', style: _optStyle(q.correctAnswer == 'B', ans.selectedOption == 'B')),
                            Text('Option C: ${q.optionC}', style: _optStyle(q.correctAnswer == 'C', ans.selectedOption == 'C')),
                            Text('Option D: ${q.optionD}', style: _optStyle(q.correctAnswer == 'D', ans.selectedOption == 'D')),
                            ExplanationView(explanation: q.explanation),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  TextStyle _optStyle(bool isCorrect, bool isSelected) {
    if (isCorrect) {
      return const TextStyle(fontWeight: FontWeight.bold, color: AppColors.emerald);
    }
    if (isSelected) {
      return const TextStyle(fontWeight: FontWeight.bold, color: AppColors.rose);
    }
    return const TextStyle(color: Colors.grey);
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
