import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

import 'package:app_mobile/models/prova.dart';
import 'package:app_mobile/models/resultado.dart';
import 'package:app_mobile/utils/correcao.dart';

String _nota(double nota) => nota.toStringAsFixed(1).replaceAll('.', ',');

/// Relatório da prova corrigida: status, resumo da turma e a nota de cada aluno.
Future<Uint8List> gerarPdfRelatorio(
  Prova prova,
  List<Resultado> resultados,
) async {
  final documento = pw.Document(
    title: 'Relatório - ${prova.titulo}',
    author: 'ProvaLeve',
  );
  final notas = resultados.map((r) => r.nota).toList();
  final media = notas.isEmpty
      ? 0.0
      : notas.fold<double>(0, (a, b) => a + b) / notas.length;
  final maior = notas.isEmpty ? 0.0 : notas.reduce((a, b) => a > b ? a : b);
  final menor = notas.isEmpty ? 0.0 : notas.reduce((a, b) => a < b ? a : b);
  final status = prova.status == 'corrigida' ? 'Corrigida' : prova.status;

  documento.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Text(
          'Relatório de correção',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Text('${prova.titulo} · ${prova.disciplina}'),
        if (prova.turmaNome != null) pw.Text('Turma: ${prova.turmaNome}'),
        pw.Text('Status da prova: $status'),
        pw.SizedBox(height: 10),
        pw.Text('Alunos corrigidos: ${resultados.length}'),
        pw.Text('Média da turma: ${_nota(media)}'),
        pw.Text('Maior nota: ${_nota(maior)}   Menor nota: ${_nota(menor)}'),
        pw.SizedBox(height: 14),
        pw.TableHelper.fromTextArray(
          headers: ['Aluno', 'Acertos', 'Nota'],
          data: [
            for (final r in resultados)
              [
                r.nomeAluno.isEmpty ? 'Sem nome' : r.nomeAluno,
                '${corrigirProva(prova, r.respostasMarcadas).acertos}/${prova.questoes.length}',
                _nota(r.nota),
              ],
          ],
        ),
      ],
    ),
  );
  return documento.save();
}
