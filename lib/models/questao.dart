import 'package:app_mobile/models/alternativa.dart';

class Questao {
  final String id;
  final String enunciado;
  final List<Alternativa> alternativas;
  final int indiceAlternativaCorreta;

  Questao({
    required this.id,
    required this.enunciado,
    required this.alternativas,
    required this.indiceAlternativaCorreta,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'enunciado': enunciado,
    'alternativas': alternativas.map((a) => a.toMap()).toList(),
    'indiceAlternativaCorreta': indiceAlternativaCorreta,
  };

  factory Questao.fromMap(Map<String, dynamic> map) => Questao(
    id: map['id'] as String,
    enunciado: map['enunciado'] as String,
    alternativas: (map['alternativas'] as List)
        .map((a) => Alternativa.fromMap(Map<String, dynamic>.from(a as Map)))
        .toList(),
    indiceAlternativaCorreta: map['indiceAlternativaCorreta'] as int,
  );
}