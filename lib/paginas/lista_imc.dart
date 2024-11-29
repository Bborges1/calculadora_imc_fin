import 'package:calculadora_imc/modelo/Imc.dart';
import 'package:calculadora_imc/servico/servico_autenticacao.dart';
import 'package:calculadora_imc/servico/servico_imc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final ServicoAutenticacao servicoAutenticacao = ServicoAutenticacao();
  final ServicoImc servicoImc = ServicoImc();

  String get usuarioId => servicoAutenticacao.buscaDadosUsuario()!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: servicoImc.todosCalculos(usuarioId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os resultados.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum resultado disponível',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          final results = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              final String id = result.id;
              final double peso = result['peso'];
              final double altura = result['altura'];
              final double imc = result['imc'];
              DateTime dataFirebase = DateTime.parse(result['data']);

              String data =
                  "${dataFirebase.day.toString().padLeft(2, '0')}/${dataFirebase.month.toString().padLeft(2, '0')}/${dataFirebase.year.toString().padLeft(2, '0')}";

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.grey[850],
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    'Peso: ${peso.toStringAsFixed(2)} kg | Altura: ${altura.toStringAsFixed(2)} m',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  subtitle: Text(
                    'IMC: ${imc.toStringAsFixed(2)}\nData: ${data} ',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editResult(context, id,
                              result.data() as Map<String, dynamic>);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteResult(context, id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.grey[900],
    );
  }

  void _editResult(BuildContext context, String id, Map<String, dynamic> data) {
    final TextEditingController pesoController =
        TextEditingController(text: data['peso'].toString());
    final TextEditingController alturaController =
        TextEditingController(text: data['altura'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Editar Cálculo',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pesoController,
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: alturaController,
              decoration: const InputDecoration(
                labelText: 'Altura (m)',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final String novoPeso = pesoController.text;
              final String novaAltura = alturaController.text;

              if (novoPeso.isNotEmpty && novaAltura.isNotEmpty) {
                await servicoImc.alterarCalculo(Imc(
                  id: id,
                  altura: double.parse(novaAltura),
                  peso: double.parse(novoPeso),
                ));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Cálculo atualizado com sucesso!'),
                  backgroundColor: Colors.green,
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Preencha todos os campos.'),
                  backgroundColor: Colors.red,
                ));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'Salvar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteResult(BuildContext context, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Confirmar Exclusão',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Tem certeza que deseja excluir este cálculo?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await servicoImc.deletarCalculo(id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cálculo excluído com sucesso!'),
        backgroundColor: Colors.green,
      ));
    }
  }
}
