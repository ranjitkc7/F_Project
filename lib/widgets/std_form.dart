import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final TextEditingController controller;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType keyboardType;

  const CustomInputField({
    super.key,
    required this.label,
    required this.controller,
    this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: onTap != null,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: icon != null ? Icon(icon) : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(width: 1),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }
}