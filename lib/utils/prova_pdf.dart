import 'dart:math' as math;
import 'dart:typed_data';

import 'package:barcode/barcode.dart' as bc;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:app_mobile/models/prova.dart';
import 'package:app_mobile/utils/folha_layout.dart';

/// Prefixo do QRCode, para o leitor reconhecer que o código é do ProvaLeve.
const String prefixoQr = 'provaleve:';

/// Aluno para quem uma cópia da prova é gerada (nome opcional).
class AlunoCopia {
  const AlunoCopia({this.nome = ''});

  final String nome;
}

/// O que há dentro de um QRCode do ProvaLeve.
class ConteudoQr {
  const ConteudoQr({required this.provaId, this.aluno = ''});

  final String provaId;
  final String aluno;
}

/// QRCode de identificação da prova: abre a prova no aplicativo.
String conteudoQr(Prova prova) => '$prefixoQr${prova.id}';

/// QRCode de identificação individual: prova e nome do aluno.
String conteudoQrAluno(Prova prova, AlunoCopia aluno) {
  final nome = aluno.nome.replaceAll('|', ' ').trim();
  if (nome.isEmpty) return conteudoQr(prova);
  return '$prefixoQr${prova.id}|$nome';
}

/// Lê o texto de um QRCode. Devolve `null` se o código não for do ProvaLeve.
ConteudoQr? lerQr(String? texto) {
  if (texto == null || !texto.startsWith(prefixoQr)) return null;
  final partes = texto.substring(prefixoQr.length).split('|');
  final id = partes.first.trim();
  if (id.isEmpty) return null;
  return ConteudoQr(
    provaId: id,
    aluno: partes.length >= 2 ? partes[1].trim() : '',
  );
}

String? provaIdDoQr(String? texto) => lerQr(texto)?.provaId;

String nomeArquivoPdf(Prova prova) {
  final nome = prova.titulo
      .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
  return 'prova_${nome.isEmpty ? prova.id : nome}.pdf';
}

/// Quantas bolinhas (A, B, C...) a folha de respostas tem por questão.
int alternativasDaFolha(Prova prova) {
  var maior = 2;
  for (final questao in prova.questoes) {
    maior = math.max(maior, questao.alternativas.length);
  }
  return math.min(maior, FolhaLayout.maxAlternativas);
}

String _letra(int indice) => String.fromCharCode(65 + indice);

pw.Widget _qr(String dados, double tamanho) => pw.BarcodeWidget(
  barcode: bc.Barcode.qrCode(),
  data: dados,
  width: tamanho,
  height: tamanho,
);

pw.Widget _campo(String rotulo, String valor, int flex) => pw.Expanded(
  flex: flex,
  child: pw.Container(
    padding: const pw.EdgeInsets.only(bottom: 2),
    decoration: const pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
    ),
    child: pw.Text('$rotulo: $valor', style: const pw.TextStyle(fontSize: 11)),
  ),
);

/// Gera o PDF: para cada aluno, a prova (com QRCode da prova e QRCode
/// individual em cada página) e, em página separada, a folha de respostas.
/// Sem alunos, gera uma cópia em branco.
Future<Uint8List> gerarPdfProva(
  Prova prova, {
  List<AlunoCopia> alunos = const [],
}) async {
  if (prova.questoes.length > FolhaLayout.maxQuestoes) {
    throw StateError(
      'A folha de respostas comporta até ${FolhaLayout.maxQuestoes} questões.',
    );
  }
  final documento = pw.Document(title: prova.titulo, author: 'ProvaLeve');
  final copias = alunos.isEmpty ? const [AlunoCopia()] : alunos;
  for (final aluno in copias) {
    _adicionarProva(documento, prova, aluno);
    _adicionarFolhaDeRespostas(documento, prova, aluno);
  }
  return documento.save();
}

void _adicionarProva(pw.Document documento, Prova prova, AlunoCopia aluno) {
  final qrIndividual = conteudoQrAluno(prova, aluno);
  documento.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(36, 36, 36, 30),
      footer: (context) => pw.Padding(
        padding: const pw.EdgeInsets.only(top: 8),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Row(
              children: [
                _qr(qrIndividual, 40),
                pw.SizedBox(width: 6),
                pw.Text(
                  'Identificação individual',
                  style: const pw.TextStyle(fontSize: 7),
                ),
              ],
            ),
            pw.Text(
              'Página ${context.pageNumber} de ${context.pagesCount + 1}',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ),
      ),
      build: (context) => [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    prova.titulo,
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    prova.turmaNome != null
                        ? 'Turma: ${prova.turmaNome}  ·  ${prova.disciplina}'
                        : prova.disciplina,
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
            pw.Column(
              children: [
                _qr(conteudoQr(prova), 70),
                pw.SizedBox(height: 2),
                pw.Text(
                  'Identificação da prova',
                  style: const pw.TextStyle(fontSize: 7),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 14),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 0.8),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            children: [
              pw.Row(children: [_campo('Aluno', aluno.nome, 1)]),
              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  _campo('Data', '', 3),
                  pw.SizedBox(width: 16),
                  _campo('Nota', '', 2),
                ],
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          'Marque apenas uma alternativa por questão, na folha de respostas.',
          style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic),
        ),
        pw.SizedBox(height: 14),
        for (var i = 0; i < prova.questoes.length; i++)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 12),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${i + 1}. ${prova.questoes[i].enunciado}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 3),
                for (var j = 0; j < prova.questoes[i].alternativas.length; j++)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 10, top: 2),
                    child: pw.Text(
                      '${_letra(j)}) ${prova.questoes[i].alternativas[j].texto}',
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                  ),
              ],
            ),
          ),
      ],
    ),
  );
}

void _adicionarFolhaDeRespostas(
  pw.Document documento,
  Prova prova,
  AlunoCopia aluno,
) {
  final total = prova.questoes.length;
  final alternativas = alternativasDaFolha(prova);

  pw.Widget posicionar(double x, double y, pw.Widget filho) =>
      pw.Positioned(left: x, top: y, child: filho);

  documento.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (context) => pw.Stack(
        fit: pw.StackFit.expand,
        children: [
          // Quadrados pretos dos cantos: servem de referência para ler a foto.
          for (final m in FolhaLayout.marcadores)
            posicionar(
              m[0] - FolhaLayout.marcadorLado / 2,
              m[1] - FolhaLayout.marcadorLado / 2,
              pw.Container(
                width: FolhaLayout.marcadorLado,
                height: FolhaLayout.marcadorLado,
                color: PdfColors.black,
              ),
            ),
          posicionar(
            80,
            62,
            pw.Text(
              'FOLHA DE RESPOSTAS',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),
          posicionar(
            80,
            88,
            pw.Text(
              prova.turmaNome != null
                  ? '${prova.titulo}  ·  Turma: ${prova.turmaNome}'
                  : prova.titulo,
              style: const pw.TextStyle(fontSize: 11),
            ),
          ),
          posicionar(
            80,
            110,
            pw.Text(
              'Aluno: ${aluno.nome}',
              style: const pw.TextStyle(fontSize: 11),
            ),
          ),
          posicionar(
            80,
            148,
            pw.SizedBox(
              width: 340,
              child: pw.Text(
                'Preencha totalmente a bolinha da alternativa escolhida, com caneta preta ou azul. Marque só uma por questão e não rasure. Não escreva perto dos quadrados pretos.',
                style: const pw.TextStyle(fontSize: 8),
              ),
            ),
          ),
          posicionar(440, 62, _qr(conteudoQrAluno(prova, aluno), 80)),
          for (var coluna = 0; coluna < 2; coluna++)
            if (coluna * FolhaLayout.linhasPorColuna < total)
              for (var j = 0; j < alternativas; j++)
                posicionar(
                  FolhaLayout.colunasX[coluna] +
                      FolhaLayout.bolinhaDx0 +
                      j * FolhaLayout.bolinhaDx -
                      3,
                  189,
                  pw.Text(
                    _letra(j),
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
          for (var q = 0; q < total; q++) ...[
            posicionar(
              FolhaLayout.colunasX[q ~/ FolhaLayout.linhasPorColuna],
              FolhaLayout.centroBolinha(q, 0)[1] - 6,
              pw.Text('${q + 1}.', style: const pw.TextStyle(fontSize: 10)),
            ),
            for (var j = 0; j < alternativas; j++)
              posicionar(
                FolhaLayout.centroBolinha(q, j)[0] - FolhaLayout.bolinhaRaio,
                FolhaLayout.centroBolinha(q, j)[1] - FolhaLayout.bolinhaRaio,
                pw.Container(
                  width: FolhaLayout.bolinhaRaio * 2,
                  height: FolhaLayout.bolinhaRaio * 2,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    border: pw.Border.all(width: 1),
                  ),
                ),
              ),
          ],
        ],
      ),
    ),
  );
}
