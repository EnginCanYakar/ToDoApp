import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text YaziTipi(String text, double size, Color color) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: GoogleFonts.openSans(
        textStyle: TextStyle(
            fontSize: size, fontWeight: FontWeight.bold, color: color)),
  );
}

class TextfildController extends StatelessWidget {
  final label;
  final controller;
  final password;

  const TextfildController(
      {super.key,
      required this.label,
      this.controller,
      required this.password});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: password,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.openSans(
          textStyle: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none, // Cleaner appearance
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
