import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:salud_tlsk_ai/splash.dart';
import 'package:salud_tlsk_ai/signin.dart';
import 'package:salud_tlsk_ai/signup.dart';
import 'package:salud_tlsk_ai/forgot.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salud AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D6EFD),
        ),
        useMaterial3: true,
      ),

      home: const SplashScreen(),

      routes: {
        '/signin': (context) => const Signin(),
        '/signup': (context) => const Signup(),
        '/forgot': (context) => const Forgot(),
      },
    );
  }
}