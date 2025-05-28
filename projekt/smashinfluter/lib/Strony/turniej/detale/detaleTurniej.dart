import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smashinfluter/style/styl.dart';
import 'package:smashinfluter/Strony/home.dart';
import 'package:smashinfluter/Strony/Firebase_user/user_log.dart';
import 'package:smashinfluter/Strony/turniej/detale/detale_base.dart';
import 'package:smashinfluter/Strony/turniej/detale/Mecze.dart';

class TurniejDetailsPage extends StatelessWidget {
  final String turniejId;
  final DocumentSnapshot turniejData;

  const TurniejDetailsPage({required this.turniejId, required this.turniejData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(turniejData['Turniej']),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: AppColor.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Turniej')
            .doc(turniejId)
            .collection('gracze')
            .orderBy('punkty', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final players = snapshot.data!.docs;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Twórca i przycisk rozpoczęcia / wypisania
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.person, color: Colors.blueGrey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Twórca: ${turniejData['login']}',
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder<String?>(
                    future: FirebaseOpcje.sprawdzLogin(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }

                      if (userSnapshot.hasData && userSnapshot.data == turniejData['login']) {
                        return FutureBuilder<QuerySnapshot>(
                          future: FirebaseOpcje.turniej.doc(turniejId).collection('mecze').limit(1).get(),
                          builder: (context, matchSnapshot) {
                            if (matchSnapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              );
                            }
                            // Autor widzi przycisk zawsze
                            return Row(
                              children: [
                                const SizedBox(width: 12),
                                const Text('Dodaj mecze', style: TextStyle(fontSize: 14.0)),
                                IconButton(
                                  icon: const Icon(Icons.flag, color: Colors.blue),
                                  tooltip: "Rozpocznij turniej",
                                  onPressed: () {
                                    DetaleService.startturniej(turniejId);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return FutureBuilder<QuerySnapshot>(
                          future: FirebaseOpcje.turniej.doc(turniejId).collection('mecze').limit(1).get(),
                          builder: (context, matchSnapshot) {
                            if (matchSnapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              );
                            }

                            final bool hasMatches = matchSnapshot.data!.docs.isNotEmpty;

                            if (hasMatches) {
                              return const SizedBox.shrink();
                            } else {
                              return IconButton(
                                icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
                                tooltip: "Wypisz się z turnieju",
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('Turniej')
                                      .doc(turniejId)
                                      .collection('gracze')
                                      .doc(turniejData['login'])
                                      .delete();
                                },
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8.0),

              // Data utworzenia
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Utworzono: ${turniejData['timestamp']}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),
                ],
              ),

              Row(
                children: [
                  Icon(Icons.sports_esports, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Tryb: ${turniejData['mode']}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),
                ],
              ),

              const Divider(height: 32, thickness: 1),
              const Text('Gracze:', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: players.map((player) {
                    return ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(player['login']),
                      trailing: Text(
                        'Punkty: ${player['punkty']}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const Divider(height: 32, thickness: 1),

              // Mecze
              const Text('Mecze:', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              MatchListWidget(turniejId: turniejId),
            ],
          );
        },
      ),
    );
  }
}
