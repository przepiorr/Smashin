import 'package:flutter/material.dart';
import 'Firebase_main.dart';

final TextEditingController notatka = TextEditingController();
final TextEditingController komentarz = TextEditingController();

class GrupyPage extends StatelessWidget {
  void dodaj(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: notatka,
          decoration: InputDecoration(hintText: 'Treść notatki'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              FirebaseOpcje.addNotatka(notatka.text);
              Navigator.pop(context);
            },
            child: Text('Dodaj'),
          ),
        ],
      ),
    );
  }

  void dodajkomentarz(BuildContext context, String noteId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: komentarz,
          decoration: InputDecoration(hintText: 'Treść komentarza'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              FirebaseOpcje.addKomentarz(noteId, komentarz.text);
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
      body: StreamBuilder(
        stream: FirebaseOpcje.getNotatka(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final note = snapshot.data!.docs[index];
              final noteId = note.id; // ID notatki
              return ExpansionTile(
                title: Text(
                  note['note'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      note['login'] ?? 'Unknown',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                    ),
                    Text(
                      note['timestamp'],
                      style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                    ),
                    IconButton(
                      icon: Icon(Icons.comment, color: Colors.lightBlue),
                      onPressed: () => dodajkomentarz(context, noteId),
                    ),
                  ],
                ),
                children: [
                  StreamBuilder(
                    stream: FirebaseOpcje.getKomentarze(noteId),
                    builder: (context, commentSnapshot) {
                      if (!commentSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (commentSnapshot.data!.docs.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Brak komentarzy.'),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: commentSnapshot.data!.docs.length,
                        itemBuilder: (context, commentIndex) {
                          final comment = commentSnapshot.data!.docs[commentIndex];
                          return ListTile(
                            title: Text(comment['komentarz']),
                            subtitle: Text('Autor: ${comment['login']}'),
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => dodaj(context),
        backgroundColor: Colors.lightBlue[400],
        child: const Icon(Icons.add),
      ),
    );
  }
}
