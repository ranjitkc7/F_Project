// ignore_for_file: deprecated_member_use

import 'package:att_app/theme_controller.dart';
import 'package:flutter/material.dart';
import '../widgets/button.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String selectedTheme = "light";
  String selectedLanguage = "english";

  final List<Map<String, dynamic>> settingsItems = [
    {"title": "Theme", "icon": Icons.color_lens},
    {"title": "Language", "icon": Icons.language},
    {"title": "Font Size", "icon": Icons.text_fields},
    {"title": "About App", "icon": Icons.info},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 98, 8, 242),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView.separated(
        itemCount: settingsItems.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = settingsItems[index];
          return ListTile(
            leading: Icon(
              item["icon"],
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(item["title"]),
            subtitle: getSubtitle(item["title"]),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => handleTap(item["title"]),
          );
        },
      ),
    );
  }

  Widget getSubtitle(String title) {
    switch (title) {
      case "Theme":
        return Text(selectedTheme);
      case "Language":
        return Text(selectedLanguage);
      case "Font Size":
        return const Text("Medium");
      default:
        return const SizedBox.shrink();
    }
  }

  void handleTap(String title) {
    switch (title) {
      case "Theme":
        showThemeDialog();
        break;
      case "Language":
        showLanguageDialog();
        break;
      case "Font Size":
        showFontSizeDialog();
        break;
      case "About App":
        openAboutDialog();
        break;
    }
  }

  void showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(6),
            height: 145,
            width: 400,
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Change Theme",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        themeNotifier.value = ThemeMode.light;
                        setState(() {
                          selectedTheme = "light";
                        });
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.light_mode, size: 24),
                      label: const Text(
                        "Light",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        themeNotifier.value = ThemeMode.dark;
                        setState(() {
                          selectedTheme = "dark";
                        });
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.dark_mode, size: 24),
                      label: const Text(
                        "Dark",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                CustomButton(
                  text: "Back",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Color.fromARGB(255, 98, 8, 242),
                  radius: 12,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showLanguageDialog() {
    final languages = [
      "English",
      "Nepali",
      "Hindi",
      "Spanish",
      "French",
      "German",
      "Chinese",
      "Japanese",
      "Korean",
      "Arabic",
    ];
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 10), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: 300,
            width: 300,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.dialogBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  "Select Language",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                    color: theme.textTheme.bodyLarge!.color,
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: ListView.builder(
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final language = languages[index];
                      final isSelected =
                          selectedLanguage.toLowerCase() ==
                          language.toLowerCase();

                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedLanguage = language.toLowerCase();
                          });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 8,
                          ),
                          child: Text(
                            language,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.normal,
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : theme.textTheme.bodyLarge!.color,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showFontSizeDialog() {}

  void openAboutDialog() {}
}
