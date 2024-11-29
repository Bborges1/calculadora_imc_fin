import 'package:calculadora_imc/mensagem_erro/mensagem_erro.dart';
import 'package:calculadora_imc/paginas/login.dart';
import 'package:calculadora_imc/servico/servico_autenticacao.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nomeusuario = TextEditingController();
  final TextEditingController emailUsuario = TextEditingController();
  final TextEditingController senhaUsuario = TextEditingController();
  final ServicoAutenticacao servicoAutenticacao = ServicoAutenticacao();

  final GlobalKey<FormState> formulario = GlobalKey<FormState>();

  Future<void> _registrarNovoUsuario() async {
    if (formulario.currentState?.validate() ?? false) {
      try {
        final String? error = await servicoAutenticacao.create(
          nomeusuario.text,
          emailUsuario.text,
          senhaUsuario.text,
        );
        if (error != null) {
          showSnackBar(context: context, message: error);
        } else {
          showSnackBar(
            context: context,
            message: "Cadastro realizado com sucesso.",
            isError: false,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        }
      } catch (e) {
        showSnackBar(
          context: context,
          message: "Erro inesperado: ${e.toString()}",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.grey[850],
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: formulario,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Crie sua conta',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: nomeusuario,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.white),
                          labelText: 'Usuário',
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (String? valor) {
                          if (valor == null || valor.isEmpty) {
                            return 'É necessário preencher o campo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: emailUsuario,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.white),
                          labelText: 'Email',
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (String? valor) {
                          if (valor == null || valor.isEmpty) {
                            return 'É necessário preencher o campo';
                          }
                          if (!valor.contains('@')) {
                            return 'O campo deve ser um e-mail válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: senhaUsuario,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.white),
                          labelText: 'Senha',
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (String? valor) {
                          if (valor == null || valor.isEmpty) {
                            return 'É necessário preencher o campo';
                          }
                          if (valor.length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _registrarNovoUsuario,
                        child: const Text(
                          'Cadastrar',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
