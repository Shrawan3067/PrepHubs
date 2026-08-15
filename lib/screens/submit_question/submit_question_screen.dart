import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/submission.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';

class SubmitQuestionScreen extends StatefulWidget {
  const SubmitQuestionScreen({super.key});

  @override
  State<SubmitQuestionScreen> createState() => _SubmitQuestionScreenState();
}

class _SubmitQuestionScreenState extends State<SubmitQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _qController = TextEditingController();
  final _optAController = TextEditingController();
  final _optBController = TextEditingController();
  final _optCController = TextEditingController();
  final _optDController = TextEditingController();
  final _expController = TextEditingController();
  final _emailController = TextEditingController();

  String _selectedCompany = 'TCS';
  String _selectedTopic = 'Aptitude';
  final String _selectedDifficulty = 'Medium';
  String _correctChoice = 'A';

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final sub = UserSubmission(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      questionText: _qController.text.trim(),
      optionA: _optAController.text.trim(),
      optionB: _optBController.text.trim(),
      optionC: _optCController.text.trim(),
      optionD: _optDController.text.trim(),
      correctAnswer: _correctChoice,
      explanation: _expController.text.trim(),
      company: _selectedCompany,
      topic: _selectedTopic,
      difficulty: _selectedDifficulty,
      contributorEmail: _emailController.text.trim(),
      submittedAt: DateTime.now(),
    );

    final appState = Provider.of<AppState>(context, listen: false);
    await appState.submitQuestion(sub);

    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Question Submitted! 🎉'),
          content: const Text(
            'Thank you for contributing! Your question is pending review by our Placement Prep team. Once approved, it will be added to the live question bank.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contribute a Question'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Help your fellow engineering students by contributing real exam questions.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _qController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Question Statement *'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _optAController,
                decoration: const InputDecoration(labelText: 'Option A *'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _optBController,
                decoration: const InputDecoration(labelText: 'Option B *'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _optCController,
                decoration: const InputDecoration(labelText: 'Option C *'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _optDController,
                decoration: const InputDecoration(labelText: 'Option D *'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _correctChoice,
                decoration: const InputDecoration(labelText: 'Correct Answer *'),
                items: ['A', 'B', 'C', 'D'].map((c) => DropdownMenuItem(value: c, child: Text('Option $c'))).toList(),
                onChanged: (val) => setState(() => _correctChoice = val!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _expController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Explanation & Formula *'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCompany,
                      decoration: const InputDecoration(labelText: 'Company'),
                      items: ['TCS', 'Infosys', 'Wipro', 'Accenture', 'Cognizant', 'Capgemini', 'Deloitte', 'HCL', 'Tech Mahindra', 'LTIMindtree']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedCompany = val!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedTopic,
                      decoration: const InputDecoration(labelText: 'Topic'),
                      items: ['Aptitude', 'Logical Reasoning', 'Verbal', 'Coding', 'Debugging', 'Data Structures']
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedTopic = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Your Email ID (for reward credits)'),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text('Submit Question for Review'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
