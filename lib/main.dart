import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'image_match_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Match Game',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const ImageMatchScreen(),
    );
  }
}
