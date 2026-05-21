import 'package:flutter/material.dart';
import '../utils/validators.dart';
import '../utils/masks.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailPhoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController docController = TextEditingController();

  String userType = 'freelancer'; // padrão inicial

  void _register() {
    if (nameController.text.isEmpty ||
        emailPhoneController.text.isEmpty ||
        passController.text.isEmpty ||
        confirmPassController.text.isEmpty ||
        docController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    // Validação de e-mail ou telefone
    String input = emailPhoneController.text.trim();
    bool validEmail = Validators.isValidEmail(input);
    bool validPhone = Validators.isValidPhone(input);

    if (!validEmail && !validPhone) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um e-mail ou telefone válido!')),
      );
      return;
    }

    if (passController.text != confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem!')),
      );
      return;
    }

    if (userType == 'freelancer' && !Validators.isValidCPF(docController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CPF inválido!')),
      );
      return;
    }

    if (userType == 'estabelecimento' && !Validators.isValidCNPJ(docController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CNPJ inválido!')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro realizado com sucesso!')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
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
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome completo ou Razão Social',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
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
            TextField(
              controller: confirmPassController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: userType,
              items: const [
                DropdownMenuItem(
                  value: 'freelancer',
                  child: Text('Freelancer (CPF)'),
                ),
                DropdownMenuItem(
                  value: 'estabelecimento',
                  child: Text('Estabelecimento Parceiro (CNPJ)'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  userType = value!;
                  docController.clear();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Tipo de usuário',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: docController,
              decoration: InputDecoration(
                labelText: userType == 'freelancer' ? 'CPF' : 'CNPJ',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  docController.text = userType == 'freelancer'
                      ? Masks.formatCPF(value)
                      : Masks.formatCNPJ(value);
                  docController.selection = TextSelection.fromPosition(
                    TextPosition(offset: docController.text.length),
                  );
                });
              },
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
