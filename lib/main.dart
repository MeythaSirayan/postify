import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/list_page.dart';

void main() {
  runApp(const PostifyApp());
}

class PostifyApp extends StatelessWidget {
  const PostifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'POSTIFY',
      theme: ThemeData(  
        useMaterial3: true,
        fontFamily: GoogleFonts.playfairDisplay().fontFamily,
        colorSchemeSeed: const Color(0xFF9B321A),
        scaffoldBackgroundColor: const Color(0xFFF8F5F2),
      ),
      home: const PostifyListPage(),
    );
  }
}
