import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageMatchController extends GetxController {
  final images = <String>[].obs; // shuffled images
  final revealed = <bool>[].obs;
  final highlightStates = <int, Color?>{}.obs;

  final selectedIndexes = <int>[].obs;
  var score = 0.obs;
  var timeElapsed = 0.obs;
  var isBusy = false.obs;

  Timer? _timer;

  final _allImages = [
    'https://picsum.photos/id/1011/400/400', // A
    'https://picsum.photos/id/1015/400/400', // B
    'https://picsum.photos/id/1025/400/400', // C
    'https://picsum.photos/id/1035/400/400', // D
  ];

  @override
  void onInit() {
    super.onInit();
    startGame();
  }

  void startGame() {
    // stop any old timer
    _timer?.cancel();

    // create pairs & shuffle
    final pairs = [..._allImages, ..._allImages]..shuffle();
    images.assignAll(pairs);

    revealed.assignAll(List.filled(pairs.length, false));
    highlightStates.clear();
    selectedIndexes.clear();
    score.value = 0;
    timeElapsed.value = 0;

    // start timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeElapsed.value++;
    });
  }

  void onTileTap(int index, BuildContext context) async {
    if (isBusy.value || revealed[index]) return;

    revealed[index] = true;
    selectedIndexes.add(index);

    if (selectedIndexes.length == 2) {
      isBusy.value = true;
      final first = selectedIndexes[0];
      final second = selectedIndexes[1];
      bool isMatch = images[first] == images[second];

      if (isMatch) {
        score.value++;
        _showHighlight([first, second], success: true);
        if (score.value == _allImages.length) {
          _timer?.cancel();
          _showWinDialog(context);
        }
      } else {
        _showHighlight([first, second], success: false);
        await Future.delayed(const Duration(milliseconds: 800));
        revealed[first] = false;
        revealed[second] = false;
      }

      await Future.delayed(const Duration(milliseconds: 400));
      selectedIndexes.clear();
      isBusy.value = false;
    }
  }

  Future<void> _showHighlight(List<int> indexes, {required bool success}) async {
    for (var i in indexes) {
      highlightStates[i] = success ? Colors.green : Colors.red;
    }
    await Future.delayed(const Duration(milliseconds: 600));
    for (var i in indexes) {
      highlightStates[i] = null;
    }
  }

  void _showWinDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 28),
            SizedBox(width: 8),
            Text("You Win!"),
          ],
        ),
        content: Obx(() => Text(
              "Time: ${timeElapsed.value}s\nScore: ${score.value}",
              style: const TextStyle(fontSize: 16),
            )),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              startGame();
            },
            child: const Text(
              "Play Again",
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
