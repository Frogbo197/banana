import 'package:flutter/material.dart';
import 'package:salud_tlsk_ai/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> data = [
    {
      "image": "assets/1.png",
      "title": "Chào mừng đến với salud",
      "desc": "Trợ lý AI theo dõi sức khỏe cá nhân",
    },
    {
      "image": "assets/2.png",
      "title": "Theo dõi hoạt động hàng ngày",
      "desc": "Theo dõi bước đi, calo và chỉ số",
    },
    {
      "image": "assets/3.png",
      "title": "Gợi ý chăm sóc sức khỏe",
      "desc": "AI đưa ra lời khuyên phù hợp",
    },
    {
      "image": "assets/4.png",
      "title": "Nhắc nhở chăm sóc sức khỏe",
      "desc": "Nhắc uống nước và vận động",
    },
    {
      "image": "assets/5.png",
      "title": "Quản lý dinh dưỡng",
      "desc": "Ăn uống khoa học mỗi ngày",
    },
    {
      "image": "assets/6.png",
      "title": "Theo dõi sức khỏe tổng thể",
      "desc": "Hiểu rõ cơ thể của bạn",
    },
    {
      "image": "assets/7.png",
      "title": "Bắt đầu sử dụng",
      "desc": "Cùng chăm sóc sức khỏe ngay",
    },
  ];

  void nextPage() async {
    if (currentIndex == data.length - 1) {

      await FirebaseAuth.instance.signOut(); // 🔥 thêm ở đây

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Wrapper()),
      );
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      body: Stack(
        children: [

          PageView.builder(
            controller: _controller,
            itemCount: data.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (context, index) {
              final item = data[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                            ),
                            child: Center(
                              child: Image.asset(
                                item["image"]!,
                                width: 170,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          Text(
                            item["title"]!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 10),

                          Text(
                            item["desc"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              data.length,
                                  (i) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: currentIndex == i ? 20 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: currentIndex == i
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(18),
                            ),
                            child: Icon(
                              currentIndex == data.length - 1
                                  ? Icons.check
                                  : Icons.arrow_forward,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          if (currentIndex != data.length - 1)
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Wrapper()),
                  );
                },
                child: const Text(
                  "Bỏ qua",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  }
