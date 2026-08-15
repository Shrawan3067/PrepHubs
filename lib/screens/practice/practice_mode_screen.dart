import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/question.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/questions/code_block_view.dart';
import '../../widgets/questions/explanation_view.dart';
import '../pro/paywall_screen.dart';

class PracticeModeScreen extends StatefulWidget {
  final String? companyFilter;
  final String? topicFilter;

  const PracticeModeScreen({
    super.key,
    this.companyFilter,
    this.topicFilter,
  });

  @override
  State<PracticeModeScreen> createState() => _PracticeModeScreenState();
}

class _PracticeModeScreenState extends State<PracticeModeScreen> {
  int _currentIndex = 0;
  String _selectedOption = '';
  bool _isAnswerSubmitted = false;
  String _confidenceLevel = 'Medium'; // Low, Medium, High

  late String _selectedCompany;
  late String _selectedTopic;
  late String _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _selectedCompany = widget.companyFilter ?? 'All';
    _selectedTopic = widget.topicFilter ?? 'All';
    _selectedDifficulty = 'All';
  }

  List<Question> _getFilteredQuestions(AppState appState) {
    return appState.allQuestions.where((q) {
      final matchesComp = _selectedCompany == 'All' || q.company == _selectedCompany;
      final matchesTop = _selectedTopic == 'All' || q.topic == _selectedTopic;
      final matchesDiff = _selectedDifficulty == 'All' || q.difficulty == _selectedDifficulty;
      return matchesComp && matchesTop && matchesDiff;
    }).toList();
  }

  void _onOptionSelected(String option) {
    if (_isAnswerSubmitted) return;
    setState(() {
      _selectedOption = option;
    });
  }

  void _submitAnswer() {
    if (_selectedOption.isEmpty) return;
    setState(() {
      _isAnswerSubmitted = true;
    });
  }

  void _nextQuestion(int total) {
    if (_currentIndex < total - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = '';
        _isAnswerSubmitted = false;
      });
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _selectedOption = '';
        _isAnswerSubmitted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final questions = _getFilteredQuestions(appState);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Mode'),
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterDropdown(
                    label: 'Company: $_selectedCompany',
                    items: ['All', 'TCS', 'Infosys', 'Wipro', 'Accenture', 'Cognizant', 'Capgemini', 'Deloitte', 'HCL', 'Tech Mahindra', 'LTIMindtree'],
                    onChanged: (val) => setState(() {
                      _selectedCompany = val;
                      _currentIndex = 0;
                      _isAnswerSubmitted = false;
                    }),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterDropdown(
                    label: 'Topic: $_selectedTopic',
                    items: ['All', 'Aptitude', 'Logical Reasoning', 'Verbal', 'Coding', 'Debugging', 'Data Structures', 'Algorithms', 'Puzzles'],
                    onChanged: (val) => setState(() {
                      _selectedTopic = val;
                      _currentIndex = 0;
                      _isAnswerSubmitted = false;
                    }),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterDropdown(
                    label: 'Difficulty: $_selectedDifficulty',
                    items: ['All', 'Easy', 'Medium', 'Hard'],
                    onChanged: (val) => setState(() {
                      _selectedDifficulty = val;
                      _currentIndex = 0;
                      _isAnswerSubmitted = false;
                    }),
                  ),
                ],
              ),
            ),
          ),

          if (questions.isEmpty)
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No questions match the selected filters.\nTry changing company or topic.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else ...[
            // Progress Counter Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentIndex + 1} of ${questions.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          appState.isBookmarked(questions[_currentIndex].id)
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: appState.isBookmarked(questions[_currentIndex].id)
                              ? AppColors.primary
                              : null,
                        ),
                        onPressed: () {
                          appState.toggleBookmark(questions[_currentIndex].id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_outlined, size: 20),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Question link copied to clipboard')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Question Card Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                  questions[_currentIndex].company,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${questions[_currentIndex].topic} • ${questions[_currentIndex].difficulty}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            questions[_currentIndex].questionText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                          if (questions[_currentIndex].questionText.contains('```')) ...[
                            CodeBlockView(code: questions[_currentIndex].questionText),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Options List
                    ...['A', 'B', 'C', 'D'].map((choice) {
                      final optionText = questions[_currentIndex].getOption(choice);
                      final isSelected = _selectedOption == choice;
                      final isCorrect = questions[_currentIndex].correctAnswer == choice;

                      Color borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
                      Color bgColor = isDark ? AppColors.darkCard : AppColors.lightCard;
                      Widget? statusIcon;

                      if (_isAnswerSubmitted) {
                        if (isCorrect) {
                          borderColor = AppColors.emerald;
                          bgColor = AppColors.emerald.withValues(alpha: 0.12);
                          statusIcon = const Icon(Icons.check_circle_rounded, color: AppColors.emerald);
                        } else if (isSelected) {
                          borderColor = AppColors.rose;
                          bgColor = AppColors.rose.withValues(alpha: 0.12);
                          statusIcon = const Icon(Icons.cancel_rounded, color: AppColors.rose);
                        }
                      } else if (isSelected) {
                        borderColor = AppColors.primary;
                        bgColor = AppColors.primary.withValues(alpha: 0.1);
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: CustomCard(
                          padding: const EdgeInsets.all(14),
                          backgroundColor: bgColor,
                          border: Border.all(color: borderColor, width: isSelected || (_isAnswerSubmitted && isCorrect) ? 2 : 1),
                          onTap: () => _onOptionSelected(choice),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: isSelected ? AppColors.primary : Colors.grey.shade300,
                                child: Text(
                                  choice,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  optionText,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ),
                              if (statusIcon != null) statusIcon,
                            ],
                          ),
                        ),
                      );
                    }),

                    // Confidence Rating Selector
                    if (!_isAnswerSubmitted && _selectedOption.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Confidence: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ...['Low', 'Medium', 'High'].map((level) {
                            final isSel = _confidenceLevel == level;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text(level, style: const TextStyle(fontSize: 10)),
                                selected: isSel,
                                onSelected: (sel) {
                                  if (sel) setState(() => _confidenceLevel = level);
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ],

                    // Explanation View if Submitted
                    if (_isAnswerSubmitted) ...[
                      ExplanationView(
                        explanation: questions[_currentIndex].explanation,
                        isProOnly: questions[_currentIndex].isPro,
                        isUserPro: appState.user.isPro,
                        onUpgradeTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PaywallScreen()),
                          );
                        },
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Nav Action Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: _currentIndex > 0 ? _previousQuestion : null,
                    child: const Text('Previous'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: !_isAnswerSubmitted
                          ? (_selectedOption.isNotEmpty ? _submitAnswer : null)
                          : () => _nextQuestion(questions.length),
                      child: Text(!_isAnswerSubmitted ? 'Check Answer' : 'Next Question'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButton<String>(
        value: label.split(': ').last,
        underline: const SizedBox(),
        isDense: true,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.primary),
        items: items.map((val) {
          return DropdownMenuItem(
            value: val,
            child: Text(val),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
      ),
    );
  }
}
