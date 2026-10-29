import 'package:app_mobile/data/firestore_repository.dart';
import 'package:app_mobile/screens/questoes/questao_cadastrada.dart';

/// Acesso à coleção `questoes` do Firestore.
/// O id do documento é o mesmo `Questao.id`.
class QuestoesRepository extends FirestoreRepository<QuestaoCadastrada> {
  QuestoesRepository._() : super('questoes');
  static final QuestoesRepository instance = QuestoesRepository._();

  @override
  String idDe(QuestaoCadastrada item) => item.questao.id;

  @override
  Map<String, dynamic> toMap(QuestaoCadastrada item) => item.toMap();

  @override
  QuestaoCadastrada fromMap(Map<String, dynamic> map) =>
      QuestaoCadastrada.fromMap(map);
}
