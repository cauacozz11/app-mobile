import 'package:app_mobile/models/questao.dart';

class Prova {
  final String id;
  final String titulo;
  final String disciplina;
  final List<Questao> questoes;
  final DateTime dataCriacao;

  Prova({
    required this.id,
    required this.titulo,
    required this.disciplina,
    required this.questoes,
    required this.dataCriacao,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'titulo': titulo,
    'disciplina': disciplina,
    'questoes': questoes.map((q) => q.toMap()).toList(),
    'dataCriacao': dataCriacao,
  };

  factory Prova.fromMap(Map<String, dynamic> map) => Prova(
    id: map['id'] as String,
    titulo: map['titulo'] as String,
    disciplina: map['disciplina'] as String,
    questoes: (map['questoes'] as List)
        .map((q) => Questao.fromMap(Map<String, dynamic>.from(q as Map)))
        .toList(),
    dataCriacao: _lerData(map['dataCriacao']),
  );
}

// O Firestore devolve datas como Timestamp (que tem toDate()). Aceita DateTime também.
DateTime _lerData(dynamic valor) {
  if (valor is DateTime) return valor;
  return valor.toDate() as DateTime;
}