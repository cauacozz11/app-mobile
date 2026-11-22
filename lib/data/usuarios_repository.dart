import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:app_mobile/models/usuario.dart';

/// Perfil dos professores na coleção `usuarios` (o id do documento é o uid do
/// Firebase Authentication). A senha nunca é gravada aqui.
class UsuariosRepository {
  UsuariosRepository._();
  static final UsuariosRepository instance = UsuariosRepository._();

  CollectionReference<Map<String, dynamic>> get _colecao =>
      FirebaseFirestore.instance.collection('usuarios');

  Future<void> salvar(Usuario usuario) {
    return _colecao
        .doc(usuario.id)
        .set({
          ...usuario.toMap(),
          'criadoEm': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true))
        .timeout(const Duration(seconds: 10));
  }

  Future<Usuario?> buscar(String id) async {
    final doc = await _colecao.doc(id).get().timeout(const Duration(seconds: 10));
    final dados = doc.data();
    if (dados == null) return null;
    return Usuario.fromMap({...dados, 'id': doc.id});
  }
}
