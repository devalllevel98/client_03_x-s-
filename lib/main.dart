import 'package:flutter/material.dart';
import 'home_screen.dart';


void main() {
  runApp(LotoApp());
}

class LotoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lô Đề Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
