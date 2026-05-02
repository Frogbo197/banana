import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salud_tlsk_ai/wrapper.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {

  bool isLoading = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    sendVerification();

    timer = Timer.periodic(const Duration(seconds: 3), (_) => checkVerified());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> sendVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.sendEmailVerification();
  }

  Future<void> checkVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      timer?.cancel();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Wrapper()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Xác thực email")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 40),

            const Icon(Icons.email, size: 80, color: Colors.blue),

            const SizedBox(height: 20),

            const Text(
              "Kiểm tra email của bạn",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Chúng tôi đã gửi email xác thực.\nSau khi xác nhận, bạn sẽ được chuyển tự động.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: sendVerification,
              child: const Text("Gửi lại email"),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                if (!mounted) return;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Wrapper()),
                );
              },
              child: const Text("Đăng nhập lại"),
            )
          ],
        ),
      ),
    );
  }
}