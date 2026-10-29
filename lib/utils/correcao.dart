import 'package:app_mobile/models/prova.dart';

/// Resposta em branco no gabarito do aluno.
const int semResposta = -1;

class Correcao {
  const Correcao({required this.acertos, required this.total});

  final int acertos;
  final int total;

  int get erros => total - acertos;

  /// Nota de 0 a 10, com uma casa decimal.
  double get nota {
    if (total == 0) return 0;
    return (acertos / total * 100).round() / 10;
  }
}

/// RF16: compara cada resposta marcada com a alternativa correta da questão.
/// Resposta em branco ou fora das alternativas conta como erro.
Correcao corrigirProva(Prova prova, List<int> respostasMarcadas) {
  var acertos = 0;
  for (var i = 0; i < prova.questoes.length; i++) {
    final resposta = i < respostasMarcadas.length
        ? respostasMarcadas[i]
        : semResposta;
    if (resposta == prova.questoes[i].indiceAlternativaCorreta) acertos++;
  }
  return Correcao(acertos: acertos, total: prova.questoes.length);
}
