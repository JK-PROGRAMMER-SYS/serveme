import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/serveme_logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            const Text(
              'ServeMe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sobre o ServeMe',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'A ServeMe é um aplicativo de tecnologia dedicado a conectar '
              'freelancers (funcionários temporários) com bares e restaurantes '
              'que precisam completar seu quadro de funcionários em dias de alta demanda.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nosso objetivo é facilitar a contratação rápida e eficiente, '
              'cobrando apenas um percentual sobre cada contratação realizada '
              'pela plataforma.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            // Imagem responsiva
            Image.asset(
              'assets/stories_ServeMe.png',
              width: MediaQuery.of(context).size.width * 0.9,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
