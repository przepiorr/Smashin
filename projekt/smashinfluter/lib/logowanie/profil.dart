import 'package:flutter/material.dart';
import 'auth.dart';
import 'rejestracja.dart';
import 'package:smashinfluter/style/input.dart';
import 'package:smashinfluter/style/button.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final TextEditingController _emailtxttroller = TextEditingController();
  final TextEditingController _haslotxt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF006595),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: screenWidth * 0.8,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 24.0),
              TextField(
                controller: _emailtxttroller,
                decoration: dekoracjainput(
                  labelText: 'Email',
                  hintText: 'Podaj Email',
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _haslotxt,
                obscureText: true,
                decoration: dekoracjainput(
                  labelText: 'Hasło',
                  hintText: 'Podaj hasło',
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  AuthService().signin(
                    email: _emailtxttroller.text,
                    password: _haslotxt.text,
                    context: context,
                  );
                },
                style: dekoracjabutton(),
                child: const Text('Zaloguj'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrationPage()),
                  );
                },
                style: dekoracjabutton(),
                child: const Text('Zarejestruj'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
