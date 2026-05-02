import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salud_tlsk_ai/homepage.dart';
import 'package:salud_tlsk_ai/signin.dart';
import 'package:salud_tlsk_ai/onboarding.dart';
import 'package:salud_tlsk_ai/verifyemail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  bool? seenOnboarding;

  @override
  void initState() {
    super.initState();
    loadState();
  }

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      seenOnboarding = prefs.getBool('doneOnboarding') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (seenOnboarding == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Signin();
    }

    if (!user.emailVerified) {
      return const VerifyEmail();
    }

    if (!seenOnboarding!) {
      return const Onboarding();
    }

    return const Homepage();
  }
}