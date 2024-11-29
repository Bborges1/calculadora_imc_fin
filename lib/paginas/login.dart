import 'package:calculadora_imc/mensagem_erro/mensagem_erro.dart';
import 'package:calculadora_imc/paginas/imcs.dart';
import 'package:calculadora_imc/paginas/register.dart';
import 'package:calculadora_imc/servico/servico_autenticacao.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final ServicoAutenticacao _servicoAutenticacao = ServicoAutenticacao();
  final GlobalKey<FormState> formulario = GlobalKey<FormState>();

  Future<void> _login() async {
    String email = emailController.text;
    String senha = passwordController.text;
    if (formulario.currentState?.validate() ?? false) {
      try {
        String? erroLogin = await _servicoAutenticacao.login(email, senha);

        if (erroLogin == null) {
          showSnackBar(
              context: context,
              message: "Usuário autenticado com sucesso!",
              isError: false);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => IMCScreen(),
            ),
          );
        } else {
          showSnackBar(context: context, message: erroLogin);
        }
      } catch (e) {
        showSnackBar(context: context, message: "$e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
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
                        'Bem-vindo!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: emailController,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.white),
                          labelText: 'Email',
                          prefixIcon: const Icon(
                            Icons.email,
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
                          if (!valor.contains('@')) {
                            return 'O campo deve ser um e-mail válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
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
                        onPressed: _login,
                        child: const Text(
                          'Entrar',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                        child: const Text(
                          'Criar conta',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
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
