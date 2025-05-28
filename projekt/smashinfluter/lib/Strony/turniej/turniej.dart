import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smashinfluter/Strony/turniej/Turniej_base.dart';
import 'package:smashinfluter/Strony/turniej/Turniejcard.dart';

class TurniejPage extends StatefulWidget {
  @override
  _TurniejPageState createState() => _TurniejPageState();
}

class _TurniejPageState extends State<TurniejPage> {
  final TextEditingController turniejController = TextEditingController();
  int? selectedLimit;
  String? selectedMode;

  final List<int> limitOptions = [4 ,8, 16, 32];
  final List<String> modeOptions = ["Americano","Clasic"];
  final List<String> paryOpotions = ["Tak","Nie"];

  void dodaj(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: turniejController,
              decoration: InputDecoration(labelText: 'Nazwa turnieju'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Limit graczy:'),
                const SizedBox(width: 16),
                Expanded(
                  child:
                DropdownMenu<int>(
                  initialSelection: selectedLimit,
                  requestFocusOnTap: true,
                  enableFilter: false,
                  onSelected: (value) {
                    setState(() {
                      selectedLimit = value!;
                    });
                  },
                  dropdownMenuEntries: limitOptions
                      .map((limit) =>
                      DropdownMenuEntry<int>(value: limit, label: limit.toString()))
                      .toList(),
                ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                Text('Tryb gry:'),
                const SizedBox(width: 16),
                Expanded(child: DropdownMenu<String>(
                  initialSelection: selectedMode,
                  requestFocusOnTap: true,
                  enableFilter: false,
                  onSelected: (valuee) {
                    setState(() {
                      selectedMode = valuee!;
                    });
                  },
                  dropdownMenuEntries: modeOptions
                      .map((mode) =>
                      DropdownMenuEntry<String>(value: mode, label: mode.toString()))
                      .toList(),
                ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final limit = selectedLimit ?? 0;
              final mode = selectedMode ?? "Americano";
              TurniejService.addTurniej(turniejController.text, limit, mode);
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
        stream: TurniejService.getTurniej(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot turniejData = snapshot.data!.docs[index];
              return TurniejTile(
                turniejId: turniejData.id,
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
