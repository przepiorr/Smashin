import 'package:flutter/material.dart';
import 'package:smashinfluter/Strony/notatka/notatka_base.dart';
import 'package:smashinfluter/Strony/notatka/CardNotatka.dart';

class GrupyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Turnieje')),
      body: StreamBuilder(
        stream: NotatkaService.getNotatka(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Brak notatek. Dodaj nową!'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final note = snapshot.data!.docs[index];
              return NotatkaCard(note: note);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNotatkaDialog(context),
        backgroundColor: Colors.lightBlue[400],
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddNotatkaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController notatkaController = TextEditingController();
        return AlertDialog(
          title: const Text('Dodaj notatkę'),
          content: TextField(
            controller: notatkaController,
            decoration: const InputDecoration(hintText: 'Treść notatki'),
            autofocus: true,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                NotatkaService.addNotatka(notatkaController.text);
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
