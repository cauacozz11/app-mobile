import 'dart:async';

import 'package:firebase_core/firebase_core.dart';

String mensagemErro(Object erro) {
  if (erro is TimeoutException) {
    return 'A conexão está lenta. Verifique a internet e tente novamente.';
  }
  if (erro is FirebaseException) {
    switch (erro.code) {
      case 'unavailable':
        return 'Sem conexão com a internet. Verifique a rede e tente novamente.';
      case 'deadline-exceeded':
        return 'A conexão está lenta. Verifique a internet e tente novamente.';
      case 'permission-denied':
        return 'Você não tem permissão para acessar esses dados.';
      case 'not-found':
        return 'Registro não encontrado. Ele pode ter sido excluído.';
    }
  }
  return 'Algo deu errado. Tente novamente.';
}
