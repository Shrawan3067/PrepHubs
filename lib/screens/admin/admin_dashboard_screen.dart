import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final submissions = appState.submissions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Management Console'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // System Metrics
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    child: Column(
                      children: [
                        const Text('Active Questions', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text('${appState.allQuestions.length}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomCard(
                    child: Column(
                      children: [
                        const Text('Submissions', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text('${submissions.length}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.amber)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Pending Question Submissions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            if (submissions.isEmpty)
              const CustomCard(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: Text('No community question submissions pending review.')),
                ),
              )
            else
              ...submissions.map(
                (sub) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${sub.company} • ${sub.topic}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: sub.status == 'Approved'
                                    ? AppColors.emerald.withValues(alpha: 0.2)
                                    : (sub.status == 'Rejected' ? AppColors.rose.withValues(alpha: 0.2) : AppColors.amber.withValues(alpha: 0.2)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                sub.status,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: sub.status == 'Approved'
                                      ? AppColors.emerald
                                      : (sub.status == 'Rejected' ? AppColors.rose : AppColors.amber),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(sub.questionText, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('Ans: Option ${sub.correctAnswer} | Contributor: ${sub.contributorEmail}',
                            style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        const SizedBox(height: 12),

                        if (sub.status == 'Pending')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  appState.updateSubmissionStatus(sub.id, 'Rejected');
                                },
                                style: OutlinedButton.styleFrom(foregroundColor: AppColors.rose),
                                child: const Text('Reject'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  appState.updateSubmissionStatus(sub.id, 'Approved');
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.emerald),
                                child: const Text('Approve & Add'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
