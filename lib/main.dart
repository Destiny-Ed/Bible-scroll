import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/views/splash_screen.dart';
import 'package:provider/provider.dart';
import 'viewmodels/theme_view_model.dart';
import 'viewmodels/feed_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FeedViewModel()),
      ],
      child: const BibleScrollApp(),
    ),
  );
}

class BibleScrollApp extends StatelessWidget {
  const BibleScrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'BibleScroll',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: const Color(0xFF1E1E2C),
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4A4A6A),
          secondary: Color(0xFFF50057),
          background: Color(0xFFF0F2F5),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Color(0xFF1E1E2C),
          onSurface: Color(0xFF1E1E2C),
        ),
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme)
            .copyWith(
              displayLarge: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E2C),
              ),
              bodyMedium: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4A4A6A),
              ),
            ),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF1E1E2C),
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7B7B9E),
          secondary: Color(0xFFF50057),
          background: Color(0xFF121212),
          surface: Color(0xFF1E1E2C),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
        textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme)
            .copyWith(
              displayLarge: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              bodyMedium: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
        cardTheme: CardThemeData(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
