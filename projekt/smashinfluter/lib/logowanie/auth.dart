import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smashinfluter/Strony/home.dart';

class AuthService {

  Future<void> signup({
  required String email,
  required String password,
  required String login,
  required BuildContext context
}) async {
  try {
    var loginSnapshot = await FirebaseFirestore.instance.collection('users').where('login', isEqualTo: login).get();

    if (loginSnapshot.docs.isNotEmpty) {

      Fluttertoast.showToast(
        msg: 'Login is already taken. Please choose another one.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return;
    }

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'email': email,
      'login': login,
    });
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  } on FirebaseAuthException catch (e) {
    String message = '';
    if (e.code == 'weak-password') {
      message = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      message = 'An account already exists with that email.';
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}


  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    
    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );

       await Future.delayed(const Duration(seconds: 1));

       Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch(e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }
       Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }


  }
