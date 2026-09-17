import 'package:flutter/material.dart';

import 'package:app_mobile/models/alternativa.dart';
import 'package:app_mobile/models/prova.dart';
import 'package:app_mobile/models/questao.dart';
import 'package:app_mobile/models/resultado.dart';
import 'package:app_mobile/screens/perfil/perfil_screen.dart';
import 'package:app_mobile/screens/questoes/banco_questoes.dart';
import 'package:app_mobile/screens/resultados/resultado_prova_screen.dart';

import 'criar_prova_modal.dart';

class _Cores {
  static const Color background = Color(0xFFF8F5F0);
  static const Color teal = Color(0xFF22555A);
  static const Color sage = Color(0xFF94AB9B);
  static const Color orange = Color(0xFFEC9E80);
  static const Color grayLine = Color(0xFFC3C6BF);
  static const Color cardWhite = Color(0xFFFBF9F5);
  static const Color subtitleColor = Color(0xFF3A484D);
}

enum StatusProva {
  todas,
  rascunho,
  pronta,
  corrigida;

  String get rotulo {
    switch (this) {
      case StatusProva.todas:
        return 'Todas';
      case StatusProva.rascunho:
        return 'Rascunhos';
      case StatusProva.pronta:
        return 'Prontas';
      case StatusProva.corrigida:
        return 'Corrigidas';
    }
  }

  String get tagTexto {
    switch (this) {
      case StatusProva.todas:
        return 'Todas';
      case StatusProva.rascunho:
        return 'Rascunho';
      case StatusProva.pronta:
        return 'Pronto';
      case StatusProva.corrigida:
        return 'Corrigida';
    }
  }
}

class _InfoDisciplina {
  final IconData icone;
  final Color fundo;
  final Color cor;
  final String? simboloCustomizado;

  const _InfoDisciplina({
    required this.icone,
    required this.fundo,
    required this.cor,
    this.simboloCustomizado,
  });
}

const Map<String, _InfoDisciplina> _estiloDisciplinas = {
  'Matemática': _InfoDisciplina(
    icone: Icons.calculate_outlined,
    fundo: Color(0xFFDCEAF6),
    cor: Color(0xFF2F6690),
    simboloCustomizado: '+ -\n× =',
  ),
  'Ciências': _InfoDisciplina(
    icone: Icons.eco_rounded,
    fundo: Color(0xFFE1F0E3),
    cor: Color(0xFF3E7C4A),
  ),
  'História': _InfoDisciplina(
    icone: Icons.account_balance_rounded,
    fundo: Color(0xFFF7E0E0),
    cor: Color(0xFFB25757),
  ),
  'Geografia': _InfoDisciplina(
    icone: Icons.public_rounded,
    fundo: Color(0xFFEFE6F7),
    cor: Color(0xFF7A5AA6),
  ),
  'Português': _InfoDisciplina(
    icone: Icons.menu_book_rounded,
    fundo: Color(0xFFFBE6D2),
    cor: Color(0xFFB9752E),
  ),
};

class ProvaItemVisual {
  final Prova prova;
  final StatusProva status;
  final String dataFormatada;
  final int totalQuestoes;

  const ProvaItemVisual({
    required this.prova,
    required this.status,
    required this.dataFormatada,
    required this.totalQuestoes,
  });
}

class ListagemProvasScreen extends StatefulWidget {
  const ListagemProvasScreen({super.key});

  @override
  State<ListagemProvasScreen> createState() => _ListagemProvasScreenState();
}

class _ListagemProvasScreenState extends State<ListagemProvasScreen> {
  final TextEditingController _buscaController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _busca = '';
  StatusProva _filtroStatus = StatusProva.todas;

  late List<ProvaItemVisual> _provas;

  @override
  void initState() {
    super.initState();
    _provas = _gerarProvasIniciais();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<ProvaItemVisual> get _provasFiltradas {
    return _provas.where((item) {
      final termo = _busca.trim().toLowerCase();
      final combinaBusca =
          termo.isEmpty ||
          item.prova.titulo.toLowerCase().contains(termo) ||
          item.prova.disciplina.toLowerCase().contains(termo);

      final combinaStatus = switch (_filtroStatus) {
        StatusProva.todas => true,
        StatusProva.rascunho => item.status == StatusProva.rascunho,
        StatusProva.corrigida => item.status == StatusProva.corrigida,
        StatusProva.pronta => item.status == StatusProva.pronta,
      };

      return combinaBusca && combinaStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtradas = _provasFiltradas;

    return Scaffold(
      backgroundColor: _Cores.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopo(),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
                children: [
                  const Text(
                    'Minhas provas',
                    style: TextStyle(
                      color: _Cores.teal,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 14),

                  _buildBarraBusca(),
                  const SizedBox(height: 14),

                  _buildFiltrosSituacao(),
                  const SizedBox(height: 16),

                  if (filtradas.isEmpty)
                    _buildEstadoVazio()
                  else
                    for (final item in filtradas) ...[
                      _buildCartaoProva(item),
                      const SizedBox(height: 14),
                    ],
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCriarProva,
        backgroundColor: _Cores.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.add),
        label: const Text(
          'Nova prova',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
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
            child: const Icon(
              Icons.fact_check_rounded,
              color: _Cores.orange,
              size: 18,
            ),
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

  Widget _buildBarraBusca() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _Cores.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _Cores.grayLine.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: _Cores.grayLine, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _buscaController,
              onChanged: (valor) => setState(() => _busca = valor),
              style: const TextStyle(
                color: _Cores.subtitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: 'Buscar provas',
                hintStyle: TextStyle(color: _Cores.grayLine, fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_busca.isNotEmpty)
            GestureDetector(
              onTap: () {
                _buscaController.clear();
                setState(() => _busca = '');
              },
              child: const Icon(
                Icons.close_rounded,
                color: _Cores.grayLine,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFiltrosSituacao() {
    const opcoes = [
      StatusProva.todas,
      StatusProva.rascunho,
      StatusProva.corrigida,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final opcao in opcoes) ...[
            _buildPillFiltro(
              rotulo: opcao.rotulo,
              selecionado: _filtroStatus == opcao,
              onTap: () => setState(() => _filtroStatus = opcao),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildPillFiltro({
    required String rotulo,
    required bool selecionado,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selecionado ? _Cores.teal : _Cores.cardWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selecionado
                ? _Cores.teal
                : _Cores.grayLine.withValues(alpha: 0.45),
          ),
          boxShadow: selecionado
              ? [
                  BoxShadow(
                    color: _Cores.teal.withValues(alpha: 0.22),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          rotulo,
          style: TextStyle(
            color: selecionado ? Colors.white : _Cores.subtitleColor,
            fontSize: 13,
            fontWeight: selecionado ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCartaoProva(ProvaItemVisual item) {
    final disciplinaInfo =
        _estiloDisciplinas[item.prova.disciplina] ??
        const _InfoDisciplina(
          icone: Icons.school_outlined,
          fundo: Color(0xFFE9E6DD),
          cor: _Cores.subtitleColor,
        );

    final ehCorrigida = item.status == StatusProva.corrigida;

    return InkWell(
      onTap: () {
        if (item.status == StatusProva.rascunho) {
          _editarRascunho(item);
        } else {
          _abrirDetalhesProva(item);
        }
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _Cores.cardWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _Cores.grayLine.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: disciplinaInfo.fundo,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: disciplinaInfo.simboloCustomizado != null
                      ? Text(
                          disciplinaInfo.simboloCustomizado!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: disciplinaInfo.cor,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        )
                      : Icon(
                          disciplinaInfo.icone,
                          color: disciplinaInfo.cor,
                          size: 24,
                        ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.prova.titulo,
                        style: const TextStyle(
                          color: _Cores.subtitleColor,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.prova.disciplina,
                        style: TextStyle(
                          color: _Cores.subtitleColor.withValues(alpha: 0.65),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                _buildEtiquetaStatus(item.status),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: _Cores.grayLine,
                ),
                const SizedBox(width: 5),
                Text(
                  'Criada em ${item.dataFormatada}',
                  style: const TextStyle(
                    color: _Cores.subtitleColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 14),
                const Icon(
                  Icons.description_outlined,
                  size: 15,
                  color: _Cores.grayLine,
                ),
                const SizedBox(width: 4),
                Text(
                  '${item.totalQuestoes} questões',
                  style: const TextStyle(
                    color: _Cores.subtitleColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: _Cores.grayLine,
                  size: 20,
                ),
              ],
            ),

            if (ehCorrigida) ...[
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFEBE8E0)),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _abrirResultado(item),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: _Cores.teal.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _Cores.teal.withValues(alpha: 0.22),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart_rounded,
                        color: _Cores.teal,
                        size: 18,
                      ),
                      SizedBox(width: 7),
                      Text(
                        'Ver resultado',
                        style: TextStyle(
                          color: _Cores.teal,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEtiquetaStatus(StatusProva status) {
    Color corFundo;
    Color corTexto;
    IconData icone;

    switch (status) {
      case StatusProva.corrigida:
        corFundo = const Color(0xFFE1F0E3);
        corTexto = const Color(0xFF3E7C4A);
        icone = Icons.check_circle_rounded;
        break;
      case StatusProva.rascunho:
        corFundo = const Color(0xFFFEF3C7);
        corTexto = const Color(0xFFB9752E);
        icone = Icons.edit_note_rounded;
        break;
      case StatusProva.pronta:
        corFundo = const Color(0xFFDCEAF6);
        corTexto = const Color(0xFF2F6690);
        icone = Icons.check_circle_outline_rounded;
        break;
      case StatusProva.todas:
        corFundo = const Color(0xFFE9E6DD);
        corTexto = _Cores.subtitleColor;
        icone = Icons.label_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 13, color: corTexto),
          const SizedBox(width: 4),
          Text(
            status.tagTexto,
            style: TextStyle(
              color: corTexto,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoVazio() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _Cores.grayLine.withValues(alpha: 0.2),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.search_off_rounded,
              size: 32,
              color: _Cores.grayLine,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nenhuma prova encontrada',
            style: TextStyle(
              color: _Cores.subtitleColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _busca.isNotEmpty
                ? 'Nenhum resultado para "$_busca".'
                : 'Não há provas com a situação selecionada.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _Cores.subtitleColor.withValues(alpha: 0.6),
              fontSize: 13.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuInferior() {
    return Container(
      decoration: BoxDecoration(
        color: _Cores.cardWhite,
        border: Border(
          top: BorderSide(color: _Cores.grayLine.withValues(alpha: 0.4)),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildItemMenu(Icons.description_outlined, 'Provas', true, () {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
              setState(() {
                _filtroStatus = StatusProva.todas;
                _busca = '';
                _buscaController.clear();
              });
            }),
            _buildItemMenu(Icons.menu_book_rounded, 'Questões', false, () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BancoQuestoesScreen(),
                ),
              );
            }),
            _buildItemMenu(Icons.person_outline, 'Perfil', false, _abrirPerfil),
          ],
        ),
      ),
    );
  }

  Widget _buildItemMenu(
    IconData icone,
    String rotulo,
    bool ativo,
    VoidCallback onTap,
  ) {
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
            Text(
              rotulo,
              style: TextStyle(
                color: cor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editarRascunho(ProvaItemVisual item) async {
    final conclusao = await CriarProvaModal.exibir(
      context,
      provaInicial: item.prova,
    );
    if (!mounted || conclusao == null) return;
    final prova = conclusao.prova;

    final indice = _provas.indexWhere((p) => p.prova.id == item.prova.id);
    if (indice == -1) return;
    setState(() {
      _provas[indice] = ProvaItemVisual(
        prova: prova,
        status: conclusao.postada ? StatusProva.pronta : StatusProva.rascunho,
        dataFormatada: item.dataFormatada,
        totalQuestoes: prova.questoes.length,
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          conclusao.postada
              ? 'Prova postada com sucesso!'
              : 'Rascunho atualizado com sucesso!',
        ),
      ),
    );
  }

  Future<void> _abrirCriarProva() async {
    final conclusao = await CriarProvaModal.exibir(context);
    if (!mounted || conclusao == null) return;
    final novaProva = conclusao.prova;

    final dia = novaProva.dataCriacao.day.toString().padLeft(2, '0');
    const meses = [
      'jan',
      'fev',
      'mar',
      'abr',
      'mai',
      'jun',
      'jul',
      'ago',
      'set',
      'out',
      'nov',
      'dez',
    ];
    final mes = meses[novaProva.dataCriacao.month - 1];

    final novoItem = ProvaItemVisual(
      prova: novaProva,
      status: conclusao.postada ? StatusProva.pronta : StatusProva.rascunho,
      dataFormatada: '$dia $mes',
      totalQuestoes: novaProva.questoes.length,
    );

    setState(() {
      _provas.insert(0, novoItem);
      _filtroStatus = StatusProva.todas;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _Cores.teal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text(
            conclusao.postada
                ? 'Prova postada com sucesso!'
                : 'Rascunho salvo com sucesso!',
          ),
        ),
      );
    }
  }

  void _abrirResultado(ProvaItemVisual item) {
    final qtd = item.prova.questoes.length;
    final resultado = Resultado(
      id: 'res-${item.prova.id}',
      provaId: item.prova.id,
      respostasMarcadas: List.generate(qtd, (i) {
        if (i % 6 == 0 && i != 0) {
          return (item.prova.questoes[i].indiceAlternativaCorreta + 1) % 4;
        }
        return item.prova.questoes[i].indiceAlternativaCorreta;
      }),
      nota: 8.5,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ResultadoProvaScreen(prova: item.prova, resultado: resultado),
      ),
    );
  }

  void _abrirDetalhesProva(ProvaItemVisual item) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _Cores.cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _Cores.grayLine.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.prova.titulo,
                    style: const TextStyle(
                      color: _Cores.teal,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _buildEtiquetaStatus(item.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Disciplina: ${item.prova.disciplina}',
              style: const TextStyle(
                color: _Cores.subtitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Criada em ${item.dataFormatada} · ${item.totalQuestoes} questões selecionadas',
              style: TextStyle(
                color: _Cores.subtitleColor.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 22),
            if (item.status == StatusProva.corrigida) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _Cores.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.bar_chart_rounded),
                  label: const Text(
                    'Visualizar Resultados',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _abrirResultado(item);
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: _Cores.subtitleColor,
                  side: BorderSide(
                    color: _Cores.grayLine.withValues(alpha: 0.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
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

  void _abrirPerfil() {
    final corrigidas = _provas
        .where((item) => item.status == StatusProva.corrigida)
        .length;
    final questoes = _provas.fold<int>(
      0,
      (total, item) => total + item.totalQuestoes,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PerfilScreen(
          totalProvas: _provas.length,
          totalCorrigidas: corrigidas,
          totalQuestoes: questoes,
        ),
      ),
    );
  }

  static List<ProvaItemVisual> _gerarProvasIniciais() {
    Questao questaoBase(String id, String enunciado) {
      return Questao(
        id: id,
        enunciado: enunciado,
        alternativas: [
          Alternativa(texto: 'Opção A', ordem: 0),
          Alternativa(texto: 'Opção B', ordem: 1),
          Alternativa(texto: 'Opção C', ordem: 2),
          Alternativa(texto: 'Opção D', ordem: 3),
        ],
        indiceAlternativaCorreta: 0,
      );
    }

    return [
      ProvaItemVisual(
        prova: Prova(
          id: 'prova-1',
          titulo: 'Matemática — 8º ano',
          disciplina: 'Matemática',
          dataCriacao: DateTime(2026, 9, 8),
          questoes: List.generate(
            20,
            (i) => questaoBase('m-$i', 'Questão ${i + 1}'),
          ),
        ),
        status: StatusProva.corrigida,
        dataFormatada: '08 set',
        totalQuestoes: 20,
      ),

      ProvaItemVisual(
        prova: Prova(
          id: 'prova-2',
          titulo: 'Ciências — Ecossistemas',
          disciplina: 'Ciências',
          dataCriacao: DateTime(2026, 9, 5),
          questoes: List.generate(
            15,
            (i) => questaoBase('c-$i', 'Questão ${i + 1}'),
          ),
        ),
        status: StatusProva.rascunho,
        dataFormatada: '05 set',
        totalQuestoes: 15,
      ),

      ProvaItemVisual(
        prova: Prova(
          id: 'prova-3',
          titulo: 'História do Brasil',
          disciplina: 'História',
          dataCriacao: DateTime(2026, 8, 28),
          questoes: List.generate(
            12,
            (i) => questaoBase('h-$i', 'Questão ${i + 1}'),
          ),
        ),
        status: StatusProva.pronta,
        dataFormatada: '28 ago',
        totalQuestoes: 12,
      ),

      ProvaItemVisual(
        prova: Prova(
          id: 'prova-4',
          titulo: 'Geografia — Climas e Relevo',
          disciplina: 'Geografia',
          dataCriacao: DateTime(2026, 8, 20),
          questoes: List.generate(
            10,
            (i) => questaoBase('g-$i', 'Questão ${i + 1}'),
          ),
        ),
        status: StatusProva.corrigida,
        dataFormatada: '20 ago',
        totalQuestoes: 10,
      ),

      ProvaItemVisual(
        prova: Prova(
          id: 'prova-5',
          titulo: 'Português — Concordância',
          disciplina: 'Português',
          dataCriacao: DateTime(2026, 8, 14),
          questoes: List.generate(
            18,
            (i) => questaoBase('p-$i', 'Questão ${i + 1}'),
          ),
        ),
        status: StatusProva.rascunho,
        dataFormatada: '14 ago',
        totalQuestoes: 18,
      ),
    ];
  }
}
