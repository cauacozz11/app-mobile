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
}
