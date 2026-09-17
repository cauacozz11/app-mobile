import 'package:flutter/material.dart';

import 'package:app_mobile/models/alternativa.dart';
import 'package:app_mobile/models/questao.dart';
import 'package:app_mobile/screens/perfil/perfil_screen.dart';

import 'nova_questao.dart';
import 'questao_cadastrada.dart';

class _Cores {
  static const Color background = Color(0xFFF8F5F0);
  static const Color teal = Color(0xFF22555A);
  static const Color sage = Color(0xFF94AB9B);
  static const Color orange = Color(0xFFEC9E80);
  static const Color grayLine = Color(0xFFC3C6BF);
  static const Color cardWhite = Color(0xFFFBF9F5);
  static const Color subtitleColor = Color(0xFF3A484D);
}

class _Etiqueta {
  final Color fundo;
  final Color texto;
  const _Etiqueta(this.fundo, this.texto);
}

const Map<String, _Etiqueta> _coresDisciplina = {
  'Matemática': _Etiqueta(Color(0xFFDCEAF6), Color(0xFF2F6690)),
  'Ciências': _Etiqueta(Color(0xFFE1F0E3), Color(0xFF3E7C4A)),
  'História': _Etiqueta(Color(0xFFF7E0E0), Color(0xFFB25757)),
  'Geografia': _Etiqueta(Color(0xFFEFE6F7), Color(0xFF7A5AA6)),
  'Português': _Etiqueta(Color(0xFFFBE6D2), Color(0xFFB9752E)),
};
const _Etiqueta _etiquetaPadrao = _Etiqueta(Color(0xFFE9E6DD), _Cores.subtitleColor);

const Map<String, _Etiqueta> _coresDificuldade = {
  'Fácil': _Etiqueta(Color(0xFFE1F0E3), Color(0xFF3E7C4A)),
  'Média': _Etiqueta(Color(0xFFFBE6D2), Color(0xFFB9752E)),
  'Difícil': _Etiqueta(Color(0xFFF7E0E0), Color(0xFFB25757)),
};

class BancoQuestoesScreen extends StatefulWidget {
  const BancoQuestoesScreen({super.key});

  @override
  State<BancoQuestoesScreen> createState() => _BancoQuestoesScreenState();
}

class _BancoQuestoesScreenState extends State<BancoQuestoesScreen> {
  final List<QuestaoCadastrada> _questoes = [
    QuestaoCadastrada(
      disciplina: 'Matemática',
      dificuldade: 'Fácil',
      questao: Questao(
        id: '1',
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
    QuestaoCadastrada(
      disciplina: 'Ciências',
      dificuldade: 'Média',
      questao: Questao(
        id: '2',
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
    QuestaoCadastrada(
      disciplina: 'História',
      dificuldade: 'Fácil',
      questao: Questao(
        id: '3',
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

  static const List<String> _opcoesDificuldade = ['Todas', 'Fácil', 'Média', 'Difícil'];

  String _busca = '';
  String _filtro = 'Todas';
  String _filtroDificuldade = 'Todas';
  final _buscaController = TextEditingController();

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  List<String> get _abas {
    final disciplinas = <String>{};
    for (final item in _questoes) {
      disciplinas.add(item.disciplina);
    }
    return ['Todas', ...disciplinas];
  }

  List<QuestaoCadastrada> get _filtradas {
    return _questoes.where((item) {
      final passaDisciplina = _filtro == 'Todas' || item.disciplina == _filtro;
      final passaDificuldade =
          _filtroDificuldade == 'Todas' || item.dificuldade == _filtroDificuldade;
      final passaBusca = _busca.trim().isEmpty ||
          item.questao.enunciado.toLowerCase().contains(_busca.trim().toLowerCase());
      return passaDisciplina && passaDificuldade && passaBusca;
    }).toList();
  }

  Future<void> _abrirFiltroDificuldade() async {
    final escolha = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _Cores.cardWhite,
        title: const Text('Filtrar por dificuldade'),
        content: RadioGroup<String>(
          groupValue: _filtroDificuldade,
          onChanged: (valor) => Navigator.of(context).pop(valor),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final opcao in _opcoesDificuldade)
                RadioListTile<String>(
                  value: opcao,
                  activeColor: _Cores.teal,
                  contentPadding: EdgeInsets.zero,
                  title: Text(opcao),
                ),
            ],
          ),
        ),
      ),
    );
    if (escolha != null) {
      setState(() => _filtroDificuldade = escolha);
    }
  }

  String _letra(int indice) => String.fromCharCode(65 + indice);

  Future<void> _abrirNovaQuestao() async {
    final resultado = await Navigator.of(context).push<QuestaoCadastrada>(
      MaterialPageRoute(builder: (_) => const NovaQuestaoScreen()),
    );
    if (resultado != null) {
      setState(() => _questoes.add(resultado));
    }
  }

  Future<void> _editarQuestao(QuestaoCadastrada item) async {
    final resultado = await Navigator.of(context).push<QuestaoCadastrada>(
      MaterialPageRoute(
        builder: (_) => NovaQuestaoScreen(itemParaEditar: item),
      ),
    );
    if (resultado != null) {
      setState(() {
        final indice = _questoes.indexWhere((q) => q.questao.id == item.questao.id);
        if (indice != -1) _questoes[indice] = resultado;
      });
    }
  }

  void _duplicarQuestao(QuestaoCadastrada item) {
    final novaQuestao = Questao(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      enunciado: item.questao.enunciado,
      alternativas: item.questao.alternativas,
      indiceAlternativaCorreta: item.questao.indiceAlternativaCorreta,
    );
    setState(() {
      _questoes.add(item.copyWith(questao: novaQuestao));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Questão duplicada.')),
    );
  }

  Future<void> _excluirQuestao(QuestaoCadastrada item) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _Cores.cardWhite,
        title: const Text('Excluir questão'),
        content: const Text('Esta ação não pode ser desfeita. Deseja excluir esta questão do banco?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      setState(() => _questoes.removeWhere((q) => q.questao.id == item.questao.id));
    }
  }

  void _abrirPerfil() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PerfilScreen(totalQuestoes: _questoes.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtradas = _filtradas;

    return Scaffold(
      backgroundColor: _Cores.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopo(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
                children: [
                  const Text(
                    'Banco de questões',
                    style: TextStyle(
                      color: _Cores.teal,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildBusca(),
                  const SizedBox(height: 14),
                  _buildAbas(),
                  const SizedBox(height: 12),
                  Text(
                    filtradas.length == 1
                        ? '1 questão cadastrada'
                        : '${filtradas.length} questões cadastradas',
                    style: const TextStyle(color: _Cores.subtitleColor, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  if (filtradas.isEmpty) _buildVazio(),
                  for (var i = 0; i < filtradas.length; i++) ...[
                    _buildCartao(i + 1, filtradas[i]),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirNovaQuestao,
        backgroundColor: _Cores.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.add),
        label: const Text('Nova questão', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      bottomNavigationBar: _buildMenuInferior(),
    );
  }

  Widget _buildTopo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _Cores.cardWhite,
              borderRadius: BorderRadius.circular(9),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.fact_check_rounded, color: _Cores.orange, size: 18),
          ),
          const SizedBox(width: 8),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Prova',
                  style: TextStyle(
                    color: _Cores.teal,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: 'Leve',
                  style: TextStyle(
                    color: _Cores.sage,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _abrirPerfil,
            child: const CircleAvatar(
              radius: 17,
              backgroundColor: _Cores.teal,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusca() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: _Cores.cardWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _Cores.grayLine.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: _Cores.grayLine, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _buscaController,
                    onChanged: (valor) => setState(() => _busca = valor),
                    decoration: const InputDecoration(
                      hintText: 'Buscar questões',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 14, color: _Cores.subtitleColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _abrirFiltroDificuldade,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _filtroDificuldade == 'Todas' ? _Cores.cardWhite : _Cores.teal,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _Cores.grayLine.withValues(alpha: 0.5)),
            ),
            child: Icon(
              Icons.tune,
              color: _filtroDificuldade == 'Todas' ? _Cores.teal : Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAbas() {
    final abas = _abas;
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: abas.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final aba = abas[index];
          final selecionada = aba == _filtro;
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => setState(() => _filtro = aba),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selecionada ? _Cores.teal : _Cores.cardWhite,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selecionada ? _Cores.teal : _Cores.grayLine.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                aba,
                style: TextStyle(
                  color: selecionada ? Colors.white : _Cores.subtitleColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVazio() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          const Icon(Icons.search_off, color: _Cores.grayLine, size: 36),
          const SizedBox(height: 8),
          const Text(
            'Nenhuma questão encontrada.',
            style: TextStyle(color: _Cores.subtitleColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCartao(int numero, QuestaoCadastrada item) {
    final questao = item.questao;
    final etDisciplina = _coresDisciplina[item.disciplina] ?? _etiquetaPadrao;
    final etDificuldade = _coresDificuldade[item.dificuldade] ?? _etiquetaPadrao;
    final correta = (questao.indiceAlternativaCorreta >= 0 &&
            questao.indiceAlternativaCorreta < questao.alternativas.length)
        ? _letra(questao.indiceAlternativaCorreta)
        : '—';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _Cores.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _Cores.grayLine.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: _Cores.teal.withValues(alpha: 0.10),
                child: Text(
                  '$numero',
                  style: const TextStyle(
                    color: _Cores.teal,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questao.enunciado,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _Cores.subtitleColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildEtiqueta(item.disciplina, etDisciplina),
                        _buildEtiqueta(item.dificuldade, etDificuldade),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: _Cores.subtitleColor, size: 20),
                color: _Cores.cardWhite,
                onSelected: (opcao) {
                  switch (opcao) {
                    case 'editar':
                      _editarQuestao(item);
                      break;
                    case 'duplicar':
                      _duplicarQuestao(item);
                      break;
                    case 'excluir':
                      _excluirQuestao(item);
                      break;
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'editar', child: Text('Editar')),
                  PopupMenuItem(value: 'duplicar', child: Text('Duplicar')),
                  PopupMenuItem(value: 'excluir', child: Text('Excluir')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFE4E1D8)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.list_alt, color: _Cores.grayLine, size: 16),
              const SizedBox(width: 6),
              Text(
                '${questao.alternativas.length} alternativas',
                style: const TextStyle(color: _Cores.subtitleColor, fontSize: 12.5),
              ),
              const Spacer(),
              const Icon(Icons.check_circle, color: _Cores.sage, size: 16),
              const SizedBox(width: 4),
              Text(
                'Correta: $correta',
                style: const TextStyle(
                  color: _Cores.sage,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEtiqueta(String texto, _Etiqueta cor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: cor.fundo,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto,
        style: TextStyle(color: cor.texto, fontSize: 11.5, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildMenuInferior() {
    return Container(
      decoration: BoxDecoration(
        color: _Cores.cardWhite,
        border: Border(top: BorderSide(color: _Cores.grayLine.withValues(alpha: 0.4))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildItemMenu(
              Icons.description_outlined,
              'Provas',
              false,
              () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pushReplacementNamed('/provas');
                }
              },
            ),
            _buildItemMenu(Icons.menu_book_rounded, 'Questões', true, () {}),
            _buildItemMenu(Icons.person_outline, 'Perfil', false,
                _abrirPerfil),
          ],
        ),
      ),
    );
  }

  Widget _buildItemMenu(IconData icone, String rotulo, bool ativo, VoidCallback onTap) {
    final cor = ativo ? _Cores.teal : _Cores.grayLine;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, color: cor, size: 22),
            const SizedBox(height: 2),
            Text(rotulo, style: TextStyle(color: cor, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
