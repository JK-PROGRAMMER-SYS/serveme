import 'package:flutter/material.dart';
import 'pages/welcome_page.dart'; // só precisa importar a tela inicial

void main() {
  runApp(const ServeMeApp());
}

class ServeMeApp extends StatelessWidget {
  const ServeMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ServeMe',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WelcomePage(), // tela inicial
    );
  }
}
