import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:salud_tlsk_ai/wrapper.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscure = true;
  bool _obscureConfirm = true;

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      Get.offAll(() => const Wrapper()); // 🔥 chuyển luôn
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message = "Đăng ký thất bại";

      if (e.code == 'email-already-in-use') {
        message = "Email đã tồn tại";
      } else if (e.code == 'invalid-email') {
        message = "Email không hợp lệ";
      } else if (e.code == 'weak-password') {
        message = "Mật khẩu quá yếu";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    setState(() => _isLoading = false);
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Nhập email";
    if (!value.contains("@")) return "Địa chỉ email không hợp lệ!";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6) return "Tối thiểu 6 ký tự";
    return null;
  }

  String? validateConfirm(String? value) {
    if (value != _passwordController.text) return "Mật khẩu không khớp";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFF89B0E5),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(80),
                ),
              ),
              child: const Center(
                child: Icon(Icons.blur_on, color: Colors.white, size: 40),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    const Text(
                      "Đăng ký",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 30),


                    TextFormField(
                      controller: _emailController,
                      validator: validateEmail,
                      decoration: InputDecoration(
                        hintText: "Nhập email...",
                        prefixIcon: const Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscure,
                      validator: validatePassword,
                      decoration: InputDecoration(
                        hintText: "Nhập mật khẩu...",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _confirmController,
                      obscureText: _obscureConfirm,
                      validator: validateConfirm,
                      decoration: InputDecoration(
                        hintText: "Xác nhận mật khẩu...",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Đã có tài khoản? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Đăng nhập",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}