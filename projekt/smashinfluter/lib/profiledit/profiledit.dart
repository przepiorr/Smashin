import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smashinfluter/Strony/home.dart';
import 'package:smashinfluter/style/styl.dart';
import 'package:smashinfluter/profiledit/editfirebase.dart';
import 'package:smashinfluter/style/button.dart';

class PeditPage extends StatefulWidget {
  @override
  _PeditPageState createState() => _PeditPageState();
}

class _PeditPageState extends State<PeditPage> {
  final TextEditingController _logintxt = TextEditingController();
  final TextEditingController _emailtxt = TextEditingController();
  final TextEditingController _haslotxt = TextEditingController();
  final TextEditingController _haslochektxt = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        setState(() {
          _logintxt.text = data?['login'] ?? '';
          _emailtxt.text = data?['email'] ?? '';
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Color backcolor = Color(0x99D3D3D3);
    Color bordercolor = Colors.blue;

    InputDecoration dekoracjainput({
      required String labelText,
      required String hintText,
    }) {
      return InputDecoration(
        filled: true,
        fillColor: backcolor,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: bordercolor,
            width: 2.0,
          ),
        ),
        labelText: labelText,
        hintText: hintText,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edytuj profil'),
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
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: screenWidth * 0.8,
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24.0),
                TextField(
                  controller: _logintxt,
                  decoration: dekoracjainput(
                    labelText: 'Login',
                    hintText: 'Login',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _emailtxt,
                  decoration: dekoracjainput(
                    labelText: 'Email',
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _haslotxt,
                  obscureText: true,
                  decoration: dekoracjainput(
                    labelText: 'Nowe hasło',
                    hintText: 'Nowe hasło',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _haslochektxt,
                  obscureText: true,
                  decoration: dekoracjainput(
                    labelText: 'Powtórz hasło',
                    hintText: 'Powtórz hasło',
                  ),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                UserService.updateUserData(
                context: context,
                login: _logintxt.text,
                email: _emailtxt.text,
                newPassword: _haslotxt.text,
                repeatPassword: _haslochektxt.text,
                );
                },
                  style: dekoracjabutton(
                    backgroundColor: Color.fromARGB(200, 51, 158, 255),
                    borderColor: Colors.white,
                    textColor: Colors.white,
                  ),
                  child: const Text('Zapisz zmiany'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
