import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _logintxt = TextEditingController();
  final TextEditingController _emailtxt = TextEditingController();
  final TextEditingController _haslotxt = TextEditingController();
  final TextEditingController _haslochektxt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Color backcolor = Color(0x99D3D3D3);
    Color bordercolor = Colors.blue; // Kolor ramk

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
    }// i
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
                controller: _logintxt,
                decoration: dekoracjainput(
                  labelText: 'Login',
                  hintText: 'Podaj Login',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailtxt,
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
              TextField(
                controller: _haslochektxt,
                obscureText: true,
                decoration: dekoracjainput(
                  labelText: 'Potwierdz hasło',
                  hintText: 'Potwierdz hasło',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                if(_haslotxt.text == _haslochektxt.text){
                  AuthService().signup(
                  login: _logintxt.text,
                  email: _emailtxt.text,
                  password: _haslotxt.text,
                  context: context);
                }else{
                      Fluttertoast.showToast(
                      msg: "Hasła się różnią",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                }},
                child: const Text('Zarejestruj'),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
