import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../practice/practice_mode_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final bookmarkedQuestions = appState.getBookmarkedQuestions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Questions'),
        actions: [
          if (bookmarkedQuestions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.play_circle_fill_rounded, color: AppColors.primary),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PracticeModeScreen()),
                );
              },
            ),
        ],
      ),
      body: bookmarkedQuestions.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.bookmark_border_rounded,
              title: 'No Bookmarked Questions',
              description: 'Tap the bookmark icon on any practice question to save it for revision here.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarkedQuestions.length,
              itemBuilder: (context, index) {
                final q = bookmarkedQuestions[index];
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
                        child: Text('${q.company} • ${q.topic} • ${q.difficulty}',
                            style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.bookmark_remove_rounded, color: AppColors.rose),
                        onPressed: () {
                          appState.toggleBookmark(q.id);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
