import 'dart:io' show File;

import '../constants_styles.dart';
import 'package:auth_test/main.dart';
import 'package:flutter/material.dart';
import 'package:auth_test/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../resources/firebase_methods.dart';
import '../widgets/utilities.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;
  bool visibility = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: const Icon(
          Icons.home,
          color: Colors.white,
        ),
        title: const Text('Home Page',
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome @ ${user.displayName}',
                style: greyTextStyle(height * 2),
              ),
              user.photoURL == null
                  ? image != null
                      ? Container()
                      : Container(
                          width: width / 2,
                          height: width / 2,
                          child: Image.asset('images/default_pic.jpeg'),
                        )
                  : Visibility(
                      visible: !visibility,
                      child: SizedBox(
                        width: width / 2,
                        height: width / 2,
                        child: Image.network(
                          user.photoURL.toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              image != null
                  ? Visibility(
                      visible: visibility,
                      child: SizedBox(
                        width: width / 2,
                        height: width / 2,
                        child: Image.file(
                          image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(height: height / 30),
              CustomButton(
                onTap: () async {
                  String im = await Utilities().pickImage(ImageSource.gallery);
                  print('great');
                  print('great');
                  setState(() {
                    image = File(im);
                    visibility = true;
                    print('greattt');
                  });
                },
                padding: const EdgeInsets.symmetric(vertical: 12),
                widget: Text(
                  'Change profile picture',
                  style: whiteTextStyle(height),
                ),
                color: Colors.blueGrey,
              ),
              SizedBox(height: height / 30),
              Visibility(
                visible: visibility,
                child: CustomButton(
                  onTap: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );
                    String url = await FirebaseMethods()
                        .uploadImageToStorage('profilePics', image!);
                    await user.updatePhotoURL(url);
                    visibility = false;
                    setState(() {});
                    navigatorKey.currentState!.pop();
                  },
                  padding: EdgeInsets.symmetric(vertical: height / 60),
                  widget: Text(
                    'Upload',
                    style: whiteTextStyle(height),
                  ),
                  color: Colors.blueGrey,
                ),
              ),
              Visibility(
                visible: visibility,
                child: SizedBox(height: height / 30),
              ),
              CustomButton(
                  color: Colors.blueGrey,
                  padding: EdgeInsets.symmetric(vertical: height / 60),
                  widget: Text(
                    'Sign out',
                    style: whiteTextStyle(height),
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    await GoogleSignIn().signOut();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
