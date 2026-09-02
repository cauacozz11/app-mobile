import 'package:app_mobile/models/prova.dart';

class Resultado {
  final String id;
  final String provaId;
  final List<int> respostasMarcadas;
  final double nota;

  Resultado({
    required this.id,
    required this.provaId,
    required this.respostasMarcadas,
    required this.nota,
  });
}
