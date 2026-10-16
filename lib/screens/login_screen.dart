import 'package:flutter/material.dart';

import '../services/app_state.dart';

/// Tela de login mockado: valida e-mail e senha contra os
/// usuários de assets/usuarios.json (carregados no AppState).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AppState _appState = AppState.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _entrar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final bool ok = _appState.entrar(
      _emailController.text.trim(),
      _senhaController.text,
    );
    if (ok) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail ou senha inválidos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (valor) {
                    final email = (valor ?? '').trim();
                    if (email.isEmpty) {
                      return 'Informe o e-mail.';
                    }
                    if (!email.contains('@')) {
                      return 'E-mail inválido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (valor) {
                    if ((valor ?? '').isEmpty) {
                      return 'Informe a senha.';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _entrar(),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _entrar,
                  icon: const Icon(Icons.login),
                  label: const Text('Entrar'),
                ),
                const SizedBox(height: 24),
                Text(
                  'Usuários de teste\n'
                  'ana.souza@aluno.ifba.edu.br — 123456\n'
                  'bruno.lima@aluno.ifba.edu.br — senha123',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
