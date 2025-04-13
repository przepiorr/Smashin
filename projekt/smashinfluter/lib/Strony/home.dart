import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'graj.dart';
import 'turniej.dart';
import 'grupy.dart';
import '../logowanie/profil.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    GrajPage(),
    TurniejPage(),
    GrupyPage(),
  ];

  final ProfilPage _profilePage = ProfilPage();

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showProfilePage() {
    setState(() {
      _selectedIndex = -1;
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _profilePage),
    );
      FirebaseAuth.instance.signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smashin'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: const Color.fromARGB(140, 1, 128, 239),
        actions: [
          IconButton(
            onPressed: _showProfilePage,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 0, 75, 141),
        child: Column(
          
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
              ),
              child: Icon(Icons.home),
            ),
             ListTile(
              title: const Text('Home'),
              onTap: ()
              {
                Navigator.pop(context);
              },
            ),
            const ListTile(
              title: Text('Profil'),
              onTap: null,
            ),
            const ListTile(
              title: Text('Korty'),
              onTap: null,
            ),
          ],
        )
      ),
      body: _selectedIndex == -1 ? _profilePage : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(140, 1, 128, 239),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_tennis),
            label: 'Graj',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_baseball),
            label: 'Turniej',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Forum',
          ),
        ],
        currentIndex: _selectedIndex == -1 ? 0 : _selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
