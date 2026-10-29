import 'package:app_mobile/models/questao.dart';

class QuestaoCadastrada {
  final Questao questao;
  final String disciplina;
  final String dificuldade;
  final bool rascunho;

  const QuestaoCadastrada({
    required this.questao,
    required this.disciplina,
    required this.dificuldade,
    this.rascunho = false,
  });

  QuestaoCadastrada copyWith({
    Questao? questao,
    String? disciplina,
    String? dificuldade,
    bool? rascunho,
  }) {
    return QuestaoCadastrada(
      questao: questao ?? this.questao,
      disciplina: disciplina ?? this.disciplina,
      dificuldade: dificuldade ?? this.dificuldade,
      rascunho: rascunho ?? this.rascunho,
    );
  }

  Map<String, dynamic> toMap() => {
    ...questao.toMap(),
    'disciplina': disciplina,
    'dificuldade': dificuldade,
    'rascunho': rascunho,
  };

  factory QuestaoCadastrada.fromMap(Map<String, dynamic> map) {
    return QuestaoCadastrada(
      questao: Questao.fromMap(map),
      disciplina: (map['disciplina'] ?? '') as String,
      dificuldade: (map['dificuldade'] ?? 'Fácil') as String,
      rascunho: (map['rascunho'] ?? false) as bool,
    );
  }
}