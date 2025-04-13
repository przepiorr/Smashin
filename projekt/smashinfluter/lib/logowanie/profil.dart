import 'package:flutter/material.dart';
import 'auth.dart';
import 'rejestracja.dart';
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
    Color backcolor = Color(0x99D3D3D3);
    Color bordercolor = Colors.blue; // Kolor ramki

    InputDecoration dekoracjainput({
      required String labelText,
      required String hintText,
    }) {
      return InputDecoration(
        filled: true,
        fillColor: backcolor, // Subtelne tło
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: bordercolor, // Kolor ramki
            width: 2.0, // Grubość ramki
          ),
        ),
        labelText: labelText,
        hintText: hintText,
      );
    }

    return Scaffold(
      backgroundColor:Color(0xFF006595) ,
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
              SizedBox(height: 24.0),
              TextField(
                controller: _emailtxttroller,
                decoration: dekoracjainput(
                  labelText: 'Email',
                  hintText: 'Podaj Email',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _haslotxt,
                obscureText: true,
                decoration: dekoracjainput(
                  labelText: 'Hasło',
                  hintText: 'Podaj hasło',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                AuthService().signin(
                 email: _emailtxttroller.text,
                 password: _haslotxt.text,
                 context: context);
                },
                child: const Text('Zaloguj'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
               },
              child: const Text('Zarejestruj'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
