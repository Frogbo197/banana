import 'package:flutter/material.dart';

class DrinkWaterPage extends StatefulWidget {
  const DrinkWaterPage({super.key});

  @override
  State<DrinkWaterPage> createState() => _DrinkWaterPageState();
}

class _DrinkWaterPageState extends State<DrinkWaterPage>
    with SingleTickerProviderStateMixin {

  double target = 2000; // mục tiêu (ml)
  double current = 0;   // đã uống

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 0,
      upperBound: 10,
    );
  }

  void addWater() async {
    final value = await showDialog<double>(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();

        return AlertDialog(
          title: const Text("Nhập lượng nước (ml)"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Ví dụ 200"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Huỷ"),
            ),
            ElevatedButton(
              onPressed: () {
                final v = double.tryParse(controller.text);
                Navigator.pop(context, v);
              },
              child: const Text("OK"),
            )
          ],
        );
      },
    );

    if (value != null) {
      setState(() {
        current += value;
        if (current > target) current = target;
      });

      _controller.forward(from: 0); // 🔥 animation nước
    }
  }

  void changeTarget() async {
    final value = await showDialog<double>(
      context: context,
      builder: (context) {
        TextEditingController controller =
        TextEditingController(text: target.toString());

        return AlertDialog(
          title: const Text("Đặt mục tiêu nước (ml)"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Huỷ"),
            ),
            ElevatedButton(
              onPressed: () {
                final v = double.tryParse(controller.text);
                Navigator.pop(context, v);
              },
              child: const Text("Lưu"),
            )
          ],
        );
      },
    );

    if (value != null) {
      setState(() => target = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    double remain = target - current;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Lượng nước hôm nay",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: changeTarget,
            icon: const Icon(Icons.more_horiz, color: Colors.black),
          )
        ],
      ),

      body: Column(
        children: [

          /// TEXT
          const SizedBox(height: 20),

          const Text(
            "Lượng nước hôm nay 💧",
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 10),

          Text(
            "${current.toInt()} ml",
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            "Còn ${remain.toInt()} ml",
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 20),

          /// WATER AREA
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [

                /// NỀN NƯỚC + ANIMATION
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Opacity(
                        opacity: 0.2 + (_controller.value / 50),
                        child: const Center(),
                      ),
                    );
                  },
                ),

                /// HÌNH CON RÁI CÁ
                Positioned(
                  bottom: 80,
                  child: Image.asset(
                    "assets/swim.png",
                    height: 200,
                  ),
                ),

                /// BUTTON +
                Positioned(
                  bottom: 20,
                  child: GestureDetector(
                    onTap: addWater,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: const Icon(Icons.add, size: 35),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}