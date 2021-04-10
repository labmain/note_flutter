import 'package:flutter/material.dart';

import 'Routers/Routers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '云笔记',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: Routers.root,
      routes: Routers.routers,
    );
  }
}
