import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thành công")),
      );

      Navigator.pop(context); // quay về login
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  String? validateConfirm(String? value) {
    if (value != _passwordController.text) return "Không khớp";
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

              const Text("Đăng ký", style: TextStyle(fontSize: 28)),

              const SizedBox(height: 30),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: "Email"),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(hintText: "Mật khẩu"),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _confirmController,
                validator: validateConfirm,
                decoration: const InputDecoration(hintText: "Xác nhận mật khẩu"),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _isLoading ? null : signup,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Đăng ký"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}