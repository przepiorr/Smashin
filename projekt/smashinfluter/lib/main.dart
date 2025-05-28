import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smashinfluter/Strony/firebase_options.dart';
import 'package:smashinfluter/logowanie/profil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Use await here
  runApp(const MyApp());
   Future.delayed(const Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(200, 1, 128, 239)), // ← domyślna paleta
        useMaterial3: true,
        ),
      home: ProfilPage(),
    );
  }
}
