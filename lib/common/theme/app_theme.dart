import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static var bgcolor = ThemeData(
    scaffoldBackgroundColor: Color(0xff121212),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.purpleAccent,
    ),
    primaryColor: Color(0xff121212),
    textTheme: TextTheme(
      headlineMedium: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          color: Colors.white, // Başlık için renk
        ),
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
  );
}
