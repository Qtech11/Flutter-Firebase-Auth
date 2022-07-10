import '../constants_styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key? key,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    required this.controller,
    this.autoValidateMode,
    this.icon,
    this.iconButton,
    required this.height,
  }) : super(key: key);

  final String? hintText;
  final TextInputType? keyboardType;
  bool obscureText;
  TextEditingController controller;
  String? Function(String? text)? validator;
  AutovalidateMode? autoValidateMode;
  IconData? icon;
  IconButton? iconButton;
  double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height / 60),
      child: TextFormField(
        autovalidateMode: autoValidateMode,
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: greyTextStyle(height).copyWith(fontSize: height / 55),
          icon: Icon(
            icon,
            size: height / 30,
          ),
          suffixIcon: iconButton,
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        ),
      ),
    );
  }
}
