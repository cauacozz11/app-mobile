import 'package:flutter/material.dart';

import 'package:app_mobile/models/alternativa.dart';
import 'package:app_mobile/models/prova.dart';
import 'package:app_mobile/models/questao.dart';

class _Cores {
  static const Color background = Color(0xFFF8F5F0);
  static const Color teal = Color(0xFF22555A);
  static const Color grayLine = Color(0xFFC3C6BF);
  static const Color cardWhite = Color(0xFFFBF9F5);
  static const Color subtitleColor = Color(0xFF3A484D);
}

class _QuestaoItemBanco {
  final Questao questao;
  final String disciplina;
  final String? dificuldade;

  const _QuestaoItemBanco({
    required this.questao,
    required this.disciplina,
    this.dificuldade,
  });
}

class ConclusaoProva {
  const ConclusaoProva({required this.prova, required this.postada});

  final Prova prova;
  final bool postada;
}

class CriarProvaModal extends StatefulWidget {
  const CriarProvaModal({super.key, this.provaInicial});

  final Prova? provaInicial;

  static Future<ConclusaoProva?> exibir(
    BuildContext context, {
    Prova? provaInicial,
  }) {
    return showModalBottomSheet<ConclusaoProva>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CriarProvaModal(provaInicial: provaInicial),
    );
  }

  @override
  State<CriarProvaModal> createState() => _CriarProvaModalState();
}

class _CriarProvaModalState extends State<CriarProvaModal> {
  final TextEditingController _tituloController = TextEditingController(
    text: 'Matemática — 8º ano',
  );
  final TextEditingController _buscaController = TextEditingController();

  String _disciplinaSelecionada = 'Matemática';
  String _buscaQuestoes = '';
  String _filtroDificuldade = 'Todas';

  static const List<String> _disciplinas = [
    'Matemática',
    'Ciências',
    'História',
    'Geografia',
    'Português',
  ];

  late final List<_QuestaoItemBanco> _questoesDisponiveis;
  final Set<String> _questoesSelecionadasIds = {};

  @override
  void initState() {
    super.initState();
    final banco = _carregarQuestoes();
    final prova = widget.provaInicial;
    if (prova != null) {
      _tituloController.text = prova.titulo;
      _disciplinaSelecionada = prova.disciplina;
      final bancoPorId = {for (final item in banco) item.questao.id: item};
      _questoesSelecionadasIds.addAll(prova.questoes.map((q) => q.id));
      // Mantém a ordem e os dados do rascunho, mesmo fora do banco mock.
      _questoesDisponiveis = [
        for (final questao in prova.questoes)
          _QuestaoItemBanco(
            questao: questao,
            disciplina: bancoPorId[questao.id]?.disciplina ?? prova.disciplina,
            dificuldade: bancoPorId[questao.id]?.dificuldade,
          ),
        ...banco.where(
          (item) => !_questoesSelecionadasIds.contains(item.questao.id),
        ),
      ];
      return;
    }
    _questoesDisponiveis = banco;
    // Seleciona 3 questões iniciais
    if (_questoesDisponiveis.length >= 3) {
      _questoesSelecionadasIds.add(_questoesDisponiveis[0].questao.id);
      _questoesSelecionadasIds.add(_questoesDisponiveis[1].questao.id);
      _questoesSelecionadasIds.add(_questoesDisponiveis[2].questao.id);
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _buscaController.dispose();
    super.dispose();
  }

  List<_QuestaoItemBanco> get _questoesFiltradas {
    return _questoesDisponiveis.where((q) {
      final passaDisciplina = q.disciplina == _disciplinaSelecionada;
      final passaDificuldade =
          _filtroDificuldade == 'Todas' || q.dificuldade == _filtroDificuldade;
      final termo = _buscaQuestoes.trim().toLowerCase();
      final passaBusca =
          termo.isEmpty || q.questao.enunciado.toLowerCase().contains(termo);
      return passaDisciplina && passaDificuldade && passaBusca;
    }).toList();
  }

  void _alternarQuestao(String id) {
    setState(() {
      if (_questoesSelecionadasIds.contains(id)) {
        _questoesSelecionadasIds.remove(id);
      } else {
        _questoesSelecionadasIds.add(id);
      }
    });
  }

  void _concluirCriacao({required bool postar}) {
    final titulo = _tituloController.text.trim();
    if (titulo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, informe o título da prova.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_questoesSelecionadasIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione ao menos 1 questão para a prova.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final questoes = _questoesDisponiveis
        .where((q) => _questoesSelecionadasIds.contains(q.questao.id))
        .map((q) => q.questao)
        .toList();

    final novaProva = Prova(
      id:
          widget.provaInicial?.id ??
          'prova-${DateTime.now().millisecondsSinceEpoch}',
      titulo: titulo,
      disciplina: _disciplinaSelecionada,
      dataCriacao: widget.provaInicial?.dataCriacao ?? DateTime.now(),
      questoes: questoes,
    );

    Navigator.of(context)
        .pop(ConclusaoProva(prova: novaProva, postada: postar));
  }

  @override
  Widget build(BuildContext context) {
    final filtradas = _questoesFiltradas;
    final totalSelecionadas = _questoesSelecionadasIds.length;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: _Cores.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Barra de arrasto superior
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 42,
              height: 4.5,
              decoration: BoxDecoration(
                color: _Cores.grayLine.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),

          // Header do Modal: "Criar prova"
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 20, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: _Cores.subtitleColor,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Text(
                  'Criar prova',
                  style: TextStyle(
                    color: _Cores.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _Cores.cardWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _Cores.grayLine.withValues(alpha: 0.45),
                    ),
                  ),
                  child: const Text(
                    'Etapa 1 de 2',
                    style: TextStyle(
                      color: _Cores.subtitleColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E2D9)),

          // Corpo rolável do formulário
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
              children: [
                // Seção: Informações da prova
                const Text(
                  'Informações da prova',
                  style: TextStyle(
                    color: _Cores.teal,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),

                // Título da prova
                const Text(
                  'Título da prova',
                  style: TextStyle(
                    color: _Cores.subtitleColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: _Cores.cardWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _Cores.grayLine.withValues(alpha: 0.5),
                    ),
                  ),
                  child: TextField(
                    controller: _tituloController,
                    style: const TextStyle(
                      color: _Cores.subtitleColor,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Ex: Matemática — 8º ano',
                      hintStyle: TextStyle(color: _Cores.grayLine),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Disciplina (Dropdown)
                const Text(
                  'Disciplina',
                  style: TextStyle(
                    color: _Cores.subtitleColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: _Cores.cardWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _Cores.grayLine.withValues(alpha: 0.5),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _disciplinaSelecionada,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: _Cores.subtitleColor,
                      ),
                      items: {..._disciplinas, _disciplinaSelecionada}.map((d) {
                        return DropdownMenuItem<String>(
                          value: d,
                          child: Text(
                            d,
                            style: const TextStyle(
                              color: _Cores.subtitleColor,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (novo) {
                        if (novo != null) {
                          setState(() => _disciplinaSelecionada = novo);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Selecionar questões
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Selecionar questões',
                      style: TextStyle(
                        color: _Cores.teal,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _Cores.cardWhite,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _Cores.grayLine.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        '$totalSelecionadas selecionadas',
                        style: const TextStyle(
                          color: _Cores.teal,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Busca no banco de questões + botão de filtro
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: _Cores.cardWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _Cores.grayLine.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search_rounded,
                              color: _Cores.grayLine,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _buscaController,
                                onChanged: (v) =>
                                    setState(() => _buscaQuestoes = v),
                                style: const TextStyle(
                                  color: _Cores.subtitleColor,
                                  fontSize: 13.5,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Buscar no banco de questões',
                                  hintStyle: TextStyle(
                                    color: _Cores.grayLine,
                                    fontSize: 13,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: _abrirFiltroDificuldade,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _filtroDificuldade != 'Todas'
                              ? _Cores.teal
                              : _Cores.cardWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _Cores.grayLine.withValues(alpha: 0.5),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.tune_rounded,
                          color: _filtroDificuldade != 'Todas'
                              ? Colors.white
                              : _Cores.subtitleColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Lista de questões com checkboxes e tags
                if (filtradas.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: Text(
                      'Nenhuma questão cadastrada para $_disciplinaSelecionada com os filtros atuais.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _Cores.grayLine,
                        fontSize: 13.5,
                      ),
                    ),
                  )
                else
                  for (final item in filtradas) ...[
                    _buildCardQuestao(item),
                    const SizedBox(height: 10),
                  ],
              ],
            ),
          ),

          // Rodapé fixo com total selecionado e botão "Criar prova"
          _buildRodapeConclusao(totalSelecionadas),
        ],
      ),
    );
  }

  Widget _buildCardQuestao(_QuestaoItemBanco item) {
    final selecionada = _questoesSelecionadasIds.contains(item.questao.id);

    return InkWell(
      onTap: () => _alternarQuestao(item.questao.id),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selecionada
              ? _Cores.teal.withValues(alpha: 0.05)
              : _Cores.cardWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selecionada
                ? _Cores.teal
                : _Cores.grayLine.withValues(alpha: 0.4),
            width: selecionada ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Checkbox estilizado
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: selecionada ? _Cores.teal : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: selecionada ? _Cores.teal : _Cores.grayLine,
                  width: 1.8,
                ),
              ),
              alignment: Alignment.center,
              child: selecionada
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 12),

            // Enunciado e tags de apoio
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.questao.enunciado,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _Cores.subtitleColor,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _buildTag(
                        item.disciplina,
                        const Color(0xFFDCEAF6),
                        const Color(0xFF2F6690),
                      ),
                      if (item.dificuldade != null)
                        _buildTag(
                          item.dificuldade!,
                          item.dificuldade == 'Fácil'
                              ? const Color(0xFFE1F0E3)
                              : const Color(0xFFFBE6D2),
                          item.dificuldade == 'Fácil'
                              ? const Color(0xFF3E7C4A)
                              : const Color(0xFFB9752E),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Seta para ver enunciado completo e alternativas
            IconButton(
              icon: const Icon(
                Icons.chevron_right_rounded,
                color: _Cores.grayLine,
                size: 22,
              ),
              onPressed: () => _abrirDetalhesQuestao(item),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String texto, Color fundo, Color cor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        texto,
        style: TextStyle(color: cor, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildRodapeConclusao(int totalSelecionadas) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: _Cores.cardWhite,
        border: Border(
          top: BorderSide(color: _Cores.grayLine.withValues(alpha: 0.4)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$totalSelecionadas questões selecionadas',
              style: const TextStyle(
                color: _Cores.subtitleColor,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _concluirCriacao(postar: false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _Cores.teal,
                      side: const BorderSide(color: _Cores.teal),
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Salvar',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _concluirCriacao(postar: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _Cores.teal,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 48),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Postar',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _abrirDetalhesQuestao(_QuestaoItemBanco item) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _Cores.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: _Cores.grayLine.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.questao.enunciado,
              style: const TextStyle(
                color: _Cores.teal,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Alternativas:',
              style: TextStyle(
                color: _Cores.subtitleColor,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < item.questao.alternativas.length; i++) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Text(
                      '${String.fromCharCode(65 + i)}) ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: i == item.questao.indiceAlternativaCorreta
                            ? const Color(0xFF3E7C4A)
                            : _Cores.subtitleColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.questao.alternativas[i].texto,
                        style: TextStyle(
                          color: i == item.questao.indiceAlternativaCorreta
                              ? const Color(0xFF3E7C4A)
                              : _Cores.subtitleColor,
                          fontWeight: i == item.questao.indiceAlternativaCorreta
                              ? FontWeight.w700
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (i == item.questao.indiceAlternativaCorreta)
                      const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF3E7C4A),
                        size: 16,
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _Cores.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _abrirFiltroDificuldade() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _Cores.cardWhite,
        title: const Text('Filtrar por dificuldade'),
        content: RadioGroup<String>(
          groupValue: _filtroDificuldade,
          onChanged: (novo) {
            if (novo != null) {
              setState(() => _filtroDificuldade = novo);
              Navigator.of(context).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Todas', 'Fácil', 'Média', 'Difícil'].map((d) {
              return RadioListTile<String>(
                title: Text(d),
                value: d,
                activeColor: _Cores.teal,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  static List<_QuestaoItemBanco> _carregarQuestoes() {
    return [
      _QuestaoItemBanco(
        disciplina: 'Matemática',
        dificuldade: 'Fácil',
        questao: Questao(
          id: 'q-mat-1',
          enunciado: 'Qual é o resultado de 3² + 4²?',
          indiceAlternativaCorreta: 2,
          alternativas: [
            Alternativa(texto: '9', ordem: 0),
            Alternativa(texto: '12', ordem: 1),
            Alternativa(texto: '25', ordem: 2),
            Alternativa(texto: '49', ordem: 3),
          ],
        ),
      ),
      _QuestaoItemBanco(
        disciplina: 'Matemática',
        dificuldade: 'Média',
        questao: Questao(
          id: 'q-mat-2',
          enunciado: 'Um triângulo com lados 3, 4 e 5 é...',
          indiceAlternativaCorreta: 0,
          alternativas: [
            Alternativa(texto: 'Retângulo', ordem: 0),
            Alternativa(texto: 'Equilátero', ordem: 1),
            Alternativa(texto: 'Isósceles', ordem: 2),
            Alternativa(texto: 'Obtusângulo', ordem: 3),
          ],
        ),
      ),
      _QuestaoItemBanco(
        disciplina: 'Matemática',
        dificuldade: 'Fácil',
        questao: Questao(
          id: 'q-mat-3',
          enunciado: 'Resolva a equação 2x + 6 = 18',
          indiceAlternativaCorreta: 1,
          alternativas: [
            Alternativa(texto: 'x = 4', ordem: 0),
            Alternativa(texto: 'x = 6', ordem: 1),
            Alternativa(texto: 'x = 8', ordem: 2),
            Alternativa(texto: 'x = 12', ordem: 3),
          ],
        ),
      ),
      _QuestaoItemBanco(
        disciplina: 'Matemática',
        dificuldade: 'Difícil',
        questao: Questao(
          id: 'q-mat-4',
          enunciado: 'Qual o valor da diagonal de um cubo de aresta 2?',
          indiceAlternativaCorreta: 2,
          alternativas: [
            Alternativa(texto: '2√2', ordem: 0),
            Alternativa(texto: '4', ordem: 1),
            Alternativa(texto: '2√3', ordem: 2),
            Alternativa(texto: '3√2', ordem: 3),
          ],
        ),
      ),
      _QuestaoItemBanco(
        disciplina: 'Ciências',
        dificuldade: 'Média',
        questao: Questao(
          id: 'q-cie-1',
          enunciado: 'Qual processo as plantas usam para produzir alimento?',
          indiceAlternativaCorreta: 1,
          alternativas: [
            Alternativa(texto: 'Respiração', ordem: 0),
            Alternativa(texto: 'Fotossíntese', ordem: 1),
            Alternativa(texto: 'Fermentação', ordem: 2),
            Alternativa(texto: 'Osmose', ordem: 3),
          ],
        ),
      ),
      _QuestaoItemBanco(
        disciplina: 'História',
        dificuldade: 'Fácil',
        questao: Questao(
          id: 'q-his-1',
          enunciado: 'Em que ano ocorreu a Independência do Brasil?',
          indiceAlternativaCorreta: 3,
          alternativas: [
            Alternativa(texto: '1808', ordem: 0),
            Alternativa(texto: '1815', ordem: 1),
            Alternativa(texto: '1889', ordem: 2),
            Alternativa(texto: '1822', ordem: 3),
          ],
        ),
      ),
    ];
  }
}
