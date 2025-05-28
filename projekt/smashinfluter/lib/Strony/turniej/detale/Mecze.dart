
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smashinfluter/Strony/turniej/detale/detale_base.dart';

class MatchListWidget extends StatelessWidget {
  final String turniejId;

  const MatchListWidget({super.key, required this.turniejId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Turniej')
          .doc(turniejId)
          .collection('mecze')
          .orderBy('runda')
          .snapshots(),
      builder: (context, matchSnapshot) {
        if (!matchSnapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final matches = matchSnapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            final players = match['players'] as List<dynamic>;
            final result = match['Punkty pary 1'];
            final result2 = match['Punkty pary 2'];
            final runda = match['runda'] ?? 0;

            TextEditingController result1Controller = TextEditingController();
            TextEditingController result2Controller = TextEditingController();

            if (result != null) {
              result1Controller.text = result.toString();
              result2Controller.text = result2.toString();
            }

            // Sprawdź, czy trzeba dodać nagłówek rundy
            bool showRundaHeader = false;
            if (index == 0 || (matches[index - 1]['runda'] != runda)) {
              showRundaHeader = true;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showRundaHeader)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Runda $runda',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ListTile(
                  title: Text('Mecz ${index + 1}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${players[0]}, ${players[1]}'),
                      Text('vs'),
                      Text('${players[2]}, ${players[3]}'),
                      SizedBox(height: 12),
                    ],
                  ),
                  trailing: match['scoreSaved'] == true
                      ? Text('Wynik: $result : $result2')
                      : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: result1Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: 'Wynik 1'),
                        ),
                      ),
                      SizedBox(width: 8),
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
                          await DetaleService.zapiszWynik(
                            turniejId: turniejId,
                            matchId: match.id,
                            result1Text: result1Controller.text,
                            result2Text: result2Controller.text,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );

      },
    );
  }
}
