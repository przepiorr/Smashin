import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseOpcje {
  static final CollectionReference notatka =
  FirebaseFirestore.instance.collection('Notatki');
  static final CollectionReference users =
  FirebaseFirestore.instance.collection('users');
  static final CollectionReference turniej =
  FirebaseFirestore.instance.collection('Turniej');

  static void showToast(String message, {Color backgroundColor = Colors.black54}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  static Future<String?> sprawdzLogin() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showToast('Użytkownik nie jest zalogowany', backgroundColor: Colors.red);
      return null;
    }

    try {
      DocumentSnapshot userDoc = await users.doc(user.uid).get();
      if (userDoc.exists) {
        return userDoc['login'];
      } else {
        showToast('Nie znaleziono użytkownika w kolekcji "users"', backgroundColor: Colors.red);
      }
    } catch (e) {
      showToast('Błąd podczas pobierania danych użytkownika: $e', backgroundColor: Colors.red);
    }

    return null;
  }
}
