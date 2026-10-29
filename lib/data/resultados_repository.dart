import 'package:app_mobile/data/firestore_repository.dart';
import 'package:app_mobile/models/resultado.dart';

class ResultadosRepository extends FirestoreRepository<Resultado> {
  ResultadosRepository._() : super('resultados');
  static final ResultadosRepository instance = ResultadosRepository._();

  @override
  String idDe(Resultado item) => item.id;

  @override
  Map<String, dynamic> toMap(Resultado item) => item.toMap();

  @override
  Resultado fromMap(Map<String, dynamic> map) => Resultado.fromMap(map);

  Future<List<Resultado>> listarPorProva(String provaId) =>
      lerConsulta(consulta.where('provaId', isEqualTo: provaId));
}
