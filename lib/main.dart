import 'package:flutter/material.dart';
//import 'loginPage.dart';
import 'mainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meus livros 2',
      home: MainPage(),
    );
  }
}
