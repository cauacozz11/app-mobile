import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:app_mobile/data/usuarios_repository.dart';
import 'package:app_mobile/models/usuario.dart';
import 'package:app_mobile/utils/mensagem_erro.dart';

/// Cadastro e login de professores pelo Firebase Authentication (e-mail e senha).
class Autenticacao {
  Autenticacao._();

  static Future<Usuario> cadastrar({
    required String nome,
    required String email,
    required String senha,
    String instituicao = '',
    List<String> disciplinas = const [],
  }) async {
    final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
    final usuario = Usuario(
      id: cred.user!.uid,
      nome: nome,
      email: email,
      senha: '',
      instituicao: instituicao,
      disciplinas: disciplinas,
    );
    await UsuariosRepository.instance.salvar(usuario);
    return usuario;
  }

  static Future<Usuario> entrar(String email, String senha) async {
    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
    final uid = cred.user!.uid;
    final salvo = await UsuariosRepository.instance.buscar(uid);
    return salvo ??
        Usuario(id: uid, nome: email, email: email, senha: '');
  }

  /// Desconecta o professor do Firebase Authentication.
  static Future<void> sair() => FirebaseAuth.instance.signOut();

  static String mensagem(Object erro) {
    if (erro is FirebaseAuthException) {
      switch (erro.code) {
        case 'email-already-in-use':
          return 'Já existe uma conta com esse e-mail.';
        case 'weak-password':
          return 'A senha é fraca. Use pelo menos 6 caracteres.';
        case 'invalid-email':
          return 'E-mail inválido.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'E-mail ou senha inválidos';
        case 'network-request-failed':
          return 'Sem conexão com a internet. Verifique a rede e tente novamente.';
        case 'operation-not-allowed':
          return 'O login por e-mail e senha ainda não está ativado no Firebase.';
        case 'too-many-requests':
          return 'Muitas tentativas. Aguarde um pouco e tente novamente.';
      }
    }
    return mensagemErro(erro);
  }
}
