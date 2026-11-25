import 'package:app_mobile/data/firestore_repository.dart';
import 'package:app_mobile/models/turma.dart';

/// Acesso à coleção `turmas` do Firestore (filtrada pelo professor logado).
class TurmasRepository extends FirestoreRepository<Turma> {
  TurmasRepository._() : super('turmas');
  static final TurmasRepository instance = TurmasRepository._();

  @override
  String idDe(Turma item) => item.id;

  @override
  Map<String, dynamic> toMap(Turma item) => item.toMap();

  @override
  Turma fromMap(Map<String, dynamic> map) => Turma.fromMap(map);
}
