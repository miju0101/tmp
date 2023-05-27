import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserService with ChangeNotifier {
  User? currentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = await GoogleAuthProvider.credential(
        idToken: googleAuth!.idToken, accessToken: googleAuth!.accessToken);

    UserCredential myInfo =
        await FirebaseAuth.instance.signInWithCredential(credential);

    FirebaseFirestore.instance.collection("users").doc(myInfo.user!.uid).set({
      "uid": myInfo.user!.uid,
      "email": myInfo.user!.email,
      "name": myInfo.user!.displayName,
      "profile_img": myInfo.user!.photoURL,
    });
  }

  Future<DocumentSnapshot> getMyInfo(String uid) {
    return FirebaseFirestore.instance.collection("users").doc(uid).get();
  }
}
