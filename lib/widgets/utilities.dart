import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../constants_styles.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();

class Utilities {
  static showSnackBar(String message) {
    if (message == null) return;
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: appBarColor,
          content: Text(
            message,
            style: GoogleFonts.lora(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
  }

  pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image =
        await picker.pickImage(source: source, imageQuality: 20);

    if (image != null) {
      return image.path;
    }
  }
}
