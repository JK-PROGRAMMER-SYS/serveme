import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/welcome_page.dart';

// Este é o ponto de entrada da aplicação ServeMe. Ele inicializa o Firebase e exibe a página de boas-vindas.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // inicializa Firebase
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
      home: const WelcomePage(),
    );
  }
}
