import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smashinfluter/Strony/Firebase_user/user_log.dart';

class DetaleService {

static Future<void> startturniej(String turniejId) async {
try {
CollectionReference gracze = FirebaseOpcje.turniej.doc(turniejId).collection('gracze');
QuerySnapshot playersSnapshot = await gracze.get();

DocumentSnapshot turniejSnapshot = await FirebaseOpcje.turniej.doc(turniejId).get();
int Nowround = (turniejSnapshot['runda'] ?? 0) + 1;


if (playersSnapshot.docs.length < 4) {
FirebaseOpcje.showToast('Za mało graczy, aby rozpocząć turniej!', backgroundColor: Colors.red);
return;
}

if (playersSnapshot.docs.length % 4 != 0) {
FirebaseOpcje.showToast('Liczba graczy musi być podzielna przez 4!', backgroundColor: Colors.red);
return;
}

List<String> playerLogins = playersSnapshot.docs.map((doc) => doc['login'] as String).toList();
playerLogins.shuffle();

CollectionReference matchCollection = FirebaseOpcje.turniej.doc(turniejId).collection('mecze');

for (int i = 0; i < playerLogins.length; i += 4) {
  List<String> matchPlayers = playerLogins.sublist(i, i + 4);
  await matchCollection.add({
    'runda': Nowround,
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
  }
  );
  }

await FirebaseOpcje.turniej.doc(turniejId).update({
  'runda': Nowround,
});

FirebaseOpcje.showToast('Turniej został rozpoczęty, mecze zostały przydzielone!', backgroundColor: Colors.green);
} catch (e) {
FirebaseOpcje.showToast('Błąd przy rozpoczynaniu turnieju: $e', backgroundColor: Colors.red);
}
}

static Future<void> zapiszWynik({
required String turniejId,
required String matchId,
required String result1Text,
required String result2Text,
}) async {
try {
final result1 = int.tryParse(result1Text);
final result2 = int.tryParse(result2Text);

if (result1 == null || result2 == null) {
FirebaseOpcje.showToast('Podaj poprawny wynik!', backgroundColor: Colors.red);
return;
}

  final turniejSnapshot = await FirebaseFirestore.instance.collection('Turniej').doc(turniejId).get();
  final tryb = turniejSnapshot['mode'];

  switch (tryb) {
    case 'Americano':
      if (result1 + result2 > 21) {
        FirebaseOpcje.showToast(
          'Suma punktów nie może przekraczać 21 punktów!',
          backgroundColor: Colors.red,
        );
        return;
      }
      break;

    case 'Clasic':
      if (result1 > 7 || result2 > 7) {
        FirebaseOpcje.showToast(
          'Maksymalnie 7 punktów na drużynę!',
          backgroundColor: Colors.red,
        );
        return;
      }
      break;

    default:
      FirebaseOpcje.showToast(
        'Nieznany tryb turnieju: $tryb',
        backgroundColor: Colors.orange,
      );
      return;
  }


final matchDoc = await FirebaseFirestore.instance
    .collection('Turniej')
    .doc(turniejId)
    .collection('mecze')
    .doc(matchId)
    .get();

if (!matchDoc.exists) {
FirebaseOpcje.showToast('Mecz nie istnieje!', backgroundColor: Colors.red);
return;
}

final matchData = matchDoc.data() as Map<String, dynamic>;
final players = matchData['players'] as List<dynamic>;

await matchDoc.reference.update({
'Wynik meczu': '$result1 : $result2',
'Punkty pary 1': result1,
'Punkty pary 2': result2,
'scoreSaved': true,
});

for (int i = 0; i < players.length; i++) {
final points = (i < 2) ? result1 : result2;
await FirebaseFirestore.instance
    .collection('Turniej')
    .doc(turniejId)
    .collection('gracze')
    .doc(players[i])
    .update({'punkty': FieldValue.increment(points)});
}

FirebaseOpcje.showToast('Wynik zapisany i punkty zaktualizowane!', backgroundColor: Colors.green);
} catch (e) {
FirebaseOpcje.showToast('Błąd: $e', backgroundColor: Colors.red);
}
}

static Stream<QuerySnapshot> getTurniej() {
return FirebaseOpcje.turniej.orderBy('timestamp', descending: true).snapshots();
}
}