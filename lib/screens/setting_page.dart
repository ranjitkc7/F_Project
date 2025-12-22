import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String selectedTheme = "light";
  String selectedlangugae = "english";

  final List<Map<String, dynamic>> settingsItems = [
    {"title": "Theme", "icon": Icons.color_lens},
    {"title": "Language", "icon": Icons.language},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 236, 213),
      body: Center(child: Text("Welocome!")),
    );
  }
}
