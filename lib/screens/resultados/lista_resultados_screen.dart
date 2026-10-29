import 'package:flutter/material.dart';

import 'package:app_mobile/data/resultados_repository.dart';
import 'package:app_mobile/models/prova.dart';
import 'package:app_mobile/models/resultado.dart';
import 'package:app_mobile/screens/resultados/resultado_prova_screen.dart';
import 'package:app_mobile/utils/correcao.dart';
import 'package:app_mobile/utils/mensagem_erro.dart';
import 'package:app_mobile/widgets/estado_tela.dart';

class _Cores {
  static const Color background = Color(0xFFF8F5F0);
  static const Color teal = Color(0xFF22555A);
  static const Color grayLine = Color(0xFFC3C6BF);
  static const Color cardWhite = Color(0xFFFBF9F5);
  static const Color subtitleColor = Color(0xFF3A484D);
  static const Color verde = Color(0xFF16846C);
  static const Color vermelho = Color(0xFFBD3F3C);
}

/// Lista os alunos corrigidos de uma prova, lendo a coleção `resultados`
/// do Firestore. Tocar num aluno abre a correção detalhada dele.
class ListaResultadosScreen extends StatefulWidget {
  const ListaResultadosScreen({super.key, required this.prova});

  final Prova prova;

  @override
  State<ListaResultadosScreen> createState() => _ListaResultadosScreenState();
}

class _ListaResultadosScreenState extends State<ListaResultadosScreen> {
  List<Resultado> _resultados = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final resultados = await ResultadosRepository.instance.listarPorProva(
        widget.prova.id,
      );
      resultados.sort(
        (a, b) =>
            a.nomeAluno.toLowerCase().compareTo(b.nomeAluno.toLowerCase()),
      );
      if (!mounted) return;
      setState(() {
        _resultados = resultados;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = mensagemErro(e);
        _carregando = false;
      });
    }
  }

  double get _media {
    if (_resultados.isEmpty) return 0;
    final soma = _resultados.fold<double>(0, (total, r) => total + r.nota);
    return soma / _resultados.length;
  }

  String _formatarNota(double nota) =>
      nota.toStringAsFixed(1).replaceAll('.', ',');

  void _abrirResultado(Resultado resultado) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ResultadoProvaScreen(prova: widget.prova, resultado: resultado),
      ),
    );
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
              child: RefreshIndicator(
                color: _Cores.teal,
                onRefresh: _carregar,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  children: _buildConteudo(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildConteudo() {
    if (_carregando) {
      return const [EstadoTela.carregando(titulo: 'Carregando resultados...')];
    }
    final erro = _erro;
    if (erro != null) {
      return [EstadoTela.erro(mensagem: erro, onTentarNovamente: _carregar)];
    }
    if (_resultados.isEmpty) {
      return const [
        EstadoTela.vazio(
          titulo: 'Nenhum aluno corrigido',
          mensagem: 'Use "Corrigir prova" para lançar o gabarito de um aluno.',
          icone: Icons.fact_check_outlined,
        ),
      ];
    }
    return [
      _buildResumo(),
      const SizedBox(height: 16),
      for (final resultado in _resultados) ...[
        _buildAluno(resultado),
        const SizedBox(height: 10),
      ],
    ];
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resultados',
                  style: TextStyle(
                    color: _Cores.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${widget.prova.titulo} · ${widget.prova.disciplina}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _Cores.subtitleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumo() {
    final total = _resultados.length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _Cores.teal,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildNumeroResumo(
              total == 1 ? 'aluno corrigido' : 'alunos corrigidos',
              '$total',
            ),
          ),
          Expanded(
            child: _buildNumeroResumo('média da turma', _formatarNota(_media)),
          ),
        ],
      ),
    );
  }

  Widget _buildNumeroResumo(String rotulo, String valor) {
    return Column(
      children: [
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          rotulo,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAluno(Resultado resultado) {
    final correcao = corrigirProva(widget.prova, resultado.respostasMarcadas);
    final aprovado = resultado.nota >= 6;
    final nome = resultado.nomeAluno.isEmpty
        ? 'Aluno sem nome'
        : resultado.nomeAluno;

    return InkWell(
      onTap: () => _abrirResultado(resultado),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _Cores.cardWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _Cores.grayLine.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: _Cores.teal.withValues(alpha: 0.1),
              foregroundColor: _Cores.teal,
              child: Text(
                nome[0].toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    style: const TextStyle(
                      color: _Cores.subtitleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${correcao.acertos} de ${correcao.total} acertos',
                    style: TextStyle(
                      color: _Cores.subtitleColor.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _formatarNota(resultado.nota),
              style: TextStyle(
                color: aprovado ? _Cores.verde : _Cores.vermelho,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: _Cores.grayLine),
          ],
        ),
      ),
    );
  }
}
