import 'package:findemy_mobile/presentation/main_app.dart';
import 'package:findemy_mobile/presentation/on_boarding/view/on_boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:findemy_mobile/core/constants/color.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: FindemyColor.white,
      ),
      home: OnBoardingPage(),
    );
  }
}