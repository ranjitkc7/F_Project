import 'package:flutter/material.dart';

class DetailsTable extends StatelessWidget {
  final String title;
  final String value;

  const DetailsTable({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}