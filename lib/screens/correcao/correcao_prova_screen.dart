import 'package:flutter/material.dart';

import 'package:app_mobile/data/provas_repository.dart';
import 'package:app_mobile/data/resultados_repository.dart';
import 'package:app_mobile/models/prova.dart';
import 'package:app_mobile/models/questao.dart';
import 'package:app_mobile/models/resultado.dart';
import 'package:app_mobile/utils/correcao.dart';
import 'package:app_mobile/utils/mensagem_erro.dart';
import 'package:app_mobile/utils/validators.dart';

class _Cores {
  static const Color background = Color(0xFFF8F5F0);
  static const Color teal = Color(0xFF22555A);
  static const Color grayLine = Color(0xFFC3C6BF);
  static const Color cardWhite = Color(0xFFFBF9F5);
  static const Color subtitleColor = Color(0xFF3A484D);
}

/// RF16: o professor marca as respostas do gabarito do aluno, o app corrige,
/// grava o [Resultado] no Firestore e marca a prova como corrigida.
/// Devolve o [Resultado] salvo no `pop`, ou `null` se o professor desistir.
class CorrecaoProvaScreen extends StatefulWidget {
  const CorrecaoProvaScreen({super.key, required this.prova});

  final Prova prova;

  @override
  State<CorrecaoProvaScreen> createState() => _CorrecaoProvaScreenState();
}

class _CorrecaoProvaScreenState extends State<CorrecaoProvaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeAlunoCtrl = TextEditingController();
  late final List<int> _respostas;
  bool _salvando = false;

  List<Questao> get _questoes => widget.prova.questoes;

  int get _emBranco => _respostas.where((r) => r == semResposta).length;

  @override
  void initState() {
    super.initState();
    _respostas = List.filled(_questoes.length, semResposta);
  }

  @override
  void dispose() {
    _nomeAlunoCtrl.dispose();
    super.dispose();
  }

  Future<void> _corrigir() async {
    if (!_formKey.currentState!.validate()) return;
    if (_emBranco > 0 && !await _confirmarEmBranco()) return;

    final correcao = corrigirProva(widget.prova, _respostas);
    final resultado = Resultado(
      id: 'res-${widget.prova.id}-${DateTime.now().millisecondsSinceEpoch}',
      provaId: widget.prova.id,
      nomeAluno: _nomeAlunoCtrl.text.trim(),
      respostasMarcadas: List.of(_respostas),
      nota: correcao.nota,
    );

    setState(() => _salvando = true);
    try {
      await ResultadosRepository.instance.criar(resultado);
      if (widget.prova.status != 'corrigida') {
        await ProvasRepository.instance.atualizar(_provaCorrigida());
      }
      if (!mounted) return;
      Navigator.of(context).pop(resultado);
    } catch (e) {
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar a correção. ${mensagemErro(e)}'),
        ),
      );
    }
  }

  Prova _provaCorrigida() {
    final prova = widget.prova;
    return Prova(
      id: prova.id,
      titulo: prova.titulo,
      disciplina: prova.disciplina,
      questoes: prova.questoes,
      dataCriacao: prova.dataCriacao,
      status: 'corrigida',
    );
  }

  Future<bool> _confirmarEmBranco() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Questões em branco'),
        content: Text(
          _emBranco == 1
              ? '1 questão está sem resposta e vai contar como erro. Deseja continuar?'
              : '$_emBranco questões estão sem resposta e vão contar como erro. Deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Corrigir mesmo assim'),
          ),
        ],
      ),
    );
    return confirmar ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Cores.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  children: [
                    Text(
                      '${widget.prova.titulo} · ${widget.prova.disciplina}',
                      style: const TextStyle(
                        color: _Cores.subtitleColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nomeAlunoCtrl,
                      textCapitalization: TextCapitalization.words,
                      validator: Validators.nome,
                      decoration: InputDecoration(
                        labelText: 'Nome do aluno',
                        filled: true,
                        fillColor: _Cores.cardWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Marque a alternativa que o aluno escolheu em cada questão',
                      style: TextStyle(
                        color: _Cores.teal,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (var i = 0; i < _questoes.length; i++) ...[
                      _buildQuestao(i),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
              _buildBarraCorrigir(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, color: _Cores.teal),
          ),
          const Expanded(
            child: Text(
              'Corrigir prova',
              style: TextStyle(
                color: _Cores.teal,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestao(int indice) {
    final questao = _questoes[indice];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _Cores.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _Cores.grayLine.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${indice + 1}. ${questao.enunciado}',
            style: const TextStyle(
              color: _Cores.subtitleColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              for (var alt = 0; alt < questao.alternativas.length; alt++)
                ChoiceChip(
                  label: Text(String.fromCharCode(65 + alt)),
                  selected: _respostas[indice] == alt,
                  selectedColor: _Cores.teal,
                  labelStyle: TextStyle(
                    color: _respostas[indice] == alt
                        ? Colors.white
                        : _Cores.teal,
                    fontWeight: FontWeight.w700,
                  ),
                  showCheckmark: false,
                  // Tocar de novo na mesma letra deixa a questão em branco.
                  onSelected: (_) => setState(() {
                    _respostas[indice] = _respostas[indice] == alt
                        ? semResposta
                        : alt;
                  }),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarraCorrigir() {
    final respondidas = _questoes.length - _emBranco;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: _Cores.cardWhite,
        border: Border(
          top: BorderSide(color: _Cores.grayLine.withValues(alpha: 0.4)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$respondidas de ${_questoes.length} marcadas',
              style: const TextStyle(
                color: _Cores.subtitleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _Cores.teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            onPressed: _salvando ? null : _corrigir,
            icon: _salvando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_circle_outline),
            label: const Text(
              'Corrigir e salvar',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
