import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'image_match_controller.dart';

class ImageMatchScreen extends StatelessWidget {
  const ImageMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ImageMatchController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Match Game'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.startGame,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Score + Timer
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "⏱️ Time: ${controller.timeElapsed.value}s",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "🏆 Score: ${controller.score.value}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Obx(
                () => GridView.builder(
                  itemCount: controller.images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return Obx(() {
                      final revealed = controller.revealed[index];
                      final highlight = controller.highlightStates[index];

                      return GestureDetector(
                        onTap: () => controller.onTileTap(index, context),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: highlight != null
                                ? Border.all(color: highlight, width: 4)
                                : null,
                            color: Colors.grey[300],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (child, animation) {
                                // Flip style effect
                                final rotateAnim = Tween(
                                  begin: 1.0,
                                  end: 0.0,
                                ).animate(animation);
                                return AnimatedBuilder(
                                  animation: rotateAnim,
                                  builder: (context, childWidget) {
                                    final isUnder =
                                        (ValueKey(revealed) !=
                                        childWidget?.key);
                                    final value = isUnder
                                        ? min(rotateAnim.value, 1.0)
                                        : rotateAnim.value;
                                    return Transform(
                                      transform: Matrix4.rotationY(
                                        (1 - value) * 3.1416,
                                      ),
                                      alignment: Alignment.center,
                                      child: childWidget,
                                    );
                                  },
                                  child: child,
                                );
                              },
                              child: revealed
                                  ? Image.network(
                                      controller.images[index],
                                      fit: BoxFit.cover,
                                      key: const ValueKey(true),
                                    )
                                  : Container(
                                      key: const ValueKey(false),
                                      color: Colors.grey[800],
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "?",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
