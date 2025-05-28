import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smashinfluter/profiledit/profiledit.dart';
import 'package:smashinfluter/Strony/graj.dart';
import 'package:smashinfluter/Strony/turniej/turniej.dart';
import 'package:smashinfluter/Strony/notatka/Notatka.dart';
import '../logowanie/profil.dart';
import 'package:smashinfluter/style/styl.dart';

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
        backgroundColor: AppColor.background,
        actions: [
          IconButton(
            onPressed: _showProfilePage,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
          backgroundColor: AppColor.background.withAlpha(255),
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
            ListTile(
              title: Text('Profil'),
              onTap: () { Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PeditPage()),
              );}
              ,
            ),
          ],
        )
      ),
      body: _selectedIndex == -1 ? _profilePage : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.background,
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
