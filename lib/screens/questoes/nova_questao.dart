import 'package:flutter/material.dart';

import 'package:app_mobile/models/alternativa.dart';
import 'package:app_mobile/models/questao.dart';
import 'questao_cadastrada.dart';

// Paleta compartilhada com as demais telas (ver splash.dart)
class _Cores {
  static const Color background = Color(0xFFF8F5F0);
  static const Color teal = Color(0xFF22555A);
  static const Color sage = Color(0xFF94AB9B);
  static const Color grayLine = Color(0xFFC3C6BF);
  static const Color cardWhite = Color(0xFFFBF9F5);
  static const Color subtitleColor = Color(0xFF3A484D);
  static const Color danger = Color(0xFFD16A6A);
}

const List<String> _disciplinas = [
  'Matemática',
  'Ciências',
  'História',
  'Geografia',
  'Português',
];

const String _dificuldadePadrao = 'Fácil';

class _AlternativaEdit {
  final String chave = UniqueKey().toString();
  final TextEditingController controller;
  _AlternativaEdit([String texto = '']) : controller = TextEditingController(text: texto);
}

class NovaQuestaoScreen extends StatefulWidget {
  final QuestaoCadastrada? itemParaEditar;

  const NovaQuestaoScreen({super.key, this.itemParaEditar});

  @override
  State<NovaQuestaoScreen> createState() => _NovaQuestaoScreenState();
}

class _NovaQuestaoScreenState extends State<NovaQuestaoScreen> {
  static const int _limiteEnunciado = 500;

  late final TextEditingController _enunciadoController;
  String? _disciplina;
  final List<_AlternativaEdit> _alternativas = [];
  int _indiceCorreta = -1;
  String? _erro;

  bool get _editando => widget.itemParaEditar != null;

  @override
  void initState() {
    super.initState();
    final item = widget.itemParaEditar;
    final questao = item?.questao;
    _enunciadoController = TextEditingController(text: questao?.enunciado ?? '');
    _disciplina = item?.disciplina;

    if (questao != null) {
      final ordenadas = [...questao.alternativas]
        ..sort((a, b) => a.ordem.compareTo(b.ordem));
      for (final alt in ordenadas) {
        _alternativas.add(_AlternativaEdit(alt.texto));
      }
      _indiceCorreta = questao.indiceAlternativaCorreta;
    } else {
      for (var i = 0; i < 4; i++) {
        _alternativas.add(_AlternativaEdit());
      }
      _indiceCorreta = -1;
    }

    _enunciadoController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _enunciadoController.dispose();
    for (final alt in _alternativas) {
      alt.controller.dispose();
    }
    super.dispose();
  }

  String _letra(int indice) => String.fromCharCode(65 + indice);

  void _adicionarAlternativa() {
    setState(() => _alternativas.add(_AlternativaEdit()));
  }

  void _removerAlternativa(int indice) {
    if (_alternativas.length <= 2) {
      setState(() => _erro = 'A questão precisa de pelo menos 2 alternativas.');
      return;
    }
    setState(() {
      _alternativas[indice].controller.dispose();
      _alternativas.removeAt(indice);
      if (_indiceCorreta == indice) {
        _indiceCorreta = -1;
      } else if (_indiceCorreta > indice) {
        _indiceCorreta--;
      }
    });
  }

  void _reordenarAlternativas(int oldIndex, int newIndex) {
    setState(() {
      final item = _alternativas.removeAt(oldIndex);
      _alternativas.insert(newIndex, item);
      if (_indiceCorreta == oldIndex) {
        _indiceCorreta = newIndex;
      } else if (oldIndex < _indiceCorreta && newIndex >= _indiceCorreta) {
        _indiceCorreta--;
      } else if (oldIndex > _indiceCorreta && newIndex <= _indiceCorreta) {
        _indiceCorreta++;
      }
    });
  }

  QuestaoCadastrada? _montarItem({required bool exigirCompleta}) {
    final enunciado = _enunciadoController.text.trim();

    if (exigirCompleta) {
      if (_disciplina == null) {
        setState(() => _erro = 'Selecione a disciplina da questão.');
        return null;
      }
      if (enunciado.isEmpty) {
        setState(() => _erro = 'Escreva o enunciado da questão.');
        return null;
      }
      if (_alternativas.any((a) => a.controller.text.trim().isEmpty)) {
        setState(() => _erro = 'Preencha o texto de todas as alternativas.');
        return null;
      }
      if (_indiceCorreta < 0 || _indiceCorreta >= _alternativas.length) {
        setState(() => _erro = 'Marque qual alternativa é a resposta correta.');
        return null;
      }
    }

    setState(() => _erro = null);

    final alternativas = <Alternativa>[
      for (var i = 0; i < _alternativas.length; i++)
        Alternativa(texto: _alternativas[i].controller.text.trim(), ordem: i),
    ];

    final questao = Questao(
      id: widget.itemParaEditar?.questao.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      enunciado: enunciado,
      alternativas: alternativas,
      indiceAlternativaCorreta: _indiceCorreta,
    );

    return QuestaoCadastrada(
      questao: questao,
      disciplina: _disciplina ?? '',
      dificuldade: widget.itemParaEditar?.dificuldade ?? _dificuldadePadrao,
    );
  }

  void _salvarRascunho() {
    final item = _montarItem(exigirCompleta: false);
    if (item == null) return;
    Navigator.of(context).pop(item);
  }

  void _salvarQuestao() {
    final item = _montarItem(exigirCompleta: true);
    if (item == null) return;
    Navigator.of(context).pop(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Cores.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  if (_erro != null) _buildAviso(_erro!),
                  const SizedBox(height: 4),
                  _buildRotulo('Disciplina'),
                  const SizedBox(height: 8),
                  _buildSeletorDisciplina(),
                  const SizedBox(height: 20),
                  _buildRotulo('Enunciado'),
                  const SizedBox(height: 8),
                  _buildCampoEnunciado(),
                  const SizedBox(height: 24),
                  const Text(
                    'Alternativas',
                    style: TextStyle(
                      color: _Cores.teal,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Marque a resposta correta',
                    style: TextStyle(color: _Cores.subtitleColor, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  _buildListaAlternativas(),
                  const SizedBox(height: 12),
                  _buildBotaoAdicionar(),
                ],
              ),
            ),
            _buildBarraSalvar(),
          ],
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
          Expanded(
            child: Text(
              _editando ? 'Editar questão' : 'Nova questão',
              style: const TextStyle(
                color: _Cores.teal,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: _salvarRascunho,
            child: const Text(
              'Salvar rascunho',
              style: TextStyle(
                color: _Cores.sage,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAviso(String mensagem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _Cores.danger.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _Cores.danger.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: _Cores.danger, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              mensagem,
              style: const TextStyle(color: _Cores.danger, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRotulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        color: _Cores.subtitleColor,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSeletorDisciplina() {
    return Container(
      decoration: BoxDecoration(
        color: _Cores.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _Cores.grayLine.withValues(alpha: 0.6)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _disciplina,
          isExpanded: true,
          hint: const Text('Selecione a disciplina'),
          icon: const Icon(Icons.keyboard_arrow_down, color: _Cores.teal),
          style: const TextStyle(
            color: _Cores.subtitleColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          items: _disciplinas
              .map((d) => DropdownMenuItem(value: d, child: Text(d)))
              .toList(),
          onChanged: (valor) => setState(() => _disciplina = valor),
        ),
      ),
    );
  }

  Widget _buildCampoEnunciado() {
    final tamanho = _enunciadoController.text.characters.length;
    return Container(
      decoration: BoxDecoration(
        color: _Cores.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _Cores.grayLine.withValues(alpha: 0.6)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _enunciadoController,
            maxLength: _limiteEnunciado,
            maxLines: 4,
            minLines: 3,
            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
            decoration: const InputDecoration(
              hintText: 'Digite o enunciado da questão',
              border: InputBorder.none,
              isDense: true,
            ),
            style: const TextStyle(color: _Cores.subtitleColor, fontSize: 15),
          ),
          Text(
            '$tamanho/$_limiteEnunciado',
            style: const TextStyle(color: _Cores.grayLine, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildListaAlternativas() {
    return RadioGroup<int>(
      groupValue: _indiceCorreta,
      onChanged: (valor) => setState(() => _indiceCorreta = valor ?? -1),
      child: ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        buildDefaultDragHandles: false,
        itemCount: _alternativas.length,
        onReorderItem: _reordenarAlternativas,
        itemBuilder: (context, index) {
          final alt = _alternativas[index];
          return Dismissible(
            key: ValueKey(alt.chave),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) async {
              _removerAlternativa(index);
              return false;
            },
            background: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: _Cores.danger.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.delete_outline, color: _Cores.danger),
            ),
            child: Container(
              key: ValueKey('conteudo-${alt.chave}'),
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: index == _indiceCorreta
                    ? _Cores.sage.withValues(alpha: 0.18)
                    : _Cores.cardWhite,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: index == _indiceCorreta
                      ? _Cores.sage
                      : _Cores.grayLine.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  ReorderableDragStartListener(
                    index: index,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.drag_indicator, color: _Cores.grayLine),
                    ),
                  ),
                  const SizedBox(width: 4),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: _Cores.teal.withValues(alpha: 0.10),
                    child: Text(
                      _letra(index),
                      style: const TextStyle(
                        color: _Cores.teal,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: alt.controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: 'Texto da alternativa',
                      ),
                      style: const TextStyle(color: _Cores.subtitleColor, fontSize: 15),
                    ),
                  ),
                  Radio<int>(
                    value: index,
                    activeColor: _Cores.sage,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBotaoAdicionar() {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: _adicionarAlternativa,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _Cores.grayLine),
        ),
        alignment: Alignment.center,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: _Cores.teal, size: 18),
            SizedBox(width: 6),
            Text(
              'Adicionar alternativa',
              style: TextStyle(
                color: _Cores.teal,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarraSalvar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: _Cores.background,
        border: Border(top: BorderSide(color: _Cores.grayLine.withValues(alpha: 0.4))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _salvarQuestao,
          style: ElevatedButton.styleFrom(
            backgroundColor: _Cores.teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: const Text(
            'Salvar questão',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
