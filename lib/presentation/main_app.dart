import 'package:findemy_mobile/core/components/bottom_navigation_bar.dart';
import 'package:findemy_mobile/presentation/academy_page/view/academy_page.dart';
import 'package:findemy_mobile/presentation/main_page/view/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  int currentIndex = 0;

  final List<GlobalKey<NavigatorState>> navigatorKeys = List.generate(
    3,
        (_) => GlobalKey<NavigatorState>(),
  );

  void _onTap(int index) {
    if (index == currentIndex) {
      navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => currentIndex = index);
    }
  }

  Widget _buildOffstageNavigator(int index, Widget page) {
    return Offstage(
      offstage: currentIndex != index,
      child: Navigator(
        key: navigatorKeys[index],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (_) => page,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildOffstageNavigator(0, const MainPage()),
            _buildOffstageNavigator(1, const AcademyPage()),
            _buildOffstageNavigator(2, const Placeholder()),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onTap,
      ),
    );
  }
}