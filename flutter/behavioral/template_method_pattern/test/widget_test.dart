import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:template_method_pattern/main.dart';

void main() {
  testWidgets('ValidationDemoPage renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is correct
    expect(find.text('Template Method Pattern Demo'), findsOneWidget);

    // Verify that all input fields are present
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Phone (Korean)'), findsOneWidget);

    // Verify that buttons are present
    expect(find.text('Validate All'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
  });
}
