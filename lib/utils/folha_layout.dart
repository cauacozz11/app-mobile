/// Layout da folha de respostas, em pontos do PDF (origem no canto superior
/// esquerdo da página A4). O PDF e a leitura da foto usam estas mesmas medidas.
class FolhaLayout {
  FolhaLayout._();

  static const double paginaLargura = 595.28;
  static const double paginaAltura = 841.89;

  /// Quadrados pretos dos cantos: centros (TL, TR, BL, BR) e lado.
  static const double marcadorLado = 24;
  static const List<List<double>> marcadores = [
    [42, 42],
    [553, 42],
    [42, 800],
    [553, 800],
  ];
  static const double retanguloLargura = 553 - 42;
  static const double retanguloAltura = 800 - 42;

  /// Grade de bolinhas: duas colunas de 25 linhas.
  static const double primeiraLinhaY = 211;
  static const double alturaLinha = 22;
  static const int linhasPorColuna = 25;
  static const List<double> colunasX = [70, 320];
  static const double bolinhaDx0 = 40;
  static const double bolinhaDx = 30;
  static const double bolinhaRaio = 7;

  static const int maxAlternativas = 5;
  static const int maxQuestoes = linhasPorColuna * 2;

  /// Centro da bolinha da alternativa [alt] da questão [questao] (índices a partir de 0).
  static List<double> centroBolinha(int questao, int alt) {
    final coluna = questao ~/ linhasPorColuna;
    final linha = questao % linhasPorColuna;
    return [
      colunasX[coluna] + bolinhaDx0 + alt * bolinhaDx,
      primeiraLinhaY + linha * alturaLinha,
    ];
  }
}
