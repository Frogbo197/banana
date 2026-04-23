import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salud_tlsk_ai/wrapper.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController controller = PageController();
  int index = 0;

  Set<String> selected = {};

  /// NEXT
  void next() async {
    if (index == 5) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('doneOnboarding', true);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Wrapper()),
      );
    } else {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  /// ================= OPTION PAGE =================
  Widget buildOptionPage(String title, List<String> options) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          ...options.map((e) {
            final isSelected = selected.contains(e);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selected.remove(e);
                  } else {
                    selected.add(e);
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color:
                  isSelected ? const Color(0xFF2F6FED) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e,
                      style: TextStyle(
                          color:
                          isSelected ? Colors.white : Colors.black),
                    ),
                    Icon(
                      isSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color:
                      isSelected ? Colors.white : Colors.grey,
                    )
                  ],
                ),
              ),
            );
          }).toList()
        ],
      ),
    );
  }

  /// ================= GENDER =================
  Widget buildGenderPage() {
    final PageController pageController =
    PageController(viewportFraction: 0.7);

    int selectedIndex = 1;

    final data = [
      {"label": "Nam", "image": "assets/nam.jpg", "color": Colors.blue},
      {"label": "Nữ", "image": "assets/nu.jpg", "color": Colors.pink},
      {"label": "Khác", "image": "assets/khac.jpg", "color": Colors.purple},
    ];

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text("Giới tính của bạn là gì?",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

              const SizedBox(height: 30),

              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (i) {
                    setState(() {
                      selectedIndex = i;
                      selected.clear();
                      selected.add(data[i]["label"] as String);
                    });
                  },
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final isCenter = index == selectedIndex;

                    return Transform.scale(
                      scale: isCenter ? 1 : 0.85,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: item["color"] as Color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item["label"] as String,
                                      style: const TextStyle(
                                          color: Colors.white)),
                                  if (isCenter)
                                    const Icon(Icons.check,
                                        color: Colors.white)
                                ],
                              ),
                            ),
                            Expanded(
                              child: Image.asset(
                                item["image"] as String,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ================= WEIGHT =================
  Widget buildWeightPage() {
    double weight = 60;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            const Text("Cân nặng của bạn?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 30),

            Text(weight.toInt().toString(),
                style: const TextStyle(
                    fontSize: 50, fontWeight: FontWeight.bold)),

            Expanded(
              child: ListWheelScrollView.useDelegate(
                itemExtent: 60,
                onSelectedItemChanged: (i) =>
                    setState(() => weight = i.toDouble()),
                childDelegate:
                ListWheelChildBuilderDelegate(
                  childCount: 150,
                  builder: (context, index) => Center(
                    child: Text(index.toString()),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// ================= AGE =================
  Widget buildAgePage() {
    int age = 18;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            const Text("Tuổi của bạn?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            Expanded(
              child: ListWheelScrollView.useDelegate(
                itemExtent: 80,
                onSelectedItemChanged: (i) =>
                    setState(() => age = i),
                childDelegate:
                ListWheelChildBuilderDelegate(
                  childCount: 100,
                  builder: (context, index) => Center(
                    child: Text(index.toString(),
                        style: TextStyle(
                            fontSize:
                            index == age ? 40 : 20)),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// ================= BLOOD =================
  Widget buildBloodPage() {
    String blood = "A";
    String rh = "+";

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [

            const Text("Nhóm máu của bạn ?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            Row(
              children: ["A","B","AB","O"].map((e) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => blood = e),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: blood == e
                            ? Colors.blue
                            : Colors.grey.shade300,
                      ),
                      child: Center(child: Text(e)),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            Text("$blood$rh",
                style: const TextStyle(fontSize: 80)),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => rh = "+"),
                    child: const Text("+"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => rh = "-"),
                    child: const Text("-"),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  /// ================= FITNESS =================
  Widget buildFitnessPage() {
    int level = 3;

    final desc = [
      "Ít vận động",
      "Nhẹ",
      "Trung bình",
      "Thường xuyên",
      "Cường độ cao"
    ];

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [

            const Text("Mức độ thể chất hiện tại của bạn là gì?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            Image.asset("assets/nangta.png", height: 180),

            Row(
              children: List.generate(5, (i) {
                final index = i + 1;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => level = index),
                    child: Container(
                      height: 50,
                      color: level == index
                          ? Colors.blue
                          : Colors.grey.shade300,
                    ),
                  ),
                );
              }),
            ),

            Text(desc[level - 1])
          ],
        );
      },
    );
  }

  /// ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (i) {
                setState(() {
                  index = i;
                  selected.clear();
                });
              },
              children: [
                buildOptionPage("Mục tiêu sức khỏe của bạn là gì?", [
                  "Khỏe mạnh",
                  "Giảm cân",
                  "Nhắc thuốc",
                  "Thử app"
                ]),
                buildGenderPage(),
                buildWeightPage(),
                buildAgePage(),
                buildBloodPage(),
                buildFitnessPage(),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: next,
            child: const Text("Tiếp tục"),
          )
        ],
      ),
    );
  }
}