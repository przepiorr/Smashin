import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smashinfluter/Strony/turniej/detale/detaleTurniej.dart';
import 'package:smashinfluter/Strony/turniej/Turniej_base.dart';

class TurniejTile extends StatelessWidget {
  final String turniejId;
  final DocumentSnapshot turniejData;

  const TurniejTile({required this.turniejId, required this.turniejData});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Turniej')
          .doc(turniejId)
          .collection('gracze')
          .snapshots(),
      builder: (context, playerSnapshot) {
        if (!playerSnapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        int numberOfPlayers = playerSnapshot.data!.docs.length;
        int limit = turniejData['limit'];
        bool isFull = numberOfPlayers >= limit;

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
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    turniejData['Turniej'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[700]),
                      SizedBox(width: 4),
                      Text(
                        'Twórca: ${turniejData['login']}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.access_time, size: 16, color: Colors.grey[700]),
                      SizedBox(width: 4),
                      Text(
                        turniejData['timestamp'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  isFull
                      ? Row(
                    children: [
                      Icon(Icons.lock, size: 16, color: Colors.redAccent),
                      SizedBox(width: 6),
                      Text(
                        'Turniej pełny',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                      : Row(
                    children: [
                      Icon(Icons.group, size: 16, color: Colors.grey[700]),
                      SizedBox(width: 4),
                      Text(
                        'Gracze: $numberOfPlayers / $limit',
                        style:
                        TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: isFull
                        ? ElevatedButton.icon(
                      onPressed: null,
                      icon: Icon(Icons.close, size: 18),
                      label: Text("Pełny"),
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: Colors.grey[400],
                        disabledForegroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        textStyle: TextStyle(fontSize: 12),
                      ),
                    )
                        : ElevatedButton.icon(
                      onPressed: () => TurniejService.addPlayerT(turniejId),
                      icon: Icon(Icons.person_add, size: 18),
                      label: Text("Dołącz"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue[400],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        textStyle: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}