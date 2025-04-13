import 'package:flutter/material.dart';
import 'package:templatesqlite/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Template SQLITE',
      home: HomePage(),
    );
  }
}