import 'package:flutter/material.dart';
import 'notatka_base.dart';

class KomentarzeList extends StatelessWidget {
  final String noteId;

  const KomentarzeList({Key? key, required this.noteId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: NotatkaService.getKomentarze(noteId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Brak komentarzy.', style: TextStyle(color: Colors.grey[600])),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final comment = snapshot.data!.docs[index];
            return ListTile(
              dense: true,
              leading: Icon(Icons.account_circle, color: Colors.lightBlue[300]),
              title: Text(comment['komentarz']),
              subtitle: Text(
                'Autor: ${comment['login']}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            );
          },
        );
      },
    );
  }
}
