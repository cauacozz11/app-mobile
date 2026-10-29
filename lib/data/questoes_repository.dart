import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:app_mobile/screens/questoes/questao_cadastrada.dart';

/// Acesso à coleção `questoes` do Firestore.
/// O id do documento é o mesmo `Questao.id`.
///
/// Tarefa 10 (edição e exclusão). Os métodos de listar (tarefa 8) e
/// criar (tarefa 9) são adicionados por quem faz essas tarefas.
class QuestoesRepository {
  QuestoesRepository._();
  static final QuestoesRepository instance = QuestoesRepository._();

  CollectionReference<Map<String, dynamic>> get _colecao =>
      FirebaseFirestore.instance.collection('questoes');

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