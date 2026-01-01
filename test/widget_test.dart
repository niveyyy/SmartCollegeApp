import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_college_app/main.dart';

void main() {
  testWidgets('HomeScreen UI test', (WidgetTester tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(isAdmin: false), // ✅ REQUIRED PARAM
      ),
    );

    expect(find.text('Smart College Assistant'), findsOneWidget);
    expect(find.text('Chatbot'), findsOneWidget);
    expect(find.text('Route Finder'), findsOneWidget);
    expect(find.text('Notice Board'), findsOneWidget);
  });
}
