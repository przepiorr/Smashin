import 'package:flutter/material.dart';
import 'package:smashinfluter/Strony/notatka/notatka_base.dart';
import 'package:smashinfluter/Strony/notatka/KomentNotatka.dart';

class NotatkaCard extends StatelessWidget {
  final dynamic note;

  const NotatkaCard({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noteId = note.id;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          title: Text(
            note['note'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  note['login'] ?? 'Unknown',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  note['timestamp'].toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                IconButton(
                  tooltip: 'Dodaj komentarz',
                  icon: Icon(Icons.comment, color: Colors.lightBlue[400]),
                  onPressed: () => _showAddKomentarzDialog(context, noteId),
                ),
              ],
            ),
          ),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            KomentarzeList(noteId: noteId),
          ],
        ),
      ),
    );
  }

  void _showAddKomentarzDialog(BuildContext context, String noteId) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController komentarzController = TextEditingController();
        return AlertDialog(
          title: const Text('Dodaj komentarz'),
          content: TextField(
            controller: komentarzController,
            decoration: const InputDecoration(hintText: 'Treść komentarza'),
            autofocus: true,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                NotatkaService.addKomentarz(noteId, komentarzController.text);
                Navigator.pop(context);
              },
              child: const Text('Dodaj'),
            ),
          ],
        );
      },
    );
  }
}
