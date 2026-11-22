import 'package:flutter/material.dart';

import 'package:app_mobile/models/prova.dart';

class _Cores {
  static const Color background = Color(0xFFF8F5F0);
  static const Color teal = Color(0xFF22555A);
  static const Color grayLine = Color(0xFFC3C6BF);
  static const Color cardWhite = Color(0xFFFBF9F5);
  static const Color subtitleColor = Color(0xFF3A484D);
  static const Color verde = Color(0xFF16846C);
}

/// Mostra a prova selecionada: título, disciplina, questões e alternativas,
/// com a alternativa correta destacada.
class VisualizarProvaScreen extends StatelessWidget {
  const VisualizarProvaScreen({super.key, required this.prova});

  final Prova prova;

  String _letra(int indice) => String.fromCharCode(65 + indice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Cores.background,
      appBar: AppBar(
        title: Text(prova.titulo),
        backgroundColor: _Cores.background,
        foregroundColor: _Cores.teal,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          Text(
            '${prova.disciplina} · ${prova.questoes.length} questões',
            style: const TextStyle(
              color: _Cores.subtitleColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < prova.questoes.length; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _Cores.cardWhite,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _Cores.grayLine.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${i + 1}. ${prova.questoes[i].enunciado}',
                    style: const TextStyle(
                      color: _Cores.teal,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (var j = 0; j < prova.questoes[i].alternativas.length; j++)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              '${_letra(j)}) ${prova.questoes[i].alternativas[j].texto}',
                              style: TextStyle(
                                color: j == prova.questoes[i].indiceAlternativaCorreta
                                    ? _Cores.verde
                                    : _Cores.subtitleColor,
                                fontWeight:
                                    j == prova.questoes[i].indiceAlternativaCorreta
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (j == prova.questoes[i].indiceAlternativaCorreta)
                            const Icon(
                              Icons.check_circle,
                              color: _Cores.verde,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
