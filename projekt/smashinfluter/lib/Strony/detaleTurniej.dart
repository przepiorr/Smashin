import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Firebase_main.dart';

class TurniejDetailsPage extends StatelessWidget {
  final String turniejId;
  final DocumentSnapshot turniejData;

  const TurniejDetailsPage({required this.turniejId, required this.turniejData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(turniejData['Turniej']),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Turniej')
            .doc(turniejId)
            .collection('gracze')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final players = snapshot.data!.docs;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Twórca: ${turniejData['login']}',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder<String?>(
                      future: FirebaseOpcje.sprawdzLogin(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (userSnapshot.hasData && userSnapshot.data == turniejData['login']) {
                         return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'Dodaj mecze', 
                            ),
                            SizedBox(height: 10),
                            IconButton(
                              icon: Icon(Icons.flag),
                              onPressed: () {
                                FirebaseOpcje.startturniej(turniejId);
                              },
                            ),
                          ],
                          );
                        } else {
                          return IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance.collection('Turniej').doc(turniejId).collection('gracze').doc(turniejData['login']).delete();
                            },
                            icon: Icon(Icons.output_sharp),
                          );
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Text(
                  'Utworzono: ${turniejData['timestamp']}',
                  style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Gracze:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      return ListTile(
                        title: Text(player['login'] + ' Punkty : ' + player['punkty'].toString()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                // Wyświetlanie meczów
                Text(
                  'Mecze:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Turniej')
                      .doc(turniejId)
                      .collection('mecze')
                      .snapshots(),
                  builder: (context, matchSnapshot) {
                    if (!matchSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final matches = matchSnapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // To prevent scrolling inside the ListView
                      itemCount: matches.length,
                      itemBuilder: (context, index) {
                        final match = matches[index];
                        final players = match['players'] as List<dynamic>;
                        final result = match['Punkty pary 1'];
                        final result2 = match['Punkty pary 2'];

                        TextEditingController result1Controller = TextEditingController();
                        TextEditingController result2Controller = TextEditingController();

                        // Jeśli wynik jest dostępny, wstawiamy go do TextField
                        if (result != null) {
                          result1Controller.text = result.toString();
                          result2Controller.text = result2.toString();
                        }

                        return ListTile(
                          title: Text('Mecz ${index + 1}'),
                          subtitle: Text('Gracze: ${players.join(', ')}'),
                          trailing: match['scoreSaved'] == true
                              ? Text('Wynik: $result : $result2')
                              : Row(
                                  mainAxisSize: MainAxisSize.min, // Dostosowanie szerokości Row do zawartości
                                  children: [
                                    SizedBox(
                                      width: 50, // Szerokość pola tekstowego
                                      child: TextField(
                                        controller: result1Controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(hintText: 'Wynik 1'),
                                      ),
                                    ),
                                    SizedBox(width: 8), // Odstęp między polami
                                    SizedBox(
                                      width: 50,
                                      child: TextField(
                                        controller: result2Controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(hintText: 'Wynik 2'),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.save),
                                      onPressed: () async {
                                        await FirebaseOpcje.zapiszWynik(
                                          turniejId: turniejId,
                                          matchId: match.id,
                                          result1Text: result1Controller.text,
                                          result2Text: result2Controller.text,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                        );

                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
