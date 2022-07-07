import 'package:auth_test/colors.dart';
import 'package:auth_test/widgets/utilities.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auth_test/widgets/custom_button.dart';
import 'package:auth_test/widgets/custom_text_field.dart';
import 'package:auth_test/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:icons_plus/icons_plus.dart';
import '../resources/firebase_methods.dart';
import 'forgot_password_screen.dart';
import 'dart:io' show Platform;

class LoginPage extends StatefulWidget {
  final VoidCallback onClickSignUp;

  const LoginPage({Key? key, required this.onClickSignUp}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isSeen = false;
  bool isAuto = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              height: Platform.isIOS ? height * 0.9 : height * 0.96,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 16,
                    child: Container(),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login',
                      style: titleTextStyle(width),
                    ),
                  ),
                  SizedBox(
                    height: height / 40,
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
                    icon: Icons.alternate_email,
                    height: height,
                  ),
                  CustomTextField(
                    autoValidateMode:
                        isAuto ? AutovalidateMode.onUserInteraction : null,
                    validator: (password) =>
                        password != null && password.length < 6
                            ? 'Password must be greater than six characters'
                            : null,
                    controller: passwordController,
                    hintText: 'Enter your Password',
                    obscureText: isSeen ? false : true,
                    height: height,
                    icon: Icons.lock_outline,
                    iconButton: IconButton(
                      icon: isSeen
                          ? const Icon(Icons.visibility_off_outlined)
                          : const Icon(Icons.visibility_outlined),
                      onPressed: () {
                        setState(() {
                          isSeen = !isSeen;
                        });
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  GestureDetector(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          'Forgot Password?',
                          style: blueTextStyle(height),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  CustomButton(
                    padding: EdgeInsets.symmetric(vertical: height / 60),
                    color: buttonColor,
                    widget: Text(
                      'Log in',
                      style:
                          greyTextStyle(height).copyWith(color: Colors.white),
                    ),
                    onTap: logInUser,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height / 60),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            endIndent: 20,
                            color: lightGreyColor,
                          ),
                        ),
                        Text(
                          "OR",
                          style: greyTextStyle(height),
                        ),
                        const Expanded(
                          child: Divider(
                            indent: 20,
                            color: lightGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    padding: EdgeInsets.symmetric(vertical: height / 80),
                    color: lightGreyColor,
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BrandLogo(
                          BrandLogos.google,
                          size: height / 32,
                        ),
                        // SizedBox(width: width / 8),
                        Text(
                          'Sign in with google',
                          style: greyTextStyle(height),
                        ),
                        Container(),
                      ],
                    ),
                    onTap: signInWithGoogle,
                  ),
                  Flexible(
                    flex: 8,
                    child: Container(),
                  ),
                  const Divider(
                    color: lightGreyColor,
                    height: 0,
                  ),
                  GestureDetector(
                    onTap: widget.onClickSignUp,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: height / 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?  ",
                            style: greyTextStyle(height)
                                .copyWith(fontSize: height / 50),
                          ),
                          Text(
                            'Register',
                            style: blueTextStyle(height),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future logInUser() async {
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
    await FirebaseMethods().signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  void signInWithGoogle() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await FirebaseMethods().signInWithGoogle();
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
