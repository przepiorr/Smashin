import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:smashinfluter/Strony/Firebase_user/user_log.dart';


class NotatkaService {
// Dodawanie notatki
  static Future<void> addNotatka(String note) async {
    String? login = await FirebaseOpcje.sprawdzLogin();
    if (login == null) return;

    try {
// Dodanie notatki
      await FirebaseOpcje.notatka.add({
        'note': note,
        'timestamp': DateFormat('HH:mm dd-MM-yyyy').format(DateTime.now()),
        'login': login,
      });
      FirebaseOpcje.showToast('Notatka została dodana!', backgroundColor: Colors.green);
    } catch (e) {
      FirebaseOpcje.showToast('Błąd dodawania notatki: $e', backgroundColor: Colors.red);
    }
  }

  static Future<void> addKomentarz(String notatkaId, String komentarz) async {
    String? login = await FirebaseOpcje.sprawdzLogin();
    if (login == null) return;

    try {
// Dodanie komentarza
      CollectionReference komentarze = FirebaseOpcje.notatka.doc(notatkaId).collection(
          'Komentarz');
      await komentarze.add({
        'login': login,
        'komentarz': komentarz,
      });
      FirebaseOpcje.showToast('Komentarz dodany!', backgroundColor: Colors.green);
    } catch (e) {
      FirebaseOpcje.showToast('Błąd dodawania komentarza: $e', backgroundColor: Colors.red);
    }
  }

  static Stream<QuerySnapshot> getKomentarze(String noteId) {
    return FirebaseOpcje.notatka.doc(noteId).collection('Komentarz').snapshots();
  }


// Pobieranie notatek (stream)
  static Stream<QuerySnapshot> getNotatka() {
    return FirebaseOpcje.notatka.orderBy('timestamp', descending: true).snapshots();
  }

}