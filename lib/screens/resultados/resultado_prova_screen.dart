import 'package:flutter/material.dart';

import 'package:app_mobile/models/prova.dart';
import 'package:app_mobile/models/resultado.dart';
import 'package:app_mobile/screens/splash.dart';

enum _Filtro { todas, acertos, erros }

class ResultadoProvaScreen extends StatefulWidget {
  const ResultadoProvaScreen({
    super.key,
    required this.prova,
    required this.resultado,
  });

  final Prova prova;
  final Resultado resultado;

  @override
  State<ResultadoProvaScreen> createState() => _ResultadoProvaScreenState();
}

class _ResultadoProvaScreenState extends State<ResultadoProvaScreen> {
  _Filtro _filtro = _Filtro.todas;

  String _letra(int indice) => String.fromCharCode(65 + indice);

  String _mensagemDesempenho(double percentual) {
    if (percentual >= 0.9) return 'Excelente!';
    if (percentual >= 0.7) return 'Muito bom!';
    if (percentual >= 0.5) return 'Dá pra melhorar';
    return 'Vamos praticar mais';
  }

  @override
  Widget build(BuildContext context) {
    final questoes = widget.prova.questoes;
    final respostas = widget.resultado.respostasMarcadas;

    final acertosIndices = <int>[];
    final errosIndices = <int>[];
    for (var i = 0; i < questoes.length; i++) {
      if (respostas[i] == questoes[i].indiceAlternativaCorreta) {
        acertosIndices.add(i);
      } else {
        errosIndices.add(i);
      }
    }

    final percentual = questoes.isEmpty ? 0.0 : acertosIndices.length / questoes.length;

    final indicesVisiveis = switch (_filtro) {
      _Filtro.todas => List.generate(questoes.length, (i) => i),
      _Filtro.acertos => acertosIndices,
      _Filtro.erros => errosIndices,
    };

    return Scaffold(
      backgroundColor: SplashScreen.background,
      appBar: AppBar(
        backgroundColor: SplashScreen.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: SplashScreen.teal),
        title: const Text(
          'Resultado da prova',
          style: TextStyle(
            color: SplashScreen.teal,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: SplashScreen.teal),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [
            _CartaoResumo(
              prova: widget.prova,
              nota: widget.resultado.nota,
              acertos: acertosIndices.length,
              total: questoes.length,
              mensagem: _mensagemDesempenho(percentual),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _CartaoContagem(
                    icone: Icons.check_circle,
                    cor: SplashScreen.teal,
                    valor: acertosIndices.length,
                    label: 'Acertos',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CartaoContagem(
                    icone: Icons.cancel,
                    cor: SplashScreen.orange,
                    valor: errosIndices.length,
                    label: 'Erros',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _FiltroTabs(
              filtroAtual: _filtro,
              onSelecionar: (f) => setState(() => _filtro = f),
            ),
            const SizedBox(height: 16),
            ...indicesVisiveis.map((i) {
              final questao = questoes[i];
              final marcou = respostas[i];
              final acertou = marcou == questao.indiceAlternativaCorreta;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _QuestaoResultadoCard(
                  numero: i + 1,
                  enunciado: questao.enunciado,
                  respostaMarcada: _letra(marcou),
                  respostaCorreta: _letra(questao.indiceAlternativaCorreta),
                  acertou: acertou,
                ),
              );
            }),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Compartilhamento ainda não disponível nesta versão.')),
                      );
                    },
                    icon: const Icon(Icons.ios_share, size: 18),
                    label: const Text('Compartilhar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SplashScreen.teal,
                      side: const BorderSide(color: SplashScreen.teal),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SplashScreen.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Voltar às provas'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartaoResumo extends StatelessWidget {
  const _CartaoResumo({
    required this.prova,
    required this.nota,
    required this.acertos,
    required this.total,
    required this.mensagem,
  });

  final Prova prova;
  final double nota;
  final int acertos;
  final int total;
  final String mensagem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SplashScreen.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SplashScreen.grayLine.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prova.titulo,
            style: const TextStyle(
              color: SplashScreen.teal,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            prova.disciplina,
            style: const TextStyle(
              color: SplashScreen.subtitleColor,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 88,
                height: 88,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 88,
                      height: 88,
                      child: CircularProgressIndicator(
                        value: total == 0 ? 0 : acertos / total,
                        strokeWidth: 8,
                        backgroundColor: SplashScreen.sage.withValues(alpha: 0.25),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          SplashScreen.teal,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          nota.toStringAsFixed(1),
                          style: const TextStyle(
                            color: SplashScreen.teal,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          'de 10',
                          style: TextStyle(
                            color: SplashScreen.subtitleColor,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mensagem,
                      style: const TextStyle(
                        color: SplashScreen.teal,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Você acertou $acertos de $total questões',
                      style: const TextStyle(
                        color: SplashScreen.subtitleColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartaoContagem extends StatelessWidget {
  const _CartaoContagem({
    required this.icone,
    required this.cor,
    required this.valor,
    required this.label,
  });

  final IconData icone;
  final Color cor;
  final int valor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: SplashScreen.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SplashScreen.grayLine.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Icon(icone, color: cor),
          const SizedBox(height: 6),
          Text(
            '$valor',
            style: TextStyle(
              color: cor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: SplashScreen.subtitleColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltroTabs extends StatelessWidget {
  const _FiltroTabs({required this.filtroAtual, required this.onSelecionar});

  final _Filtro filtroAtual;
  final ValueChanged<_Filtro> onSelecionar;

  @override
  Widget build(BuildContext context) {
    Widget pill(_Filtro filtro, String texto) {
      final selecionado = filtro == filtroAtual;
      return Expanded(
        child: GestureDetector(
          onTap: () => onSelecionar(filtro),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selecionado ? SplashScreen.teal : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              texto,
              style: TextStyle(
                color: selecionado ? Colors.white : SplashScreen.subtitleColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: SplashScreen.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SplashScreen.grayLine.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          pill(_Filtro.todas, 'Todas'),
          pill(_Filtro.acertos, 'Acertos'),
          pill(_Filtro.erros, 'Erros'),
        ],
      ),
    );
  }
}

class _QuestaoResultadoCard extends StatelessWidget {
  const _QuestaoResultadoCard({
    required this.numero,
    required this.enunciado,
    required this.respostaMarcada,
    required this.respostaCorreta,
    required this.acertou,
  });

  final int numero;
  final String enunciado;
  final String respostaMarcada;
  final String respostaCorreta;
  final bool acertou;

  @override
  Widget build(BuildContext context) {
    final cor = acertou ? SplashScreen.teal : SplashScreen.orange;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SplashScreen.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cor.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: SplashScreen.teal.withValues(alpha: 0.10),
            child: Text(
              '$numero',
              style: const TextStyle(
                color: SplashScreen.teal,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  enunciado,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: SplashScreen.subtitleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sua resposta: $respostaMarcada',
                  style: const TextStyle(
                    fontSize: 12,
                    color: SplashScreen.subtitleColor,
                  ),
                ),
                if (!acertou)
                  Text(
                    'Correta: $respostaCorreta',
                    style: const TextStyle(
                      fontSize: 12,
                      color: SplashScreen.teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              Icon(
                acertou ? Icons.check_circle : Icons.cancel,
                color: cor,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                acertou ? 'Correta' : 'Incorreta',
                style: TextStyle(color: cor, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}