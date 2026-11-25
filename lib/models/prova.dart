
import 'package:app_mobile/models/questao.dart';

class Prova {
  final String id;
  final String titulo;
  final String disciplina;
  final List<Questao> questoes;
  final DateTime dataCriacao;
  final String status;
  final String? turmaId;
  final String? turmaNome;

  Prova({
    required this.id,
    required this.titulo,
    required this.disciplina,
    required this.questoes,
    required this.dataCriacao,
    this.status = 'rascunho',
    this.turmaId,
    this.turmaNome,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'titulo': titulo,
    'disciplina': disciplina,
    'questoes': questoes.map((q) => q.toMap()).toList(),
    'dataCriacao': dataCriacao,
    'status': status,
    'turmaId': turmaId,
    'turmaNome': turmaNome,
  };

  factory Prova.fromMap(Map<String, dynamic> map) => Prova(
    id: map['id'] as String,
    titulo: map['titulo'] as String,
    disciplina: map['disciplina'] as String,
    questoes: (map['questoes'] as List)
        .map((q) => Questao.fromMap(Map<String, dynamic>.from(q as Map)))
        .toList(),
    dataCriacao: _lerData(map['dataCriacao']),
    status: map['status'] as String? ?? 'rascunho',
    turmaId: map['turmaId'] as String?,
    turmaNome: map['turmaNome'] as String?,
  );
}

DateTime _lerData(dynamic valor) {
  if (valor is DateTime) return valor;
  return valor.toDate() as DateTime;
}
