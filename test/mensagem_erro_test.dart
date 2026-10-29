import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_mobile/utils/mensagem_erro.dart';

void main() {
  test('sem conexão pede para verificar a internet', () {
    final erro = FirebaseException(
      plugin: 'cloud_firestore',
      code: 'unavailable',
    );
    expect(mensagemErro(erro), contains('Sem conexão'));
  });

  test('tempo esgotado avisa que a conexão está lenta', () {
    expect(mensagemErro(TimeoutException(null)), contains('lenta'));
  });

  test('erro desconhecido usa a mensagem genérica', () {
    expect(mensagemErro(Exception('x')), 'Algo deu errado. Tente novamente.');
  });
}
