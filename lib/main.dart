import 'package:flutter/material.dart';
import 'package:wallpaper_app/main_page.dart';
import 'custom_scroll_behavior.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: CustomScrollBehavior(),
      home: MainPage(),
    );
  }
}
