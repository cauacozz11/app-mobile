import 'dart:typed_data';

import 'package:barcode/barcode.dart' as bc;
import 'package:pdf/widgets.dart' as pw;

import 'package:app_mobile/models/prova.dart';

/// Prefixo do QRCode, para o leitor reconhecer que o código é de uma prova do ProvaLeve.
const String prefixoQr = 'provaleve:';

String conteudoQr(Prova prova) => '$prefixoQr${prova.id}';

/// Devolve o id da prova guardado no QRCode, ou `null` se o código não for do ProvaLeve.
String? provaIdDoQr(String? texto) {
  if (texto == null || !texto.startsWith(prefixoQr)) return null;
  final id = texto.substring(prefixoQr.length).trim();
  return id.isEmpty ? null : id;
}

String nomeArquivoPdf(Prova prova) {
  final nome = prova.titulo
      .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
  return 'prova_${nome.isEmpty ? prova.id : nome}.pdf';
}

String _letra(int indice) => String.fromCharCode(65 + indice);

/// Gera o PDF da prova: as questões em páginas próprias e o gabarito, com o QRCode,
/// em páginas separadas. Cada questão fica inteira na mesma página.
Future<Uint8List> gerarPdfProva(Prova prova) async {
  final documento = pw.Document(title: prova.titulo, author: 'ProvaLeve');

  pw.Widget qrCode(double tamanho) => pw.BarcodeWidget(
    barcode: bc.Barcode.qrCode(),
    data: conteudoQr(prova),
    width: tamanho,
    height: tamanho,
  );

  documento.addPage(
    pw.MultiPage(
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
                    'Disciplina: ${prova.disciplina}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Text(
                    'Nome: ______________________________________________',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Data: ____/____/________',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            qrCode(70),
          ],
        ),
        pw.Divider(height: 24),
        for (var i = 0; i < prova.questoes.length; i++)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 14),
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
                pw.SizedBox(height: 4),
                for (var j = 0; j < prova.questoes[i].alternativas.length; j++)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 12, top: 2),
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

  documento.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Gabarito',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '${prova.titulo} · ${prova.disciplina}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Leia o QRCode no aplicativo ProvaLeve para corrigir esta prova.',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            qrCode(110),
          ],
        ),
        pw.Divider(height: 24),
        pw.Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < prova.questoes.length; i++)
              pw.Container(
                width: 70,
                padding: const pw.EdgeInsets.symmetric(vertical: 6),
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  '${i + 1} - ${_letra(prova.questoes[i].indiceAlternativaCorreta)}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
      ],
    ),
  );

  return documento.save();
}
