import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'menu_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailPhoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _validateLogin() async {
    String input = emailPhoneController.text.trim();
    String senha = passController.text.trim();

    if (input.isEmpty || senha.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: input,
        password: senha,
      );

      if (!mounted) return;

      if (userCredential.user != null) {
        // 🔹 Chama o backend para buscar dados do usuário
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"uid": userCredential.user!.uid}),
        );

        if (!mounted) return;

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final user = data['user'];
          final int userId = user['id'];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MenuPage(userId: userId)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao validar usuário no backend')),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = 'Erro no login';
      if (e.code == 'user-not-found') {
        message = 'Usuário não encontrado';
      } else if (e.code == 'wrong-password') {
        message = 'Senha incorreta';
      } else if (e.code == 'invalid-email') {
        message = 'E-mail inválido';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro inesperado: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailPhoneController,
              decoration: const InputDecoration(
                labelText: 'E-mail ou Telefone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _validateLogin,
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text('Não tem conta? Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}
