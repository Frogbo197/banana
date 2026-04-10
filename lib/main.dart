import 'package:flutter/material.dart';
// Đảm bảo tên file này trùng với tên file bạn đã tạo trong thư mục lib
import 'package:salud_tlsk_ai/signin.dart';
import 'package:salud_tlsk_ai/register.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt nhãn Debug cho đẹp
      title: 'Salud AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D6EFD)),
        useMaterial3: true,
      ),
      home: const SignInScreen(),
    );
  }
}