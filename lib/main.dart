import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:findemy_mobile/core/constants/color.dart';
import 'package:findemy_mobile/services/api_services.dart';
import 'package:findemy_mobile/presentation/on_boarding/view/on_boarding_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken');
  if (token != null && token.isNotEmpty) {
    ApiServices.dio.options.headers['Authorization'] = 'Bearer $token';
  }

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
