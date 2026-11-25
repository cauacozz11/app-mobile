import 'dart:math';

import 'package:app_mobile/models/alternativa.dart';
import 'package:app_mobile/models/questao.dart';

/// Embaralha as questões e/ou as alternativas de cada questão.
/// Ao trocar as alternativas de lugar, a alternativa correta acompanha o novo
/// índice, então o gabarito e a correção continuam certos.
List<Questao> embaralharQuestoes(
  List<Questao> questoes, {
  bool ordemQuestoes = false,
  bool alternativas = false,
  Random? random,
}) {
  final sorteio = random ?? Random();
  final resultado = [
    for (final q in questoes) alternativas ? _embaralharAlternativas(q, sorteio) : q,
  ];
  if (ordemQuestoes) resultado.shuffle(sorteio);
  return resultado;
}

Questao _embaralharAlternativas(Questao questao, Random sorteio) {
  final ordem = List<int>.generate(questao.alternativas.length, (i) => i)
    ..shuffle(sorteio);
  return Questao(
    id: questao.id,
    enunciado: questao.enunciado,
    alternativas: [
      for (var novo = 0; novo < ordem.length; novo++)
        Alternativa(texto: questao.alternativas[ordem[novo]].texto, ordem: novo),
    ],
    indiceAlternativaCorreta: ordem.indexOf(questao.indiceAlternativaCorreta),
  );
}
