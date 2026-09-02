import 'package:app_mobile/models/alternativa.dart';

class Questao {
  final String id;
  final String enunciado;
  final List<Alternativa> alternativas;
  // posição na lista
  final int indiceAlternativaCorreta;

  Questao({
    required this.id,
    required this.enunciado,
    required this.alternativas,
    required this.indiceAlternativaCorreta,
  });
}
