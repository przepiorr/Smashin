import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class FirebaseOpcje {
  static final CollectionReference notatka = FirebaseFirestore.instance.collection('Notatki');
  static final CollectionReference users = FirebaseFirestore.instance.collection('users');
  static final CollectionReference turniej = FirebaseFirestore.instance.collection('Turniej');

  // Funkcja do wyświetlania Toast
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
    // Pobranie danych użytkownika z kolekcji "users"
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

  // Dodawanie notatki
  static Future<void> addNotatka(String note) async {
  String? login = await sprawdzLogin();
  if (login == null) return;

  try {
    // Dodanie notatki
    await notatka.add({
      'note': note,
      'timestamp': DateFormat('HH:mm:ss dd-MM-yyyy').format(DateTime.now()),
      'login': login,
    });
    showToast('Notatka została dodana!', backgroundColor: Colors.green);
  } catch (e) {
    showToast('Błąd dodawania notatki: $e', backgroundColor: Colors.red);
  }
}

  static Future<void> addKomentarz(String notatkaId, String komentarz) async {
  String? login = await sprawdzLogin();
  if (login == null) return;

  try {
    // Dodanie komentarza
    CollectionReference komentarze = notatka.doc(notatkaId).collection('Komentarz');
    await komentarze.add({
      'login': login,
      'komentarz': komentarz,
    });
    showToast('Komentarz dodany!', backgroundColor: Colors.green);
  } catch (e) {
    showToast('Błąd dodawania komentarza: $e', backgroundColor: Colors.red);
  }
}

static Stream<QuerySnapshot> getKomentarze(String noteId) {
  return notatka.doc(noteId).collection('Komentarz').snapshots();
}


  // Pobieranie notatek (stream)
  static Stream<QuerySnapshot> getNotatka() {
    return notatka.orderBy('timestamp', descending: true).snapshots();
  }






  // Dodanie turnieju
  static Future<void> addTurniej(String Turniej, int? limit) async {
  try {
    // Wywołanie sprawdzLogin
    String? login = await sprawdzLogin();
    if (login == null) return; // Jeśli login jest null, kończymy wykonanie

    // Dodanie turnieju
    await turniej.add({
      'Turniej': Turniej,
      'timestamp': DateFormat('HH:mm:ss dd-MM-yyyy').format(DateTime.now()),
      'login': login,
      'limit': limit,
    });

    showToast('Turniej został utworzony!', backgroundColor: Colors.green);
  } catch (e) {
    showToast('Błąd dodawania turnieju: $e', backgroundColor: Colors.red);
  }
}

// Dodanie gracza do turnieju z limitem uczestników ustawionym na 8
static Future<void> addPlayerT(String turniejId) async {
  String? login = await sprawdzLogin();
  if (login == null) return;

  try {
    // Odwołanie do podkolekcji "gracze"
    CollectionReference gracze = turniej.doc(turniejId).collection('gracze');

    // Sprawdzenie, czy użytkownik już jest w turnieju
    QuerySnapshot existingPlayer = await gracze.where('login', isEqualTo: login).get();
    if (existingPlayer.docs.isNotEmpty) {
      showToast('Już jesteś zapisany do turnieju!', backgroundColor: Colors.orange);
      return;
    }
    DocumentSnapshot turniejDoc = await turniej.doc(turniejId).get();
    final int limitUczestnikow = turniejDoc['limit'] ?? 8;
    // Sprawdzenie liczby uczestników
    QuerySnapshot playersCount = await gracze.get();
    if (playersCount.docs.length >= limitUczestnikow) {
      showToast('Limit uczestników (8) został osiągnięty!', backgroundColor: Colors.red);
      return;
    }

    // Dodanie gracza z loginem jako ID dokumentu
    await gracze.doc(login).set({
      'login': login,
      'punkty': 0,
    });
    showToast('Zostałeś dodany do turnieju!', backgroundColor: Colors.green);
  } catch (e) {
    showToast('Błąd dodawania zawodnika do turnieju: $e', backgroundColor: Colors.red);
  }
}
static Future<void> delplayer(String turniejId) async {
  String? login = await sprawdzLogin();
  if (login == null) return;

  try {
    CollectionReference gracze = turniej.doc(turniejId).collection('gracze');

    // Check if the player is in the tournament
    QuerySnapshot existingPlayer = await gracze.where('login', isEqualTo: login).get();
    if (existingPlayer.docs.isEmpty) {
      showToast('Nie jesteś zapisany do tego turnieju!', backgroundColor: Colors.orange);
      return;
    }

    // Remove the player from the tournament
    await gracze.doc(existingPlayer.docs.first.id).delete();
    showToast('Zostałeś usunięty z turnieju!', backgroundColor: Colors.green);
  } catch (e) {
    showToast('Błąd usuwania zawodnika z turnieju: $e', backgroundColor: Colors.red);
  }
}

static Future<void> startturniej(String turniejId) async {
  try {
    // Get the collection reference for players in the tournament
    CollectionReference gracze = turniej.doc(turniejId).collection('gracze');

    // Get the list of players in the tournament
    QuerySnapshot playersSnapshot = await gracze.get();
    if (playersSnapshot.docs.length < 4) {
      showToast('Za mało graczy, aby rozpocząć turniej!', backgroundColor: Colors.red);
      return;
    }

    // Ensure the number of players is divisible by 4 (for matches with 4 players each)
    if (playersSnapshot.docs.length % 4 != 0) {
      showToast('Liczba graczy musi być podzielna przez 4!', backgroundColor: Colors.red);
      return;
    }

    // Using map to extract player logins
    List<String> playerLogins = playersSnapshot.docs
        .map((doc) => doc['login'] as String)
        .toList();

    playerLogins.shuffle();
    CollectionReference matchCollection = turniej.doc(turniejId).collection('mecze');

    for (int i = 0; i < playerLogins.length; i += 4) {
      // Select 4 players for the match
      List<String> matchPlayers = playerLogins.sublist(i, i + 4);
      await matchCollection.add({
        'players': matchPlayers,
        'result': {
          'player1': 0, 
          'player2': 0,
          'player3': 0,
          'player4': 0,
        },
        'Punkty pary 1': 0,
        'Punkty pary 2': 0,
        'scoreSaved': false,
      });
    }

    // Show success toast
    showToast('Turniej został rozpoczęty, mecze zostały przydzielone!', backgroundColor: Colors.green);

  } catch (e) {
    showToast('Błąd przy rozpoczynaniu turnieju: $e', backgroundColor: Colors.red);
  }
}

static Future<void> zapiszWynik({
  required String turniejId,
  required String matchId,
  required String result1Text,
  required String result2Text,
}) async {
  try {
    // Konwersja wyników
    final result1 = int.tryParse(result1Text);
    final result2 = int.tryParse(result2Text);

    if (result1 == null || result2 == null) {
      showToast('Podaj poprawny wynik!', backgroundColor: Colors.red);
      return;
    }

    // Sprawdzanie, czy wynik nie przekracza 21 punktów
    if (result1 > 21 || result2 > 21) {
      showToast('Wynik nie może przekraczać 21 punktów!', backgroundColor: Colors.red);
      return;
    }

    // Pobranie meczu, aby uzyskać graczy
    final matchDoc = await FirebaseFirestore.instance
        .collection('Turniej')
        .doc(turniejId)
        .collection('mecze')
        .doc(matchId)
        .get();

    if (!matchDoc.exists) {
      showToast('Mecz nie istnieje!', backgroundColor: Colors.red);
      return;
    }

    final matchData = matchDoc.data() as Map<String, dynamic>;
    final players = matchData['players'] as List<dynamic>;

    // Aktualizacja wyniku meczu
    await FirebaseFirestore.instance
        .collection('Turniej')
        .doc(turniejId)
        .collection('mecze')
        .doc(matchId)
        .update({
      'Wynik meczu': '$result1 : $result2',
      'Punkty pary 1': result1,
      'Punkty pary 2': result2,
      'scoreSaved': true, // Oznaczenie wyniku jako zapisanego
    });

    // Aktualizacja punktów graczy
    for (int i = 0; i < players.length; i++) {
      final points = (i < 2) ? result1 : result2; // Pierwsza para dostaje result1, druga result2
      await FirebaseFirestore.instance
          .collection('Turniej')
          .doc(turniejId)
          .collection('gracze')
          .doc(players[i])
          .update({
        'punkty': FieldValue.increment(points),
      });
    }

    showToast('Wynik zapisany i punkty zaktualizowane!', backgroundColor: Colors.green);
  } catch (e) {
    showToast('Błąd: $e', backgroundColor: Colors.red);
  }
}



  // Pobieranie turniejów (stream)
  static Stream<QuerySnapshot> getTurniej() {
    return turniej.orderBy('timestamp', descending: true).snapshots();
  }
}

