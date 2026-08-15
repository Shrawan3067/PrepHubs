import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/company.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_card.dart';
import 'test_exam_screen.dart';

class TestInstructionsScreen extends StatelessWidget {
  final Company company;

  const TestInstructionsScreen({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final companyQuestions = appState.getQuestionsForCompany(company.name);

    return Scaffold(
      appBar: AppBar(
        title: Text('${company.name} Mock Exam'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCard(
                backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                child: Row(
                  children: [
                    const Icon(Icons.assignment_rounded, size: 36, color: AppColors.primary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Official ${company.name} Pattern Exam',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '${companyQuestions.isNotEmpty ? companyQuestions.length : 10} Questions • ${company.durationMinutes} Minutes',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Assessment Guidelines:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildInstructionItem('1', 'Exam mimics real campus placement drives with countdown timer.'),
              _buildInstructionItem('2', 'Use the Question Palette grid to jump between questions anytime.'),
              _buildInstructionItem('3', 'Flag questions for review if you are uncertain of your answer.'),
              _buildInstructionItem('4', 'The test will auto-submit when the timer reaches 00:00.'),
              _buildInstructionItem('5', 'Do not close or switch apps during the test session.'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final testQs = companyQuestions.isNotEmpty
                        ? companyQuestions
                        : appState.allQuestions.take(10).toList();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TestExamScreen(
                          company: company,
                          questions: testQs,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('I am Ready — Begin Exam'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: Text(
              num,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
