import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:smashinfluter/Strony/Firebase_user/user_log.dart';

class TurniejService {
  static Future<void> addTurniej(String Turniej, int? limit, String? mode) async {
    try {
      String? login = await FirebaseOpcje.sprawdzLogin();
      if (login == null) return;

      await FirebaseOpcje.turniej.add({
        'Turniej': Turniej,
        'timestamp': DateFormat('HH:mm dd-MM-yyyy').format(DateTime.now()),
        'login': login,
        'limit': limit,
        'mode' : mode,
        'Runda': 0,
      });

      FirebaseOpcje.showToast('Turniej został utworzony!', backgroundColor: Colors.green);
    } catch (e) {
      FirebaseOpcje.showToast('Błąd dodawania turnieju: $e', backgroundColor: Colors.red);
    }
  }

  static Future<void> addPlayerT(String turniejId) async {
    String? login = await FirebaseOpcje.sprawdzLogin();
    if (login == null) return;

    try {
      CollectionReference gracze = FirebaseOpcje.turniej.doc(turniejId).collection('gracze');
      QuerySnapshot existingPlayer = await gracze.where('login', isEqualTo: login).get();

      if (existingPlayer.docs.isNotEmpty) {
        FirebaseOpcje.showToast('Już jesteś zapisany do turnieju!', backgroundColor: Colors.orange);
        return;
      }

      DocumentSnapshot turniejDoc = await FirebaseOpcje.turniej.doc(turniejId).get();
      final int limitUczestnikow = turniejDoc['limit'] ?? 8;
      QuerySnapshot playersCount = await gracze.get();

      if (playersCount.docs.length >= limitUczestnikow) {
        FirebaseOpcje.showToast('Limit uczestników ($limitUczestnikow) został osiągnięty!', backgroundColor: Colors.red);
        return;
      }

      await gracze.doc(login).set({
        'login': login,
        'punkty': 0,
      });
      FirebaseOpcje.showToast('Zostałeś dodany do turnieju!', backgroundColor: Colors.green);
    } catch (e) {
      FirebaseOpcje.showToast('Błąd dodawania zawodnika do turnieju: $e', backgroundColor: Colors.red);
    }
  }

  static Future<void> delplayer(String turniejId) async {
    String? login = await FirebaseOpcje.sprawdzLogin();
    if (login == null) return;

    try {
      CollectionReference gracze = FirebaseOpcje.turniej.doc(turniejId).collection('gracze');
      QuerySnapshot existingPlayer = await gracze.where('login', isEqualTo: login).get();

      if (existingPlayer.docs.isEmpty) {
        FirebaseOpcje.showToast('Nie jesteś zapisany do tego turnieju!', backgroundColor: Colors.orange);
        return;
      }

      await gracze.doc(existingPlayer.docs.first.id).delete();
      FirebaseOpcje.showToast('Zostałeś usunięty z turnieju!', backgroundColor: Colors.green);
    } catch (e) {
      FirebaseOpcje.showToast('Błąd usuwania zawodnika z turnieju: $e', backgroundColor: Colors.red);
    }
  }
  static Stream<QuerySnapshot> getTurniej() {
    return FirebaseOpcje.turniej.orderBy('timestamp', descending: true).snapshots();
  }
}
