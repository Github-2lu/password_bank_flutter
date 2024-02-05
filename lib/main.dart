import 'package:flutter/material.dart';
import 'package:password_bank_flutter/screens/log_in.dart';
import 'package:google_fonts/google_fonts.dart';

final kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 213, 109, 231));

final theme = ThemeData().copyWith(
    colorScheme: kColorScheme,
    textTheme: GoogleFonts.latoTextTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kColorScheme.primaryContainer,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme().copyWith(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    ),
    snackBarTheme: const SnackBarThemeData()
        .copyWith(backgroundColor: kColorScheme.onBackground),
    appBarTheme:
        const AppBarTheme().copyWith(backgroundColor: kColorScheme.primary),
    scaffoldBackgroundColor: kColorScheme.surfaceVariant,
    cardTheme: const CardTheme()
        .copyWith(color: kColorScheme.tertiaryContainer, elevation: 2));

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: theme, home: const LogInScreen());
  }
}
