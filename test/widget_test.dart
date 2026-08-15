import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:placementprep/main.dart';
import 'package:placementprep/providers/app_state.dart';
import 'package:placementprep/providers/theme_provider.dart';

void main() {
  testWidgets('PlacementPrep App initializes and renders properly', (WidgetTester tester) async {
    // Build our app wrapped with MultiProvider
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const PlacementPrepApp(),
      ),
    );

    // Initial state triggers loading or onboarding
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
