import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_mobile/screens/questoes/questao_cadastrada.dart';

class QuestoesRepository {
  QuestoesRepository._();
  static final QuestoesRepository instance = QuestoesRepository._();

  CollectionReference<Map<String, dynamic>> get _colecao =>
      FirebaseFirestore.instance.collection('questoes');

  Stream<List<QuestaoCadastrada>> observar() {
    return _colecao.orderBy('criadoEm').snapshots().map((snap) =>
        snap.docs.map((d) => QuestaoCadastrada.fromMap(d.data())).toList());
  }

  Future<void> criar(QuestaoCadastrada item) {
    return _colecao.doc(item.questao.id).set({
      ...item.toMap(),
      'criadoEm': FieldValue.serverTimestamp(),
      'atualizadoEm': FieldValue.serverTimestamp(),
    });
  }

  Future<void> atualizar(QuestaoCadastrada item) {
    return _colecao.doc(item.questao.id).update({
      ...item.toMap(),
      'atualizadoEm': FieldValue.serverTimestamp(),
    });
  }

  Future<void> excluir(String id) => _colecao.doc(id).delete();
}