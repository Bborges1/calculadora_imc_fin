import 'package:calculadora_imc/modelo/Imc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicoImc {
  final CollectionReference firebase =
      FirebaseFirestore.instance.collection('imcs');

  Future<String?> novoCalculo(Imc imc) async {
    try {
      DocumentReference docRef = await firebase.add(imc.toMap());
      await docRef.update({'id': docRef.id});
      return null;
    } on FirebaseException catch (e) {
      print("Erro ao salvar cálculo: ${e.message}");
      return e.message;
    } catch (e) {
      print("Erro inesperado: $e");
      return "Erro inesperado.";
    }
  }

  Stream<QuerySnapshot> todosCalculos(String usuario) {
    var todosCalculos =
        firebase.where('usuario', isEqualTo: usuario).snapshots();

    return todosCalculos;
  }

  Future<String?> alterarCalculo(Imc imc) async {
    try {
      await firebase
          .doc(imc.id)
          .update({'altura': imc.altura, 'peso': imc.peso, 'imc': imc.imc});

      return null;
    } on FirebaseException catch (e) {
      return "Erro ao atualizar cálculo ${e.message}";
    }
  }

  Future<void> deletarCalculo(String? id) async {
    await firebase.doc(id).delete();
  }
}
