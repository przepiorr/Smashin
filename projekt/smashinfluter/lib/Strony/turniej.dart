import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'detaleTurniej.dart';
import 'Firebase_main.dart';

class TurniejTile extends StatelessWidget {
  final String turniejId;
  final DocumentSnapshot turniejData;

  const TurniejTile({required this.turniejId, required this.turniejData});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Turniej').doc(turniejId).collection('gracze').snapshots(),
      builder: (context, playerSnapshot) {
        if (!playerSnapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        // Liczba graczy w turnieju
        int numberOfPlayers = playerSnapshot.data!.docs.length;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TurniejDetailsPage(
                  turniejId: turniejId,
                  turniejData: turniejData,
                ),
              ),
            );
          },
          child: ListTile(
            contentPadding: EdgeInsets.all(8.0),
            title: Text(
              turniejData['Turniej'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 4.0,
                    children: [
                      Text(
                        'Twórca: ' + turniejData['login'],
                        style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                      ),
                      Text(
                        turniejData['timestamp'],
                        style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                      ),
                      Text(
                        'Liczba graczy: $numberOfPlayers / ${turniejData['limit']}',
                        style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.person_add_rounded),
                  color: Colors.red,
                  onPressed: () => FirebaseOpcje.addPlayerT(turniejId),
                ),
              ],
            ),

          ),
        );
      },
    );
  }
}

class TurniejPage extends StatelessWidget {
  final TextEditingController turniejController = TextEditingController();
  final TextEditingController limitController = TextEditingController();
  void dodaj(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
      AlertDialog(
  content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      TextField(
        controller: turniejController,
        decoration: InputDecoration(labelText: 'Nazwa turnieju'),
      ),
      TextField(
        controller: limitController,
        keyboardType: TextInputType.numberWithOptions(decimal: false),
        decoration: InputDecoration(labelText: 'Limit'),
      ),
    ],
  ),
        actions: [
          ElevatedButton(
            onPressed: () {
               final int? limit = int.tryParse(limitController.text) ?? 0;
              FirebaseOpcje.addTurniej(turniejController.text,limit);
              Navigator.pop(context);
            },
            child: Text('Dodaj'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Turnieje'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseOpcje.getTurniej(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot turniejData = snapshot.data!.docs[index];
              String turniejId = turniejData.id;
              return TurniejTile(
                turniejId: turniejId,
                turniejData: turniejData,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => dodaj(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue[400],
      ),
    );
  }
}
