import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:app_mobile/screens/questoes/questao_cadastrada.dart';

/// Acesso à coleção `questoes` do Firestore.
/// O id do documento é o mesmo `Questao.id`.
///
/// Tarefa 10 (edição e exclusão). O método de listar (tarefa 8) é
/// adicionado por quem faz essa tarefa.
class QuestoesRepository {
  QuestoesRepository._();
  static final QuestoesRepository instance = QuestoesRepository._();

  CollectionReference<Map<String, dynamic>> get _colecao =>
      FirebaseFirestore.instance.collection('questoes');

  /// Grava uma questão nova em `questoes/{id}`.
  Future<void> criar(QuestaoCadastrada item) {
    return _colecao.doc(item.questao.id).set({
      ...item.toMap(),
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }

  /// Grava a edição. Usa merge para funcionar também com questões que
  /// ainda não existem no banco (ex.: as do mock), sem apagar outros campos.
  Future<void> atualizar(QuestaoCadastrada item) {
    return _colecao.doc(item.questao.id).set({
      ...item.toMap(),
      'atualizadoEm': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> excluir(String id) => _colecao.doc(id).delete();
}