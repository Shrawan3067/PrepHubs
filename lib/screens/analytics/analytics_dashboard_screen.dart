import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_card.dart';

class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Overview Cards
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Overall Readiness', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 6),
                        Text(
                          '${appState.readinessScore}%',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tests Completed', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 6),
                        Text(
                          '${appState.testHistory.length}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.emerald),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Accuracy Trend Line Chart
            const Text(
              'Accuracy Trend (Last 7 Tests)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            CustomCard(
              child: SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(1, 60),
                          FlSpot(2, 72),
                          FlSpot(3, 68),
                          FlSpot(4, 85),
                          FlSpot(5, 80),
                          FlSpot(6, 92),
                        ],
                        isCurved: true,
                        color: AppColors.primary,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.primary.withValues(alpha: 0.15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Topic Mastery Bar Chart
            const Text(
              'Topic Mastery Breakdown',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            CustomCard(
              child: Column(
                children: [
                  _buildMasteryBar('Aptitude', 0.85, AppColors.primary),
                  _buildMasteryBar('Logical Reasoning', 0.72, AppColors.secondary),
                  _buildMasteryBar('Verbal Ability', 0.64, AppColors.accent),
                  _buildMasteryBar('Coding & Debugging', 0.90, AppColors.emerald),
                  _buildMasteryBar('Data Structures', 0.78, AppColors.amber),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Weak & Strong Areas Recommendation
            const Text(
              'AI Placement Insights',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            CustomCard(
              backgroundColor: AppColors.emerald.withValues(alpha: 0.08),
              border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3)),
              child: const Row(
                children: [
                  Icon(Icons.star_rounded, color: AppColors.emerald),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Strongest Skill: Coding & Algorithms',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('90% accuracy across TCS & Infosys coding questions.',
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            CustomCard(
              backgroundColor: AppColors.rose.withValues(alpha: 0.08),
              border: Border.all(color: AppColors.rose.withValues(alpha: 0.3)),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppColors.rose),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Focus Area: Verbal Ability & Synonyms',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('Practice 15 more verbal questions to boost Accenture readiness.',
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
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

  Widget _buildMasteryBar(String label, double val, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text('${(val * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: val,
              minHeight: 8,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
