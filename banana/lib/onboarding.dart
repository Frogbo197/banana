import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salud_tlsk_ai/wrapper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController controller = PageController();
  int index = 0;
  Set<String> selectedGoal = {};
  String gender = "";
  double weight = 60;
  int age = 18;
  String blood = "A";
  String rh = "+";
  int fitnessLevel = 3;

  /// NEXT
  void next() async {
    if (index == 5) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('doneOnboarding', true);

      try {
        await http.post(
          Uri.parse("http://10.0.2.2:8001/api/onboarding"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": FirebaseAuth.instance.currentUser?.email,
            "gender": gender,
            "weight": weight,
            "age": age,
            "blood": "$blood$rh",
            "fitness": fitnessLevel,
            "goal": selectedGoal.toList(),
          }),
        );
      } catch (e) {
        print("Lỗi MySQL: $e");
      }

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

  /// OPTION PAGE
  Widget buildOptionPage(String title, List<String> options) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          ...options.map((e) {
            final isSelected = selectedGoal.contains(e);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedGoal.remove(e);
                  } else {
                    selectedGoal.add(e);
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF2F6FED)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e,
                        style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.black)),
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

  /// GENDER
  Widget buildGenderPage() {
    final PageController pageController =
    PageController(viewportFraction: 0.7);

    final data = [
      {"label": "Nam", "image": "assets/nam.jpg", "color": Colors.blue},
      {"label": "Nữ", "image": "assets/nu.jpg", "color": Colors.pink},
      {"label": "Khác", "image": "assets/khac.jpg", "color": Colors.purple},
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("Giới tính của bạn?",
              style:
              TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

          const SizedBox(height: 30),

          Expanded(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (i) {
                setState(() {
                  gender = data[i]["label"] as String;
                });
              },
              itemCount: data.length,
              itemBuilder: (context, i) {
                final item = data[i];
                return Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: item["color"] as Color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(item["label"] as String,
                          style:
                          const TextStyle(color: Colors.white)),
                      Expanded(
                        child: Image.asset(
                          item["image"] as String,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// WEIGHT
  Widget buildWeightPage() {
    return Column(
      children: [
        const Text("Cân nặng?",
            style:
            TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

        Text(weight.toInt().toString(),
            style: const TextStyle(fontSize: 40)),

        Expanded(
          child: ListWheelScrollView.useDelegate(
            itemExtent: 60,
            onSelectedItemChanged: (i) =>
                setState(() => weight = i.toDouble()),
            childDelegate:
            ListWheelChildBuilderDelegate(
              childCount: 150,
              builder: (context, i) => Center(
                child: Text(i.toString()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// AGE
  Widget buildAgePage() {
    return Column(
      children: [
        const Text("Tuổi?",
            style:
            TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

        Expanded(
          child: ListWheelScrollView.useDelegate(
            itemExtent: 80,
            onSelectedItemChanged: (i) =>
                setState(() => age = i),
            childDelegate:
            ListWheelChildBuilderDelegate(
              childCount: 100,
              builder: (context, i) => Center(
                child: Text(i.toString()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// BLOOD
  Widget buildBloodPage() {
    return Column(
      children: [
        const Text("Nhóm máu?",
            style:
            TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

        Row(
          children: ["A", "B", "AB", "O"].map((e) {
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => blood = e),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: blood == e
                      ? Colors.blue
                      : Colors.grey.shade300,
                  child: Center(child: Text(e)),
                ),
              ),
            );
          }).toList(),
        ),

        Text("$blood$rh",
            style: const TextStyle(fontSize: 60)),

        Row(
          children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () =>
                        setState(() => rh = "+"),
                    child: const Text("+"))),
            Expanded(
                child: ElevatedButton(
                    onPressed: () =>
                        setState(() => rh = "-"),
                    child: const Text("-"))),
          ],
        )
      ],
    );
  }

  /// FITNESS
  Widget buildFitnessPage() {
    return Column(
      children: [
        const Text("Mức độ thể chất?",
            style:
            TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

        Image.asset("assets/nangta.png", height: 150),

        Row(
          children: List.generate(5, (i) {
            final idx = i + 1;
            return Expanded(
              child: GestureDetector(
                onTap: () =>
                    setState(() => fitnessLevel = idx),
                child: Container(
                  height: 40,
                  color: fitnessLevel == idx
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(value: (index + 1) / 6),

            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (i) => setState(() => index = i),
                children: [
                  buildOptionPage("Mục tiêu?", [
                    "Khỏe mạnh",
                    "Giảm cân",
                    "Nhắc thuốc"
                  ]),
                  buildGenderPage(),
                  buildWeightPage(),
                  buildAgePage(),
                  buildBloodPage(),
                  buildFitnessPage(),
                ],
              ),
            ),
          ],
        ),
      ),

      // 👇 PHẢI ĐẶT Ở ĐÂY
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 10,
        ),
        child: SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: next,
            child: const Text("Tiếp tục"),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}