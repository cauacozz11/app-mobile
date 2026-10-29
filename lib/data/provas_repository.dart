import 'package:app_mobile/data/firestore_repository.dart';
import 'package:app_mobile/models/prova.dart';

class ProvasRepository extends FirestoreRepository<Prova> {
  ProvasRepository._() : super('provas');
  static final ProvasRepository instance = ProvasRepository._();

  @override
  String idDe(Prova item) => item.id;

  @override
  Map<String, dynamic> toMap(Prova item) => item.toMap();

  @override
  Prova fromMap(Map<String, dynamic> map) => Prova.fromMap(map);
}
