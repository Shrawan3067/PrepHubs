import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/question.dart';
import '../../widgets/common/custom_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    List<Question> results = [];
    if (_query.trim().isNotEmpty) {
      results = appState.allQuestions.where((q) {
        final qText = q.questionText.toLowerCase();
        final company = q.company.toLowerCase();
        final topic = q.topic.toLowerCase();
        final subTopic = q.subTopic.toLowerCase();
        final qTerm = _query.toLowerCase();
        return qText.contains(qTerm) || company.contains(qTerm) || topic.contains(qTerm) || subTopic.contains(qTerm);
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          onChanged: (val) => setState(() => _query = val),
          decoration: const InputDecoration(
            hintText: 'Search topic, formula, or question keyword...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
      body: _query.isEmpty
          ? const Center(
              child: Text(
                'Search across TCS, Infosys, Aptitude, Coding & Data Structures',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : results.isEmpty
              ? const Center(child: Text('No matching questions found.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final q = results[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: CustomCard(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            q.questionText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${q.company} • ${q.topic} • ${q.difficulty}',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
