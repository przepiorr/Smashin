import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String message;

  const LoadingScreen({this.message = 'Ładowanie...'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
