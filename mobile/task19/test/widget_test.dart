// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // Import mocktail
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

import 'package:contracts_of_data_sources/main.dart';

// Create a mock for SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  // Create an instance of your mock SharedPreferences
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    // Initialize the mock before each test
    mockSharedPreferences = MockSharedPreferences();
    // Set up default behaviors for methods that MyApp or its dependencies call.
    // For example, if your app tries to read something from SharedPreferences on startup:
    when(() => mockSharedPreferences.getString(any())).thenReturn(null);
    when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) async => true);
    // Add other common mock behaviors as needed by your app's initialization
  });

  testWidgets('App starts and loads products smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame, passing the mock SharedPreferences
    await tester.pumpWidget(MyApp(sharedPreferences: mockSharedPreferences));

    // Wait for initial loading state and then product loaded state
    await tester.pumpAndSettle(); // Wait for all animations and frames to settle

    // Verify that the app is no longer in a loading state and products are displayed or 'No products found'
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('All Products'), findsOneWidget); // Check app bar title

    // Since JSONPlaceholder provides data, we expect to see some products or at least the list view
    expect(find.byType(ListView), findsOneWidget);

    // You can add more specific assertions here if you know what initial data to expect
    // For example, if you know a product titled 'sunt aut facere...' should appear:
    // expect(find.textContaining('sunt aut facere'), findsAtLeastNWidgets(1));
  });
}