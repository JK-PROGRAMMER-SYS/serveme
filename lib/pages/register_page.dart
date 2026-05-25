import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController contatoController = TextEditingController();
  final TextEditingController documentoController = TextEditingController();

  String tipo = 'freelancer'; // padrão inicial

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _register() async {
    String email = emailController.text.trim();
    String senha = passController.text.trim();
    String nome = nomeController.text.trim();
    String contato = contatoController.text.trim();
    String documento = documentoController.text.trim();

    if (email.isEmpty ||
        senha.isEmpty ||
        nome.isEmpty ||
        contato.isEmpty ||
        documento.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    try {
      // 🔹 Cria usuário no Firebase
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: senha);

      if (!mounted) return;

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        // 🔹 Salva dados complementares no backend
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/users'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "uid": uid,
            "nome": nome,
            "tipo": tipo,
            "documento": documento,
            "contato": contato,
          }),
        );

        if (!mounted) return; // ✅ antes de usar context novamente

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cadastro realizado com sucesso!')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro ao salvar no backend: ${response.statusCode}',
              ),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Erro no cadastro';
      if (e.code == 'email-already-in-use') {
        message = 'E-mail já cadastrado';
      } else if (e.code == 'weak-password') {
        message = 'Senha muito fraca';
      } else if (e.code == 'invalid-email') {
        message = 'E-mail inválido';
      }

      if (!mounted) return;
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
        title: const Text('Cadastro'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
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
            TextField(
              controller: contatoController,
              decoration: const InputDecoration(
                labelText: 'Telefone/Contato',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: tipo,
              items: const [
                DropdownMenuItem(
                  value: 'freelancer',
                  child: Text('Freelancer'),
                ),
                DropdownMenuItem(
                  value: 'estabelecimento',
                  child: Text('Estabelecimento'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  tipo = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Tipo de Usuário',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: documentoController,
              decoration: InputDecoration(
                labelText: tipo == 'freelancer' ? 'CPF' : 'CNPJ',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
