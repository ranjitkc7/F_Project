import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_controller.dart';
import 'screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, ThemeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color.fromARGB(255, 244, 236, 213),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6208F2),
              brightness: Brightness.light,
            ),
            textTheme: GoogleFonts.quicksandTextTheme(
              ThemeData.light().textTheme,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6208F2),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            textTheme: GoogleFonts.quicksandTextTheme(
              ThemeData.dark().textTheme,
            ),
          ),
          themeMode: ThemeMode,

          home: const LoginPage(),
        );
      },
    );
  }
}
