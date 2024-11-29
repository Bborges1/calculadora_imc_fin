import 'package:calculadora_imc/mensagem_erro/mensagem_erro.dart';
import 'package:calculadora_imc/modelo/Imc.dart';
import 'package:calculadora_imc/paginas/lista_imc.dart';
import 'package:calculadora_imc/paginas/usuario.dart';
import 'package:calculadora_imc/servico/servico_autenticacao.dart';
import 'package:calculadora_imc/servico/servico_imc.dart';
import 'package:flutter/material.dart';

class IMCScreen extends StatefulWidget {
  const IMCScreen({super.key});

  @override
  State<IMCScreen> createState() => _IMCScreenState();
}

class _IMCScreenState extends State<IMCScreen> {
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final ServicoImc servicoImc = ServicoImc();
  final ServicoAutenticacao servicoAutenticacao = ServicoAutenticacao();
  final GlobalKey<FormState> formulario = GlobalKey<FormState>();

  int _currentIndex = 0;

  void _calcularImc() {
    final double peso = double.tryParse(pesoController.text) ?? 0;
    final double altura = double.tryParse(alturaController.text) ?? 0;
    print("${peso}, ${altura}");
    if (formulario.currentState?.validate() ?? false) {
      var usuario = servicoAutenticacao.buscaDadosUsuario();

      servicoImc
          .novoCalculo(Imc(
              usuario: usuario!.uid,
              altura: altura,
              peso: peso,
              data: DateTime.now()))
          .then((String? erro) {
        if (erro != null) {
          showSnackBar(context: context, message: erro);
        } else {
          showSnackBar(
              context: context,
              message: "Informações registradas com sucesso!",
              isError: false);
        }
        pesoController.clear();
        alturaController.clear();
      });
    }
  }

  void _onMenuTap(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultsScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserInfoScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora de IMC',
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
                        'Calcule seu IMC',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        controller: pesoController,
                        decoration: InputDecoration(
                          labelText: 'Peso (kg)',
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.line_weight,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (String? valor) {
                          if (valor == null || valor.isEmpty) {
                            return "Forneça o peso.";
                          }
                          if (double.parse(valor.toString()) <= 0.0) {
                            return "O peso deve ser maior que 0.";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        controller: alturaController,
                        decoration: InputDecoration(
                          labelText: 'Altura (m)',
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.height,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (String? valor) {
                          if (valor == null || valor.isEmpty) {
                            return "Forneça a altura.";
                          }
                          if (double.parse(valor.toString()) <= 0.0) {
                            return "A altura deve ser maior que 0.";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
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
                        onPressed: _calcularImc,
                        child: const Text(
                          'Calcular IMC',
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onMenuTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'IMC',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Resultados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuário',
          ),
        ],
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
      ),
    );
  }
}
