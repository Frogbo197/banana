import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscure = true;

  Future<void> signin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng nhập thành công")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Nhập email";
    if (!value.contains("@")) return "Sai email";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6) return "Tối thiểu 6 ký tự";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text("Đăng nhập", style: TextStyle(fontSize: 28)),

              const SizedBox(height: 30),

              TextFormField(
                controller: _emailController,
                validator: validateEmail,
                decoration: const InputDecoration(hintText: "Email"),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _passwordController,
                obscureText: _obscure,
                validator: validatePassword,
                decoration: InputDecoration(
                  hintText: "Mật khẩu",
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _isLoading ? null : signin,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Đăng nhập"),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text("Đăng ký"),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot');
                },
                child: const Text("Quên mật khẩu"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}