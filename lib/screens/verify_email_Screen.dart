import 'dart:async';
import 'package:auth_test/colors.dart';
import 'package:auth_test/screens/home_page_screen.dart';
import 'package:auth_test/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../resources/firebase_methods.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isVerified = false;
  Timer? timer;

  @override
  void initState() {
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isVerified) {
      FirebaseMethods().sendEmailVerification();
      print('verification mail has been sent');
      timer = Timer.periodic(Duration(seconds: 5), (timer) {
        checkEmailVerified();
      });
    }
    super.initState();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return isVerified
        ? const HomePage()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Verify Email',
                style: whiteTextStyle(height),
              ),
              backgroundColor: appBarColor,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'An email verification link has been sent to your mail. Please verify your mail!',
                    style: greyTextStyle(height),
                  ),
                  SizedBox(height: height / 30),
                  CustomButton(
                    color: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(vertical: height / 60),
                    widget: Text(
                      'Resend link',
                      style: whiteTextStyle(height),
                    ),
                    onTap: () {
                      FirebaseMethods().sendEmailVerification();
                    },
                  ),
                  SizedBox(height: height / 30),
                  CustomButton(
                    color: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(vertical: height / 60),
                    widget: Text('cancel', style: whiteTextStyle(height)),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
