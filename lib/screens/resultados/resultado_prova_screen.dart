import 'package:flutter/material.dart';

import 'package:app_mobile/models/prova.dart';
import 'package:app_mobile/models/questao.dart';
import 'package:app_mobile/models/resultado.dart';

enum _Filtro { todas, acertos, erros }

// Cores da tela de resultado
class _Cores {
  static const fundo = Color(0xFFFCFDFC);
  static const titulo = Color(0xFF064D65);
  static const texto = Color(0xFF173568);
  static const secundario = Color(0xFF586F98);
  static const teal = Color(0xFF087D8B);
  static const verde = Color(0xFF16846C);
  static const vermelho = Color(0xFFBD3F3C);
  static const acerto = Color(0xFFF0F8F4);
  static const erro = Color(0xFFFFF3F3);
  static const seloAcerto = Color(0xFFDFF1E9);
  static const seloErro = Color(0xFFFFDEDC);
  static const linha = Color(0xFFEDF0F0);
}

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

  int _resposta(int indice) =>
      indice < widget.resultado.respostasMarcadas.length
      ? widget.resultado.respostasMarcadas[indice]
      : -1;

  bool _acertou(int indice) {
    final questao = widget.prova.questoes[indice];
    final resposta = _resposta(indice);
    return resposta >= 0 &&
        resposta < questao.alternativas.length &&
        resposta == questao.indiceAlternativaCorreta;
  }

  String _letra(Questao questao, int indice) =>
      indice >= 0 && indice < questao.alternativas.length
      ? String.fromCharCode(65 + indice)
      : 'Não respondida';

  String _mensagemDesempenho(double percentual) {
    if (percentual >= 0.9) return 'Excelente!';
    if (percentual >= 0.7) return 'Muito bom!';
    if (percentual >= 0.5) return 'Dá pra melhorar';
    return 'Vamos praticar mais';
  }

  void _compartilhar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Compartilhamento ainda não disponível nesta versão.'),
      ),
    );
  }

  void _voltar() => Navigator.of(context).maybePop();

  void _abrirQuestao(int indice) {
    final questao = widget.prova.questoes[indice];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Questão ${indice + 1}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _Cores.titulo,
                ),
              ),
              const SizedBox(height: 16),
              Text(questao.enunciado),
              const SizedBox(height: 16),
              for (var i = 0; i < questao.alternativas.length; i++)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text(_letra(questao, i)),
                  title: Text(questao.alternativas[i].texto),
                  subtitle: i == _resposta(indice)
                      ? const Text('Sua resposta')
                      : null,
                  trailing: i == questao.indiceAlternativaCorreta
                      ? const Icon(Icons.check, color: _Cores.verde)
                      : null,
                ),
              const SizedBox(height: 8),
              Text(
                'Resposta correta: ${_letra(questao, questao.indiceAlternativaCorreta)}',
                style: const TextStyle(
                  color: _Cores.verde,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questoes = widget.prova.questoes;
    final acertos = List.generate(
      questoes.length,
      (i) => i,
    ).where(_acertou).length;
    final percentual = questoes.isEmpty ? 0.0 : acertos / questoes.length;
    final indices = List.generate(questoes.length, (i) => i)
        .where(
          (i) => switch (_filtro) {
            _Filtro.todas => true,
            _Filtro.acertos => _acertou(i),
            _Filtro.erros => !_acertou(i),
          },
        )
        .toList();

    return Scaffold(
      backgroundColor: _Cores.fundo,
      appBar: AppBar(
        backgroundColor: _Cores.fundo,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 48,
        leading: IconButton(
          tooltip: 'Voltar',
          onPressed: _voltar,
          icon: const Icon(Icons.chevron_left, color: _Cores.titulo),
        ),
        titleSpacing: 0,
        title: const Text(
          'Resultado da prova',
          style: TextStyle(
            color: _Cores.titulo,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Mais opções',
            icon: const Icon(Icons.more_vert, color: _Cores.titulo),
            onSelected: (value) =>
                value == 'compartilhar' ? _compartilhar() : _voltar(),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'compartilhar', child: Text('Compartilhar')),
              PopupMenuItem(value: 'voltar', child: Text('Voltar às provas')),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _Rodape(
        onCompartilhar: _compartilhar,
        onVoltar: _voltar,
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
          children: [
            _CartaoResumo(
              prova: widget.prova,
              nota: widget.resultado.nota,
              acertos: acertos,
              mensagem: _mensagemDesempenho(percentual),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _CartaoContagem(valor: acertos, acerto: true)),
                const SizedBox(width: 10),
                Expanded(
                  child: _CartaoContagem(
                    valor: questoes.length - acertos,
                    acerto: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _FiltroTabs(
              filtroAtual: _filtro,
              onSelecionar: (f) => setState(() => _filtro = f),
            ),
            const SizedBox(height: 12),
            if (indices.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  switch (_filtro) {
                    _Filtro.todas => 'Esta prova não tem questões.',
                    _Filtro.acertos => 'Nenhuma questão correta.',
                    _Filtro.erros => 'Nenhuma questão incorreta.',
                  },
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: _Cores.secundario),
                ),
              ),
            for (final i in indices)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _QuestaoResultadoCard(
                  numero: i + 1,
                  enunciado: questoes[i].enunciado,
                  respostaMarcada: _letra(questoes[i], _resposta(i)),
                  respostaCorreta: _letra(
                    questoes[i],
                    questoes[i].indiceAlternativaCorreta,
                  ),
                  acertou: _acertou(i),
                  onTap: () => _abrirQuestao(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _cartao({double raio = 12}) => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(raio),
  border: Border.all(color: _Cores.linha),
  boxShadow: const [
    BoxShadow(color: Color(0x07064D65), offset: Offset(0, 3), blurRadius: 8),
  ],
);

class _CartaoResumo extends StatelessWidget {
  const _CartaoResumo({
    required this.prova,
    required this.nota,
    required this.acertos,
    required this.mensagem,
  });
  final Prova prova;
  final double nota;
  final int acertos;
  final String mensagem;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: _cartao(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          prova.titulo,
          style: const TextStyle(
            color: _Cores.texto,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          prova.disciplina,
          style: const TextStyle(color: _Cores.secundario, fontSize: 13),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: prova.questoes.isEmpty
                          ? 0
                          : acertos / prova.questoes.length,
                      strokeWidth: 11,
                      strokeCap: StrokeCap.round,
                      backgroundColor: const Color(0xFFDBEFED),
                      color: const Color(0xFF159698),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        nota.toStringAsFixed(1).replaceAll('.', ','),
                        style: const TextStyle(
                          color: _Cores.titulo,
                          fontSize: 42,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text(
                        'de 10',
                        style: TextStyle(
                          color: _Cores.secundario,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 22),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Brilhos(),
                  const SizedBox(height: 8),
                  Text(
                    mensagem,
                    style: const TextStyle(
                      color: _Cores.titulo,
                      fontSize: 24,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Você acertou $acertos de ${prova.questoes.length} questões',
                    style: const TextStyle(
                      color: _Cores.secundario,
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: _Brilhos(),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
      ],
    ),
  );
}

class _Brilhos extends StatelessWidget {
  const _Brilhos();
  @override
  Widget build(BuildContext context) => const ExcludeSemantics(
    child: SizedBox(
      width: 40,
      height: 25,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Icon(
              Icons.star_rate_rounded,
              size: 14,
              color: Color(0xFF98CEBD),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              Icons.star_rate_rounded,
              size: 21,
              color: Color(0xFF98CEBD),
            ),
          ),
        ],
      ),
    ),
  );
}

class _CartaoContagem extends StatelessWidget {
  const _CartaoContagem({required this.valor, required this.acerto});
  final int valor;
  final bool acerto;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
    decoration: _cartao(),
    child: Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: acerto ? _Cores.seloAcerto : _Cores.seloErro,
          child: Icon(
            acerto ? Icons.check : Icons.close,
            color: acerto ? _Cores.verde : _Cores.vermelho,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$valor',
                style: const TextStyle(
                  color: _Cores.texto,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                acerto ? 'Acertos' : 'Erros',
                style: const TextStyle(color: _Cores.secundario, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _FiltroTabs extends StatelessWidget {
  const _FiltroTabs({required this.filtroAtual, required this.onSelecionar});
  final _Filtro filtroAtual;
  final ValueChanged<_Filtro> onSelecionar;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: _cartao(raio: 16),
    child: Row(
      children: [
        for (final filtro in _Filtro.values)
          Expanded(
            child: Semantics(
              selected: filtro == filtroAtual,
              child: TextButton(
                onPressed: () => onSelecionar(filtro),
                style: TextButton.styleFrom(
                  backgroundColor: filtro == filtroAtual
                      ? _Cores.teal
                      : Colors.transparent,
                  foregroundColor: filtro == filtroAtual
                      ? Colors.white
                      : _Cores.secundario,
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: Text(switch (filtro) {
                  _Filtro.todas => 'Todas',
                  _Filtro.acertos => 'Acertos',
                  _Filtro.erros => 'Erros',
                }),
              ),
            ),
          ),
      ],
    ),
  );
}

class _QuestaoResultadoCard extends StatelessWidget {
  const _QuestaoResultadoCard({
    required this.numero,
    required this.enunciado,
    required this.respostaMarcada,
    required this.respostaCorreta,
    required this.acertou,
    required this.onTap,
  });
  final int numero;
  final String enunciado;
  final String respostaMarcada;
  final String respostaCorreta;
  final bool acertou;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cor = acertou ? _Cores.verde : _Cores.vermelho;
    final selo = acertou ? _Cores.seloAcerto : _Cores.seloErro;
    return Material(
      color: acertou ? _Cores.acerto : _Cores.erro,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: selo.withValues(alpha: 0.7)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: selo,
                child: Text(
                  '$numero',
                  style: TextStyle(
                    color: cor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$numero. $enunciado',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _Cores.texto,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Sua resposta: $respostaMarcada',
                      style: const TextStyle(
                        color: _Cores.secundario,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                    if (!acertou)
                      Text(
                        'Correta: $respostaCorreta',
                        style: const TextStyle(
                          color: _Cores.secundario,
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                decoration: BoxDecoration(
                  color: selo,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      acertou ? Icons.check : Icons.close,
                      color: cor,
                      size: 13,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      acertou ? 'Correta' : 'Incorreta',
                      style: TextStyle(
                        color: cor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(0xFF8DA3BD),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Rodape extends StatelessWidget {
  const _Rodape({required this.onCompartilhar, required this.onVoltar});
  final VoidCallback onCompartilhar;
  final VoidCallback onVoltar;
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: _Cores.linha)),
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onCompartilhar,
                icon: const Icon(Icons.ios_share, size: 20),
                label: const Text('Compartilhar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _Cores.titulo,
                  side: const BorderSide(color: _Cores.linha),
                  minimumSize: const Size(0, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: onVoltar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _Cores.teal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 48),
                  elevation: 2,
                  shadowColor: _Cores.teal.withValues(alpha: 0.25),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Voltar às provas'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
