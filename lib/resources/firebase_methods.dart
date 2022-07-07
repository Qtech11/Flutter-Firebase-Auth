import 'dart:io' show File;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';
import '../widgets/utilities.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(String childName, File image) async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    Reference ref =
        storage.ref().child(childName).child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount!.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      Utilities.showSnackBar(e.message!);
    }
  }

  Future createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String userName,
    File? image,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = _auth.currentUser!;
      await user.updateDisplayName(userName);
      if (image != null) {
        String url = await uploadImageToStorage('profilePics', image);
        await user.updatePhotoURL(url).whenComplete(() =>
            navigatorKey.currentState!.popUntil((route) => route.isFirst));
        ;
      }
    } on FirebaseAuthException catch (e) {
      Utilities.showSnackBar(e.message!);
    }
  }

  Future signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Utilities.showSnackBar(e.message!);
    }
  }

  Future sendEmailVerification() async {
    try {
      final user = _auth.currentUser;

      final actionCodeSettings = ActionCodeSettings(
        url:
            "https://authtesting.page.link/authTest" + "/?email=${user?.email}",
        iOSBundleId: "com.example.authTest",
        androidPackageName: "com.example.auth_test",
      );

      await user?.sendEmailVerification(actionCodeSettings);
    } on FirebaseAuthException catch (e) {
      Utilities.showSnackBar(e.message!);
      print(e.message);
    }
  }

  Future resetEmail({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      Utilities.showSnackBar('Password Reset Email Sent!');
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Utilities.showSnackBar(e.message!);
    }
  }
}
