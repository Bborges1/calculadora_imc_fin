import 'package:firebase_auth/firebase_auth.dart';

class ServicoAutenticacao {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> create(String usuario, String email, String senha) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await userCredential.user!.updateDisplayName(usuario);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "Conta já existe. Tente novamente";
      } else {
        return "Erro ao criar usuário. ${e.message}";
      }
    } catch (e) {
      return "Erro ao criar conta ${e}";
    }
  }

  Future<String?> login(String email, String senha) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  User? buscaDadosUsuario() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return user;
    }

    return null;
  }
}
