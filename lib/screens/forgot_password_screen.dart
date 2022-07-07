import 'package:auth_test/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/utilities.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isAuto = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade700,
        title: Text('Reset Password'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            children: [
              SizedBox(height: height / 30),
              Text(
                'Receive an email to reset your password',
                style: greyTextStyle(height),
              ),
              CustomTextField(
                autoValidateMode:
                    isAuto ? AutovalidateMode.onUserInteraction : null,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
                controller: emailController,
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                height: height,
                icon: Icons.alternate_email,
              ),
              SizedBox(height: height / 40),
              CustomButton(
                padding: EdgeInsets.symmetric(vertical: height / 60),
                color: Colors.blueGrey.shade600,
                widget: Text(
                  'Reset Email',
                  style: greyTextStyle(height).copyWith(color: Colors.white),
                ),
                onTap: resetEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future resetEmail() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      setState(() {
        isAuto = true;
      });
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      Utilities.showSnackBar('Password Reset Email Sent!');
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Utilities.showSnackBar(e.message!);
      Navigator.pop(context);
    }
  }
}
