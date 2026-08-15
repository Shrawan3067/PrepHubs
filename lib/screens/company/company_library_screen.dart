import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_colors.dart';
import '../../models/company.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/pro_badge.dart';
import 'company_detail_screen.dart';

class CompanyLibraryScreen extends StatefulWidget {
  const CompanyLibraryScreen({super.key});

  @override
  State<CompanyLibraryScreen> createState() => _CompanyLibraryScreenState();
}

class _CompanyLibraryScreenState extends State<CompanyLibraryScreen> {
  String _searchQuery = '';
  String _selectedDifficulty = 'All';
  String _sortBy = 'Popular'; // Popular, Questions, Name

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    List<Company> filtered = appState.companies.where((c) {
      final matchesSearch = c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.tag.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDiff = _selectedDifficulty == 'All' || c.difficulty == _selectedDifficulty;
      return matchesSearch && matchesDiff;
    }).toList();

    if (_sortBy == 'Questions') {
      filtered.sort((a, b) => b.totalQuestions.compareTo(a.totalQuestions));
    } else if (_sortBy == 'Name') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Library'),
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search company (e.g. TCS, Infosys, Deloitte)...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Difficulty Chips
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', 'Easy', 'Medium', 'Hard'].map((diff) {
                            final isSel = _selectedDifficulty == diff;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: ChoiceChip(
                                label: Text(diff),
                                selected: isSel,
                                onSelected: (sel) {
                                  if (sel) setState(() => _selectedDifficulty = diff);
                                },
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: isSel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Sort Dropdown
                    DropdownButton<String>(
                      value: _sortBy,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.sort_rounded, size: 20),
                      items: ['Popular', 'Questions', 'Name'].map((val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Text(val, style: const TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _sortBy = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Company Cards List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final company = filtered[index];
                final isFav = appState.isFavoriteCompany(company.name);
                final accentColor = AppColors.fromHex(company.accentHex);

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: CustomCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CompanyDetailScreen(company: company),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: accentColor.withValues(alpha: 0.15),
                              child: Text(
                                company.logoText,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: accentColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        company.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      if (company.isPremiumOnly) ...[
                                        const SizedBox(width: 6),
                                        const ProBadge(compact: true),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    company.tag,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: isFav ? AppColors.rose : Colors.grey,
                                size: 20,
                              ),
                              onPressed: () {
                                appState.toggleFavoriteCompany(company.name);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        // Category Breakdown Tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _buildTag('Aptitude: ${company.aptitudeCount}', AppColors.primary),
                            _buildTag('Reasoning: ${company.reasoningCount}', AppColors.secondary),
                            _buildTag('Verbal: ${company.verbalCount}', AppColors.accent),
                            _buildTag('Coding: ${company.codingCount}', AppColors.emerald),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Exam Time: ${company.durationMinutes} mins',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _getDifficultyColor(company.difficulty).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    company.difficulty,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _getDifficultyColor(company.difficulty),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primary),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getDifficultyColor(String diff) {
    switch (diff) {
      case 'Easy':
        return AppColors.emerald;
      case 'Medium':
        return AppColors.amber;
      case 'Hard':
        return AppColors.rose;
      default:
        return AppColors.primary;
    }
  }
}
