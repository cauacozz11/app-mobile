import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'package:app_mobile/utils/folha_layout.dart';

/// Resultado da leitura da foto da folha de respostas.
class LeituraFolha {
  const LeituraFolha({this.respostas = const [], this.duvidosas = const [], this.erro});

  /// Índice da alternativa marcada em cada questão (-1 = em branco).
  final List<int> respostas;

  /// Questões (a partir de 0) em branco ou com mais de uma marcação.
  final List<int> duvidosas;

  /// Mensagem de erro quando não foi possível ler a folha.
  final String? erro;
}

/// Lê a folha em um isolate, para não travar a tela.
Future<LeituraFolha> lerFolha(Uint8List bytes, int totalQuestoes, int alternativas) {
  return Isolate.run(() => lerFolhaSincrono(bytes, totalQuestoes, alternativas));
}

/// Acha os 4 quadrados pretos dos cantos, corrige a perspectiva e mede quanto
/// cada bolinha está preenchida.
LeituraFolha lerFolhaSincrono(Uint8List bytes, int totalQuestoes, int alternativas) {
  if (totalQuestoes > FolhaLayout.maxQuestoes) {
    return const LeituraFolha(erro: 'A folha de respostas comporta até 50 questões.');
  }
  final decodificada = img.decodeImage(bytes);
  if (decodificada == null) {
    return const LeituraFolha(erro: 'Não foi possível abrir a imagem.');
  }
  var imagem = img.bakeOrientation(decodificada);
  const largura = 1000;
  imagem = img.copyResize(
    imagem,
    width: largura,
    interpolation: img.Interpolation.average,
  );
  final w = imagem.width;
  final h = imagem.height;
  final rgb = imagem.getBytes(order: img.ChannelOrder.rgb);
  final cinza = Uint8List(w * h);
  for (var i = 0; i < w * h; i++) {
    cinza[i] =
        (0.299 * rgb[i * 3] + 0.587 * rgb[i * 3 + 1] + 0.114 * rgb[i * 3 + 2])
            .round();
  }

  final mascara = _mascaraAdaptativa(cinza, w, h);
  final blobs = _componentes(mascara, w, h);
  final cantos = _acharMarcadores(blobs, w, h);
  if (cantos == null) {
    return const LeituraFolha(
      erro:
          'Não encontrei os 4 quadrados pretos dos cantos da folha. Fotografe a folha inteira, de cima, com boa luz.',
    );
  }

  final topo = _dist(cantos[0], cantos[1]);
  final esquerda = _dist(cantos[0], cantos[2]);
  final razao =
      (topo / esquerda) /
      (FolhaLayout.retanguloLargura / FolhaLayout.retanguloAltura);
  if (razao < 0.8 || razao > 1.25) {
    return const LeituraFolha(
      erro: 'A foto está muito inclinada. Fotografe a folha de frente.',
    );
  }
  final h8 = _homografia(
    const [
      [0.0, 0.0],
      [1.0, 0.0],
      [0.0, 1.0],
      [1.0, 1.0],
    ],
    cantos,
  );
  if (h8 == null) {
    return const LeituraFolha(erro: 'Não foi possível alinhar a folha.');
  }

  final escala =
      (topo / FolhaLayout.retanguloLargura +
          _dist(cantos[2], cantos[3]) / FolhaLayout.retanguloLargura) /
      2;
  final raioInterno = FolhaLayout.bolinhaRaio * escala * 0.70;

  final respostas = <int>[];
  final duvidosas = <int>[];
  for (var q = 0; q < totalQuestoes; q++) {
    final fracoes = <double>[];
    for (var j = 0; j < alternativas; j++) {
      final c = FolhaLayout.centroBolinha(q, j);
      final u = (c[0] - FolhaLayout.marcadores[0][0]) / FolhaLayout.retanguloLargura;
      final v = (c[1] - FolhaLayout.marcadores[0][1]) / FolhaLayout.retanguloAltura;
      final p = _aplicar(h8, u, v);
      fracoes.add(_fracaoEscura(mascara, w, h, p[0], p[1], raioInterno));
    }
    final ordem = List<int>.generate(alternativas, (i) => i)
      ..sort((a, b) => fracoes[b].compareTo(fracoes[a]));
    final f1 = fracoes[ordem[0]];
    final f2 = alternativas > 1 ? fracoes[ordem[1]] : 0.0;
    if (f1 < 0.35) {
      respostas.add(-1);
      duvidosas.add(q);
    } else if (f2 >= 0.35 && f2 > 0.6 * f1) {
      respostas.add(-1);
      duvidosas.add(q);
    } else {
      respostas.add(ordem[0]);
    }
  }
  return LeituraFolha(respostas: respostas, duvidosas: duvidosas);
}

double _dist(List<double> a, List<double> b) =>
    math.sqrt((a[0] - b[0]) * (a[0] - b[0]) + (a[1] - b[1]) * (a[1] - b[1]));

/// Pixel é "escuro" se estiver bem abaixo da média da vizinhança (resiste a sombra).
Uint8List _mascaraAdaptativa(Uint8List cinza, int w, int h) {
  final janela = math.max(15, (w ~/ 20) | 1);
  final meia = janela ~/ 2;
  final integral = List<double>.filled((w + 1) * (h + 1), 0);
  for (var y = 0; y < h; y++) {
    var soma = 0.0;
    for (var x = 0; x < w; x++) {
      soma += cinza[y * w + x];
      integral[(y + 1) * (w + 1) + (x + 1)] =
          integral[y * (w + 1) + (x + 1)] + soma;
    }
  }
  final mascara = Uint8List(w * h);
  for (var y = 0; y < h; y++) {
    final y0 = math.max(0, y - meia);
    final y1 = math.min(h, y + meia + 1);
    for (var x = 0; x < w; x++) {
      final x0 = math.max(0, x - meia);
      final x1 = math.min(w, x + meia + 1);
      final soma =
          integral[y1 * (w + 1) + x1] -
          integral[y0 * (w + 1) + x1] -
          integral[y1 * (w + 1) + x0] +
          integral[y0 * (w + 1) + x0];
      final media = soma / ((y1 - y0) * (x1 - x0));
      final valor = cinza[y * w + x];
      if (valor < media * 0.80 && valor < 170) mascara[y * w + x] = 1;
    }
  }
  return mascara;
}

class _Blob {
  _Blob(this.x0, this.y0, this.x1, this.y1, this.area, this.cx, this.cy);
  final int x0, y0, x1, y1, area;
  final double cx, cy;
}

List<_Blob> _componentes(Uint8List mascara, int w, int h) {
  final visto = Uint8List(w * h);
  final pilha = Int32List(w * h);
  final blobs = <_Blob>[];
  for (var inicio = 0; inicio < w * h; inicio++) {
    if (mascara[inicio] == 0 || visto[inicio] == 1) continue;
    var topo = 0;
    pilha[topo++] = inicio;
    visto[inicio] = 1;
    var minX = w, minY = h, maxX = -1, maxY = -1, area = 0;
    var somaX = 0, somaY = 0;
    while (topo > 0) {
      final p = pilha[--topo];
      final y = p ~/ w;
      final x = p - y * w;
      area++;
      somaX += x;
      somaY += y;
      if (x < minX) minX = x;
      if (x > maxX) maxX = x;
      if (y < minY) minY = y;
      if (y > maxY) maxY = y;
      if (x > 0 && mascara[p - 1] == 1 && visto[p - 1] == 0) {
        visto[p - 1] = 1;
        pilha[topo++] = p - 1;
      }
      if (x < w - 1 && mascara[p + 1] == 1 && visto[p + 1] == 0) {
        visto[p + 1] = 1;
        pilha[topo++] = p + 1;
      }
      if (y > 0 && mascara[p - w] == 1 && visto[p - w] == 0) {
        visto[p - w] = 1;
        pilha[topo++] = p - w;
      }
      if (y < h - 1 && mascara[p + w] == 1 && visto[p + w] == 0) {
        visto[p + w] = 1;
        pilha[topo++] = p + w;
      }
    }
    blobs.add(_Blob(minX, minY, maxX, maxY, area, somaX / area, somaY / area));
  }
  return blobs;
}

/// Quadrados cheios; escolhe o mais próximo de cada canto da imagem (TL, TR, BL, BR).
List<List<double>>? _acharMarcadores(List<_Blob> blobs, int w, int h) {
  final candidatos = <List<double>>[];
  for (final b in blobs) {
    final bw = b.x1 - b.x0 + 1;
    final bh = b.y1 - b.y0 + 1;
    if (bw < 10 || bh < 10 || bw > w * 0.12 || bh > w * 0.12) continue;
    final razao = bw / bh;
    if (razao < 0.65 || razao > 1.55) continue;
    if (b.area / (bw * bh) < 0.78) continue;
    candidatos.add([b.cx, b.cy]);
  }
  if (candidatos.length < 4) return null;
  final cantosImagem = [
    [0.0, 0.0],
    [w.toDouble(), 0.0],
    [0.0, h.toDouble()],
    [w.toDouble(), h.toDouble()],
  ];
  final escolhidos = <List<double>>[];
  for (final canto in cantosImagem) {
    List<double>? melhor;
    var melhorDist = double.infinity;
    for (final c in candidatos) {
      final d = (c[0] - canto[0]) * (c[0] - canto[0]) +
          (c[1] - canto[1]) * (c[1] - canto[1]);
      if (d < melhorDist) {
        melhorDist = d;
        melhor = c;
      }
    }
    escolhidos.add(melhor!);
  }
  for (var i = 0; i < 4; i++) {
    for (var j = i + 1; j < 4; j++) {
      if (identical(escolhidos[i], escolhidos[j])) return null;
    }
  }
  return escolhidos;
}

/// Homografia 3x3 (8 parâmetros) que leva [origem] em [destino], por eliminação de Gauss.
List<double>? _homografia(List<List<double>> origem, List<List<double>> destino) {
  const n = 8;
  final m = List.generate(n, (_) => List<double>.filled(n + 1, 0));
  for (var i = 0; i < 4; i++) {
    final x = origem[i][0], y = origem[i][1];
    final u = destino[i][0], v = destino[i][1];
    m[2 * i] = [x, y, 1, 0, 0, 0, -u * x, -u * y, u];
    m[2 * i + 1] = [0, 0, 0, x, y, 1, -v * x, -v * y, v];
  }
  for (var c = 0; c < n; c++) {
    var piv = c;
    for (var r = c + 1; r < n; r++) {
      if (m[r][c].abs() > m[piv][c].abs()) piv = r;
    }
    if (m[piv][c].abs() < 1e-12) return null;
    final tmp = m[c];
    m[c] = m[piv];
    m[piv] = tmp;
    for (var r = 0; r < n; r++) {
      if (r == c) continue;
      final f = m[r][c] / m[c][c];
      for (var k = c; k <= n; k++) {
        m[r][k] -= f * m[c][k];
      }
    }
  }
  return [for (var i = 0; i < n; i++) m[i][n] / m[i][i], 1.0];
}

List<double> _aplicar(List<double> hm, double x, double y) {
  final d = hm[6] * x + hm[7] * y + hm[8];
  return [
    (hm[0] * x + hm[1] * y + hm[2]) / d,
    (hm[3] * x + hm[4] * y + hm[5]) / d,
  ];
}

double _fracaoEscura(
  Uint8List mascara,
  int w,
  int h,
  double cx,
  double cy,
  double raio,
) {
  final r = raio.ceil();
  var escuros = 0, total = 0;
  for (var y = cy.floor() - r; y <= cy.floor() + r; y++) {
    for (var x = cx.floor() - r; x <= cx.floor() + r; x++) {
      if (x < 0 || y < 0 || x >= w || y >= h) continue;
      final dx = x - cx, dy = y - cy;
      if (dx * dx + dy * dy > raio * raio) continue;
      total++;
      if (mascara[y * w + x] == 1) escuros++;
    }
  }
  return total == 0 ? 0 : escuros / total;
}
