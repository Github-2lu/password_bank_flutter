import 'package:flutter/material.dart';
import 'package:password_bank_flutter/screens/log_in.dart';
import 'package:google_fonts/google_fonts.dart';

final kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 213, 109, 231));

final kDarkColorScheme = ColorScheme.fromSeed(seedColor: Colors.black);

// This is the light theme
// final theme = ThemeData().copyWith(
//   colorScheme: kColorScheme,
//   // textTheme: GoogleFonts.latoTextTheme(),
//   textTheme: TextTheme().copyWith(bodyMedium: TextStyle(color: Colors.black)),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: kColorScheme.primaryContainer,
//     ),
//   ),
//   inputDecorationTheme: const InputDecorationTheme().copyWith(
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
//   ),
//   snackBarTheme: const SnackBarThemeData()
//       .copyWith(backgroundColor: kColorScheme.onBackground),
//   appBarTheme:
//       const AppBarTheme().copyWith(backgroundColor: kColorScheme.primary),
//   scaffoldBackgroundColor: kColorScheme.surfaceVariant,
//   cardTheme: const CardTheme()
//       .copyWith(color: kColorScheme.tertiaryContainer, elevation: 2),
//   iconTheme: const IconThemeData().copyWith(color: kColorScheme.background),
//   iconButtonTheme: IconButtonThemeData(
//     style: const ButtonStyle().copyWith(
//       iconColor: MaterialStatePropertyAll(kColorScheme.background),
//     ),
//   ),
// );

final theme = ThemeData().copyWith(
  colorScheme: kColorScheme,
  textTheme: GoogleFonts.latoTextTheme(),
  // textTheme: TextTheme().copyWith(bodyMedium: TextStyle(color: kColorScheme.background)),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kColorScheme.primaryContainer,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme().copyWith(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    hintStyle: TextStyle(
        // color: kColorScheme.background,
        ),
    // labelStyle: TextStyle(color: kColorScheme.background),
  ),
  snackBarTheme: const SnackBarThemeData()
      .copyWith(backgroundColor: kColorScheme.onBackground),
  appBarTheme:
      const AppBarTheme().copyWith(backgroundColor: kColorScheme.primary),
  scaffoldBackgroundColor: kColorScheme.surfaceVariant,
  cardTheme: const CardTheme()
      .copyWith(color: kColorScheme.tertiaryContainer, elevation: 2),
  // iconTheme: const IconThemeData().copyWith(color: kColorScheme.background),
  // iconButtonTheme: IconButtonThemeData(
  //   style: const ButtonStyle().copyWith(
  //     iconColor: MaterialStatePropertyAll(kColorScheme.background),
  //   ),
  // ),
);

final darkTheme = ThemeData().copyWith(
  colorScheme: kDarkColorScheme,
  // textTheme: GoogleFonts.latoTextTheme(),
  textTheme: TextTheme()
      .copyWith(bodyMedium: TextStyle(color: kDarkColorScheme.background)),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kDarkColorScheme.primaryContainer,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme().copyWith(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      hintStyle: TextStyle(
        color: kDarkColorScheme.background,
      ),
      labelStyle: TextStyle(color: kDarkColorScheme.background)),
  snackBarTheme: const SnackBarThemeData().copyWith(
      backgroundColor: kDarkColorScheme.background,
      contentTextStyle: TextStyle(color: kDarkColorScheme.onBackground)),
  appBarTheme: const AppBarTheme()
      .copyWith(backgroundColor: kDarkColorScheme.onBackground),
  scaffoldBackgroundColor: kDarkColorScheme.onBackground,
  cardTheme: const CardTheme()
      .copyWith(color: kDarkColorScheme.surfaceTint, elevation: 2),
  iconTheme: const IconThemeData().copyWith(color: kDarkColorScheme.background),
  iconButtonTheme: IconButtonThemeData(
    style: const ButtonStyle().copyWith(
      iconColor: MaterialStatePropertyAll(kDarkColorScheme.background),
    ),
  ),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: theme, darkTheme: darkTheme, home: const LogInScreen());
  }
}
