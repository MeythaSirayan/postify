import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHeading extends StatelessWidget {
  final String? text;
  final double? size;
  final FontWeight? weight;
  final Color? color;

  const AppHeading({super.key, this.text, this.size, this.weight, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: GoogleFonts.playfairDisplay(
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}

class AppText extends StatelessWidget {
  final String? text;
  final double? size;
  final FontWeight? weight;
  final Color? color;

  const AppText({super.key, this.text, this.size, this.weight, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      style: GoogleFonts.lato(fontSize: size, fontWeight: weight, color: color),
    );
  }
}
