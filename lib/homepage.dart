import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salud_tlsk_ai/api_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List users = [];
  bool loading = true;

  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    final data = await ApiService.getUsers();
    setState(() {
      users = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),

      body: Column(
        children: [

          /// ===== HEADER =====
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF2C3550),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [

                /// TOP BAR
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          "https://i.imgur.com/BoN9kdC.png"),
                    ),
                    const SizedBox(width: 10),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chào, Lee Doong! 👋",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "+40%",
                            style: TextStyle(
                              color: Color(0xFFB0B7C3),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.notifications,
                          color: Colors.white, size: 18),
                    )
                  ],
                ),

                const SizedBox(height: 16),

                /// SEARCH
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Tìm kiếm...",
                      hintStyle: TextStyle(color: Color(0xFFB0B7C3)),
                      prefixIcon:
                      Icon(Icons.search, color: Color(0xFFB0B7C3)),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Gợi ý bữa ăn AI 🤖",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                )
              ],
            ),
          ),

          /// ===== BODY =====
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HEALTH SCORE
                  const Text(
                    "Điểm sức khỏe",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5A5A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "60",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        const Expanded(
                          child: Text(
                            "Dựa trên dữ liệu bạn nhập, chúng tôi đã đánh giá sức khỏe của bạn",
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// STATS
                  const Text(
                    "Thể trạng và chỉ số",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 10),

                  _progressCard(
                    title: "Calories đã đốt",
                    left: "500 kcal",
                    right: "2000 kcal",
                    value: 0.25,
                  ),

                  _stepsCard(),
                  _nutritionCard(),
                  _waterCard(),

                  const SizedBox(height: 18),

                  /// MEDICINE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Quản lý thuốc",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text("Tất cả",
                          style: TextStyle(color: Color(0xFF4A7DFF))),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "205",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Text(
                          "lần uống",
                          style: TextStyle(fontSize: 12),
                        ),

                        const SizedBox(height: 10),

                        /// GRID
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: List.generate(28, (i) {
                            Color color;
                            if (i % 7 == 0) {
                              color = const Color(0xFFFF5A5A);
                            } else if (i % 3 == 0) {
                              color = const Color(0xFF4A7DFF);
                            } else {
                              color = const Color(0xFFE5E7EB);
                            }

                            return Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ],
      ),

      /// FLOAT BUTTON
      floatingActionButton: Container(
        height: 56,
        width: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF4A7DFF), Color(0xFF6FA8FF)],
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      /// NAVBAR
      bottomNavigationBar: Container(
        height: 65,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black12,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.home, color: Color(0xFF4A7DFF)),
            Icon(Icons.bar_chart, color: Colors.grey),
            SizedBox(width: 40),
            Icon(Icons.restaurant, color: Colors.grey),
            Icon(Icons.settings, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  /// ===== COMPONENTS =====

  Widget _progressCard({
    required String title,
    required String left,
    required String right,
    required double value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 8),

          Row(
            children: [
              Text(left, style: const TextStyle(fontSize: 12)),
              const Spacer(),
              Text(right, style: const TextStyle(fontSize: 12)),
            ],
          ),

          const SizedBox(height: 6),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor:
              const AlwaysStoppedAnimation(Color(0xFFFF5A5A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepsCard() {
    return _simpleCard(
      icon: Icons.directions_walk,
      title: "Bước chân",
      subtitle: "Bạn đã đi 3014 bước",
      trailing: const Icon(Icons.check, color: Colors.green),
    );
  }

  Widget _nutritionCard() {
    return _simpleCard(
      icon: Icons.local_florist,
      title: "Dinh dưỡng",
      trailing: Row(
        children: const [
          _Tag("Vitamin A"),
          SizedBox(width: 6),
          _Tag("Broccoli"),
        ],
      ),
    );
  }

  Widget _waterCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Uống nước"),
          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.35,
              minHeight: 6,
              backgroundColor: Color(0xFFE5E7EB),
              valueColor:
              AlwaysStoppedAnimation(Color(0xFF4A7DFF)),
            ),
          ),

          const SizedBox(height: 6),

          const Row(
            children: [
              Text("700 ml", style: TextStyle(fontSize: 12)),
              Spacer(),
              Text("2000 ml", style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _simpleCard({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                if (subtitle != null)
                  Text(subtitle,
                      style:
                      const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),

          if (trailing != null) trailing,
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4EA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: Colors.green),
      ),
    );
  }
}