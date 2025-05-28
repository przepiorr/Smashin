import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smashinfluter/Strony/home.dart';

class UserService {
  static Future<void> updateUserData({
    required BuildContext context,
    required String login,
    required String email,
    required String newPassword,
    required String repeatPassword,
  }) async {
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    final uid = user?.uid;

    if (user == null || uid == null) {
      Fluttertoast.showToast(
        msg: "Nie jesteś zalogowany.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (newPassword != repeatPassword) {
      Fluttertoast.showToast(
        msg: "Hasła się różnią",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      // Sprawdź czy login jest zajęty przez innego użytkownika
      var loginSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('login', isEqualTo: login)
          .get();

      if (loginSnapshot.docs.any((doc) => doc.id != uid)) {
        Fluttertoast.showToast(
          msg: "Login jest już zajęty.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      // Sprawdź czy email jest zajęty przez innego użytkownika
      var emailSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (emailSnapshot.docs.any((doc) => doc.id != uid)) {
        Fluttertoast.showToast(
          msg: "Email jest już zajęty.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      // Zmiana hasła (jeśli podano)
      if (newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }

      // Zmiana loginu i emaila w bazie
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'login': login,
        'email': email,
      });

      // Zmiana emaila (z nowym API Firebase)
      if (email != user.email) {
        await user.verifyBeforeUpdateEmail(email);
        Fluttertoast.showToast(
          msg: "Wysłano email weryfikacyjny na nowy adres.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      Fluttertoast.showToast(
        msg: "Dane zaktualizowane pomyślnie",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: "Błąd: ${e.message}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
