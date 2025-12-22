import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int selectedIndex = 0;

  final pages = [const HomePage(), const ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: pages[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 98, 8, 242),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 61, 59, 59),
        unselectedFontSize: 14,
        selectedFontSize: 15,
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: "Profile",
          ),
          
        ],
      ),
    );
  }
}