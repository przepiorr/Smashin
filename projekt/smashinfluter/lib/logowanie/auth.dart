import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smashinfluter/Strony/home.dart';
import 'package:smashinfluter/logowanie/loading.dart';

class AuthService {

  Future<void> signup({
    required String email,
    required String password,
    required String login,
    required BuildContext context
  }) async {
    try {
      //ekran ładowania
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => LoadingScreen(message: 'Rejestracja...'),
      );

      var loginSnapshot = await FirebaseFirestore.instance.collection('users')
          .where('login', isEqualTo: login)
          .get();

      if (loginSnapshot.docs.isNotEmpty) {
        Navigator.pop(context); // Ukryj ekran ładowania
        Fluttertoast.showToast(msg: 'Login is already taken.');
        return;
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance.collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'email': email,
        'login': login,
      });

      Navigator.pop(context); // Ukryj ekran ładowania
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Ukryj ekran ładowania przy błędzie
      String message = e.code == 'weak-password'
          ? 'The password provided is too weak.'
          : e.code == 'email-already-in-use'
          ? 'An account already exists with that email.'
          : 'Błąd logowania';

      Fluttertoast.showToast(msg: message);
    }
  }


  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => LoadingScreen(message: 'Logowanie...'),
      );

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pop(context); // zamknij ekran ładowania
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // zamknij ekran ładowania
      String message = e.code == 'invalid-email'
          ? 'No user found for that email.'
          : e.code == 'invalid-credential'
          ? 'Wrong password provided for that user.'
          : 'Błąd logowania';

      Fluttertoast.showToast(msg: message);
    }
  }



}
