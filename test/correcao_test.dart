import 'package:flutter_test/flutter_test.dart';

import 'package:app_mobile/models/alternativa.dart';
import 'package:app_mobile/models/prova.dart';
import 'package:app_mobile/models/questao.dart';
import 'package:app_mobile/models/resultado.dart';
import 'package:app_mobile/utils/correcao.dart';

Prova _prova(List<int> gabarito) => Prova(
  id: 'p1',
  titulo: 'Prova teste',
  disciplina: 'Matemática',
  dataCriacao: DateTime(2026, 10, 29),
  questoes: [
    for (var i = 0; i < gabarito.length; i++)
      Questao(
        id: 'q$i',
        enunciado: 'Questão $i',
        indiceAlternativaCorreta: gabarito[i],
        alternativas: [
          for (var a = 0; a < 4; a++) Alternativa(texto: 'Alt $a', ordem: a),
        ],
      ),
  ],
);

void main() {
  test('todas certas dá nota 10', () {
    final c = corrigirProva(_prova([0, 1, 2, 3]), [0, 1, 2, 3]);
    expect(c.acertos, 4);
    expect(c.erros, 0);
    expect(c.nota, 10);
  });

  test('todas erradas dá nota 0', () {
    final c = corrigirProva(_prova([0, 1, 2, 3]), [1, 2, 3, 0]);
    expect(c.acertos, 0);
    expect(c.nota, 0);
  });

  test('nota proporcional com uma casa decimal', () {
    final c = corrigirProva(_prova([0, 0, 0]), [0, 0, 1]);
    expect(c.acertos, 2);
    expect(c.nota, 6.7);
  });

  test('questão em branco conta como erro', () {
    final c = corrigirProva(_prova([0, 1]), [0, semResposta]);
    expect(c.acertos, 1);
    expect(c.erros, 1);
    expect(c.nota, 5);
  });

  test('menos respostas que questões não quebra a correção', () {
    final c = corrigirProva(_prova([0, 1, 2]), [0]);
    expect(c.acertos, 1);
    expect(c.total, 3);
  });

  test('prova sem questões dá nota 0', () {
    expect(corrigirProva(_prova([]), []).nota, 0);
  });

  test('Resultado grava e lê o nome do aluno', () {
    final r = Resultado(
      id: 'r1',
      provaId: 'p1',
      nomeAluno: 'Ana',
      respostasMarcadas: [0, semResposta],
      nota: 5,
    );
    final lido = Resultado.fromMap(r.toMap());
    expect(lido.nomeAluno, 'Ana');
    expect(lido.respostasMarcadas, [0, semResposta]);
  });

  test('Resultado antigo sem nomeAluno continua sendo lido', () {
    final lido = Resultado.fromMap({
      'id': 'r1',
      'provaId': 'p1',
      'respostasMarcadas': [0],
      'nota': 10,
    });
    expect(lido.nomeAluno, '');
  });
}
