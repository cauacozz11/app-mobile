import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:app_mobile/models/sessao.dart';

/// Grava o `professorId` em cada documento e filtra as leituras por ele (RNF08).
abstract class FirestoreRepository<T> {
  FirestoreRepository(this.nomeColecao);

  static const Duration _limiteLeitura = Duration(seconds: 15);
  static const Duration _limiteEscrita = Duration(seconds: 5);

  final String nomeColecao;

  String idDe(T item);
  Map<String, dynamic> toMap(T item);
  T fromMap(Map<String, dynamic> map);

  CollectionReference<Map<String, dynamic>> get colecao =>
      FirebaseFirestore.instance.collection(nomeColecao);

  String? get _professorId => Sessao.usuarioAtual?.id;

  Query<Map<String, dynamic>> get consulta =>
      colecao.where('professorId', isEqualTo: _professorId ?? '');

  Future<List<T>> listar() => lerConsulta(consulta);

  Future<T?> buscar(String id) async {
    final doc = await colecao.doc(id).get().timeout(_limiteLeitura);
    final dados = doc.data();
    if (dados == null || dados['professorId'] != _professorId) return null;
    return fromMap({...dados, 'id': doc.id});
  }

  Future<void> criar(T item) {
    return _gravar(
      colecao.doc(idDe(item)).set({
        ..._dados(item),
        'criadoEm': FieldValue.serverTimestamp(),
      }),
    );
  }

  /// Usa merge para não apagar campos que não fazem parte do objeto.
  Future<void> atualizar(T item) {
    return _gravar(
      colecao.doc(idDe(item)).set({
        ..._dados(item),
        'atualizadoEm': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)),
    );
  }

  Future<void> excluir(String id) => _gravar(colecao.doc(id).delete());

  Future<List<T>> lerConsulta(Query<Map<String, dynamic>> consulta) async {
    final snapshot = await consulta.get().timeout(_limiteLeitura);
    // Sem internet e sem nada em cache, o Firestore devolve lista vazia em vez de erro.
    if (snapshot.docs.isEmpty && snapshot.metadata.isFromCache) {
      throw FirebaseException(plugin: 'cloud_firestore', code: 'unavailable');
    }
    return [
      for (final doc in snapshot.docs) fromMap({...doc.data(), 'id': doc.id}),
    ];
  }

  Map<String, dynamic> _dados(T item) => {
    ...toMap(item),
    'professorId': ?_professorId,
  };

  // Sem internet a escrita fica salva no aparelho e o Future só termina quando a
  // conexão volta; passado o limite, seguimos como salvo e o Firestore sincroniza depois.
  Future<void> _gravar(Future<void> escrita) {
    return escrita.timeout(_limiteEscrita, onTimeout: () {});
  }
}
