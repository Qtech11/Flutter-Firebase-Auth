import 'dart:typed_data';

import 'package:auth_test/widgets/utilities.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auth_test/widgets/custom_button.dart';
import 'package:auth_test/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import '../constants_styles.dart';
import '../main.dart';
import 'package:icons_plus/icons_plus.dart';
import 'dart:io' show File, Platform;

import '../resources/firebase_methods.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onClickLogIn;
  SignUpPage({Key? key, required this.onClickLogIn}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isSeen = false;
  bool isAuto = false;
  bool isChecked = false;
  File? image;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
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
              //color: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              height: Platform.isIOS ? height * 0.9 : height * 0.96,
              child: Column(
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(),
                  ),
                  Stack(
                    children: [
                      image != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(image!),
                              radius: width / 6,
                            )
                          : CircleAvatar(
                              backgroundImage:
                                  const AssetImage('images/default_pic.jpeg'),
                              radius: width / 6,
                            ),
                      Positioned.fill(
                        left: width / 4,
                        top: width / 4,
                        child: IconButton(
                          iconSize: width / 15,
                          onPressed: () async {
                            String im = await Utilities()
                                .pickImage(ImageSource.gallery);
                            print('great');
                            setState(() {
                              image = File(im);
                            });
                          },
                          icon: Icon(
                            Icons.add_a_photo,
                            color: greyTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Container(),
                    flex: 2,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sign Up',
                      style: titleTextStyle(width),
                    ),
                  ),
                  Flexible(child: Container()),
                  CustomTextField(
                    autoValidateMode:
                        isAuto ? AutovalidateMode.onUserInteraction : null,
                    validator: (userName) =>
                        userName != null && userName.isEmpty
                            ? 'Please enter a valid username'
                            : null,
                    controller: userNameController,
                    hintText: 'Username',
                    keyboardType: TextInputType.text,
                    height: height,
                    icon: Icons.account_box_rounded,
                  ),
                  CustomTextField(
                    autoValidateMode:
                        isAuto ? AutovalidateMode.onUserInteraction : null,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Enter a valid email'
                            : null,
                    controller: emailController,
                    hintText: 'Email ID',
                    keyboardType: TextInputType.emailAddress,
                    height: height,
                    icon: Icons.alternate_email,
                  ),
                  CustomTextField(
                    autoValidateMode:
                        isAuto ? AutovalidateMode.onUserInteraction : null,
                    validator: (password) =>
                        password != null && password.length < 6
                            ? 'Password must be greater than six characters'
                            : null,
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: isSeen ? false : true,
                    height: height,
                    icon: CupertinoIcons.lock_shield,
                    iconButton: IconButton(
                      icon: isSeen
                          ? Icon(Icons.visibility_off_outlined)
                          : Icon(Icons.visibility_outlined),
                      onPressed: () {
                        setState(() {
                          isSeen = !isSeen;
                        });
                      },
                    ),
                  ),
                  Flexible(child: Container()),
                  Row(
                    children: [
                      SizedBox(
                        height: height / 40,
                        width: height / 30,
                        child: Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = !isChecked;
                              print(isChecked);
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: width / 30,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'By signing up you are agreeing to our ',
                                style: greyTextStyle(height),
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                                text: "Terms & Conditions",
                                style: blueTextStyle(height),
                              ),
                              TextSpan(
                                text: " and ",
                                style: greyTextStyle(height),
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                                text: "Privacy Policy",
                                style: blueTextStyle(height),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Flexible(child: Container()),
                  CustomButton(
                    padding: EdgeInsets.symmetric(vertical: height / 60),
                    color: buttonColor,
                    widget: Text(
                      'Sign Up',
                      style:
                          greyTextStyle(height).copyWith(color: Colors.white),
                    ),
                    onTap: signUpUser,
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
                        Text(
                          'Sign up with google',
                          style: greyTextStyle(height),
                        ),
                        Container(),
                      ],
                    ),
                    onTap: signInWithGoogle,
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  const Divider(
                    color: lightGreyColor,
                    height: 0,
                  ),
                  GestureDetector(
                    onTap: widget.onClickLogIn,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: height / 45),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already a user? ",
                            style: greyTextStyle(height),
                          ),
                          Text(
                            'Sign in',
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

  Future signUpUser() async {
    if (!isChecked) {
      Utilities.showSnackBar(
          'You have to agree to our Terms and Conditions/Privacy Policy');
      return;
    }
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
    await FirebaseMethods().createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      userName: userNameController.text.trim(),
      image: image,
    );
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
