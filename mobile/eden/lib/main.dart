import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'home.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Run the app with error handling
  runZonedGuarded(
    () => runApp(const MyApp()),
    (error, stackTrace) {
      // Handle errors that occur during app initialization
      debugPrint('Error in runZonedGuarded: $error');
      debugPrint('Stack trace: $stackTrace');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoe Store App',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Add error handling for widgets
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return Scaffold(
            appBar: AppBar(title: const Text('An error occurred')),
            body: Center(
              child: Text(
                'Something went wrong. Please restart the app.\n${errorDetails.exception}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        };
        return child!;
      },
      theme: ThemeData(
        // Use system font with fallback
        fontFamily: 'Roboto, -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue[700]!,
          secondary: Colors.blue[700]!,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        // Simplified text theme with fallback fonts
        textTheme: TextTheme(
          displayLarge: const TextStyle(fontFamily: 'Roboto', fontFamilyFallback: ['sans-serif']),
          displayMedium: const TextStyle(fontFamily: 'Roboto', fontFamilyFallback: ['sans-serif']),
          displaySmall: const TextStyle(fontFamily: 'Roboto', fontFamilyFallback: ['sans-serif']),
          headlineMedium: const TextStyle(fontFamily: 'Roboto', fontFamilyFallback: ['sans-serif']),
          headlineSmall: const TextStyle(fontFamily: 'Roboto', fontFamilyFallback: ['sans-serif']),
          titleLarge: const TextStyle(fontFamily: 'Roboto', fontFamilyFallback: ['sans-serif']),
          titleMedium: const TextStyle(fontFamily: 'Roboto', fontFamilyFallback: ['sans-serif']),
          titleSmall: const TextStyle(fontFamily: 'Roboto', fontFamilyFallback: ['sans-serif']),
          bodyLarge: const TextStyle(fontFamily: 'Roboto', fontFamilyFallback: ['sans-serif']),
          bodyMedium: const TextStyle(fontFamily: 'Roboto', fontFamilyFallback: ['sans-serif']),
          bodySmall: const TextStyle(fontFamily: 'Roboto', fontFamilyFallback: ['sans-serif']),
          labelLarge: const TextStyle(fontFamily: 'Roboto', fontFamilyFallback: ['sans-serif']),
          labelSmall: const TextStyle(fontFamily: 'Roboto', fontFamilyFallback: ['sans-serif']),
        ),
      ),
      home: HomePage(),
    );
  }
}
