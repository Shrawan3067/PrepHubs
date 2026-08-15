import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/company.dart';
import '../../models/question.dart';
import '../../models/test_result.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/questions/code_block_view.dart';
import 'test_result_screen.dart';

class TestExamScreen extends StatefulWidget {
  final Company company;
  final List<Question> questions;

  const TestExamScreen({
    super.key,
    required this.company,
    required this.questions,
  });

  @override
  State<TestExamScreen> createState() => _TestExamScreenState();
}

class _TestExamScreenState extends State<TestExamScreen> {
  int _currentIndex = 0;
  late Map<int, String> _userAnswers; // index -> choice ('A','B','C','D')
  late Set<int> _flaggedIndices;
  late List<int> _timeSpentPerQuestion;

  Timer? _timer;
  late int _remainingSeconds;
  int _totalSecondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _userAnswers = {};
    _flaggedIndices = {};
    _timeSpentPerQuestion = List.filled(widget.questions.length, 0);

    // Set 15 min or company duration
    _remainingSeconds = 15 * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          _totalSecondsElapsed++;
          _timeSpentPerQuestion[_currentIndex]++;
        });
      } else {
        _timer?.cancel();
        _submitExam(autoSubmit: true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _selectAnswer(String choice) {
    setState(() {
      _userAnswers[_currentIndex] = choice;
    });
  }

  void _clearChoice() {
    setState(() {
      _userAnswers.remove(_currentIndex);
    });
  }

  void _toggleFlag() {
    setState(() {
      if (_flaggedIndices.contains(_currentIndex)) {
        _flaggedIndices.remove(_currentIndex);
      } else {
        _flaggedIndices.add(_currentIndex);
      }
    });
  }

  void _submitExam({bool autoSubmit = false}) {
    _timer?.cancel();

    int correct = 0;
    int incorrect = 0;
    int skipped = 0;
    List<QuestionAnswer> qaList = [];

    for (int i = 0; i < widget.questions.length; i++) {
      final q = widget.questions[i];
      final sel = _userAnswers[i] ?? '';
      final isCorr = sel == q.correctAnswer;

      if (sel.isEmpty) {
        skipped++;
      } else if (isCorr) {
        correct++;
      } else {
        incorrect++;
      }

      qaList.add(QuestionAnswer(
        questionId: q.id,
        selectedOption: sel,
        correctAnswer: q.correctAnswer,
        isCorrect: isCorr,
        isFlagged: _flaggedIndices.contains(i),
        timeSpentSeconds: _timeSpentPerQuestion[i],
      ));
    }

    final result = TestResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      company: widget.company.name,
      title: '${widget.company.name} Mock Test',
      date: DateTime.now(),
      totalQuestions: widget.questions.length,
      correctCount: correct,
      incorrectCount: incorrect,
      skippedCount: skipped,
      totalTimeSeconds: _totalSecondsElapsed,
      answers: qaList,
    );

    final appState = Provider.of<AppState>(context, listen: false);
    appState.addTestResult(result);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TestResultScreen(
          result: result,
          questions: widget.questions,
        ),
      ),
    );
  }

  void _confirmSubmit() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Assessment?'),
        content: Text(
          'You have answered ${_userAnswers.length} of ${widget.questions.length} questions.\n'
          '${_flaggedIndices.length} flagged for review.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Return to Exam'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _submitExam();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emerald),
            child: const Text('Confirm Submit'),
          ),
        ],
      ),
    );
  }

  void _openQuestionPalette() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Question Palette',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _paletteLegend(AppColors.emerald, 'Answered'),
                  _paletteLegend(AppColors.amber, 'Flagged'),
                  _paletteLegend(AppColors.rose, 'Unanswered'),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: widget.questions.length,
                  itemBuilder: (context, index) {
                    final isAns = _userAnswers.containsKey(index);
                    final isFlagged = _flaggedIndices.contains(index);
                    final isCurrent = index == _currentIndex;

                    Color bg = Colors.grey.shade300;
                    if (isFlagged) {
                      bg = AppColors.amber;
                    } else if (isAns) {
                      bg = AppColors.emerald;
                    } else if (index < _currentIndex) {
                      bg = AppColors.rose;
                    }

                    return InkWell(
                      onTap: () {
                        setState(() => _currentIndex = index);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(8),
                          border: isCurrent
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _paletteLegend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  String _formatTime(int totalSeconds) {
    final m = (totalSeconds / 60).floor().toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = widget.questions[_currentIndex];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _confirmSubmit();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Q ${_currentIndex + 1}/${widget.questions.length}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _remainingSeconds < 180 ? AppColors.rose : AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.grid_view_rounded),
                onPressed: _openQuestionPalette,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Box
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${currentQ.topic} • ${currentQ.difficulty}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              IconButton(
                                icon: Icon(
                                  _flaggedIndices.contains(_currentIndex)
                                      ? Icons.flag_rounded
                                      : Icons.flag_outlined,
                                  color: _flaggedIndices.contains(_currentIndex)
                                      ? AppColors.amber
                                      : Colors.grey,
                                ),
                                onPressed: _toggleFlag,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentQ.questionText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                          ),
                          if (currentQ.questionText.contains('```')) ...[
                            CodeBlockView(code: currentQ.questionText),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Options
                    ...['A', 'B', 'C', 'D'].map((choice) {
                      final optionText = currentQ.getOption(choice);
                      final isSelected = _userAnswers[_currentIndex] == choice;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: CustomCard(
                          padding: const EdgeInsets.all(14),
                          backgroundColor: isSelected
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : (isDark ? AppColors.darkCard : AppColors.lightCard),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            width: isSelected ? 2 : 1,
                          ),
                          onTap: () => _selectAnswer(choice),
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
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  optionText,
                                  style: const TextStyle(fontSize: 14),
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
            ),

            // Bottom Exam Bar
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: _currentIndex > 0
                        ? () => setState(() => _currentIndex--)
                        : null,
                    child: const Text('Prev'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _clearChoice,
                    child: const Text('Clear'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _currentIndex == widget.questions.length - 1
                        ? ElevatedButton(
                            onPressed: _confirmSubmit,
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emerald),
                            child: const Text('Submit Exam'),
                          )
                        : ElevatedButton(
                            onPressed: () => setState(() => _currentIndex++),
                            child: const Text('Next'),
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
}
