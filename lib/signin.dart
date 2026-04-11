import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  /// 🔹 validate email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Không được để trống";
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Email không hợp lệ";
    }
    return null;
  }

  /// 🔹 validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Không được để trống";
    if (value.length < 6) return "Mật khẩu tối thiểu 6 ký tự";
    return null;
  }

  /// 🔥 LOGIN FIREBASE
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // 👉 Wrapper sẽ tự chuyển màn
    } on FirebaseAuthException catch (e) {
      String message = "Đăng nhập thất bại";

      if (e.code == 'user-not-found') {
        message = "Email không tồn tại";
      } else if (e.code == 'wrong-password') {
        message = "Sai mật khẩu";
      } else if (e.code == 'invalid-email') {
        message = "Email không hợp lệ";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// 🔵 HEADER CONG
            ClipPath(
              clipper: HeaderClipper(),
              child: Container(
                height: 220,
                width: double.infinity,
                color: const Color(0xFF89B0E5),
                child: const Center(
                  child: Icon(Icons.blur_on,
                      color: Colors.white, size: 40),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Đăng nhập',
                      style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),

                    /// 📧 EMAIL
                    TextFormField(
                      controller: _emailController,
                      validator: _validateEmail,
                      decoration: InputDecoration(
                        hintText: "Nhập email...",
                        prefixIcon:
                        const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔒 PASSWORD
                    TextFormField(
                      controller: _passwordController,
                      validator: _validatePassword,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "Nhập mật khẩu...",
                        prefixIcon:
                        const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                              !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// 🔵 BUTTON LOGIN
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF0D6EFD),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text(
                          'Đăng nhập',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ❓ FORGOT PASSWORD
                    GestureDetector(
                      onTap: () async {
                        if (_emailController.text.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Nhập email trước")),
                          );
                          return;
                        }

                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(
                            email: _emailController.text
                                .trim());

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Đã gửi email reset")),
                        );
                      },
                      child: const Text(
                        "Quên mật khẩu",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
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

/// 🔥 HEADER SHAPE
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}