import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const blueTextColor = Color(0xff185DCF);
const greyTextColor = Color(0xff5E6D83);
const lightGreyColor = Color(0xffeaebed);
const buttonColor = Color(0xff0065FF);
Color appBarColor = Colors.blueGrey.shade700;

TextStyle blueTextStyle(double height) {
  return GoogleFonts.lora(
    fontSize: height / 55,
    color: blueTextColor,
    fontWeight: FontWeight.w500,
  );
}

TextStyle greyTextStyle(double height) {
  return GoogleFonts.lora(
    fontSize: height / 55,
    color: greyTextColor,
    fontWeight: FontWeight.w400,
  );
}

TextStyle whiteTextStyle(double height) {
  return GoogleFonts.lora(
    fontSize: height / 55,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );
}

TextStyle titleTextStyle(double width) {
  return GoogleFonts.lora(
    fontSize: width / 12,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );
}
// 0xffF1F5F6
