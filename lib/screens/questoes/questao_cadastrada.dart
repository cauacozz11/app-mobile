import 'package:app_mobile/models/questao.dart';

class QuestaoCadastrada {
  final Questao questao;
  final String disciplina;
  final String dificuldade;

  const QuestaoCadastrada({
    required this.questao,
    required this.disciplina,
    required this.dificuldade,
  });

  QuestaoCadastrada copyWith({
    Questao? questao,
    String? disciplina,
    String? dificuldade,
  }) {
    return QuestaoCadastrada(
      questao: questao ?? this.questao,
      disciplina: disciplina ?? this.disciplina,
      dificuldade: dificuldade ?? this.dificuldade,
    );
  }
}
