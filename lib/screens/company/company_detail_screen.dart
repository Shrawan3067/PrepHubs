import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/company.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_card.dart';
import '../test/test_instructions_screen.dart';
import '../practice/practice_mode_screen.dart';

class CompanyDetailScreen extends StatelessWidget {
  final Company company;

  const CompanyDetailScreen({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final accentColor = AppColors.fromHex(company.accentHex);
    final companyQuestions = appState.getQuestionsForCompany(company.name);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(company.name),
        actions: [
          IconButton(
            icon: Icon(
              appState.isFavoriteCompany(company.name)
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: appState.isFavoriteCompany(company.name)
                  ? AppColors.rose
                  : null,
            ),
            onPressed: () {
              appState.toggleFavoriteCompany(company.name);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Banner Card
            CustomCard(
              backgroundColor: accentColor.withValues(alpha: 0.08),
              border: Border.all(color: accentColor.withValues(alpha: 0.3)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: accentColor,
                    child: Text(
                      company.logoText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          company.tag,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.timer_outlined, size: 14, color: accentColor),
                            const SizedBox(width: 4),
                            Text(
                              '${company.durationMinutes} Mins Exam',
                              style: TextStyle(
                                fontSize: 12,
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Exam Launchers
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TestInstructionsScreen(company: company),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Start Full Exam'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PracticeModeScreen(companyFilter: company.name),
                        ),
                      );
                    },
                    icon: const Icon(Icons.quiz_outlined),
                    label: const Text('Practice Qs'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Question Distribution Breakdown
            const Text(
              'Exam Question Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildSectionRow('Aptitude Section', company.aptitudeCount, AppColors.primary, context),
            _buildSectionRow('Reasoning Section', company.reasoningCount, AppColors.secondary, context),
            _buildSectionRow('Verbal Ability', company.verbalCount, AppColors.accent, context),
            _buildSectionRow('Coding & Pseudo Code', company.codingCount, AppColors.emerald, context),

            const SizedBox(height: 24),

            // Sample Active Questions List
            Text(
              'Available Question Bank (${companyQuestions.length} Questions)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (companyQuestions.isEmpty)
              const CustomCard(
                child: Center(
                  child: Text('More questions being loaded from cloud repo...'),
                ),
              )
            else
              ...companyQuestions.map(
                (q) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: CustomCard(
                    padding: const EdgeInsets.all(12),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        q.questionText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${q.topic} • ${q.difficulty} • ${q.subTopic}',
                            style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionRow(String name, int count, Color color, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CustomCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    '$count Questions • Timed Section',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Text(
              '$count Qs',
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
