import 'package:flutter/material.dart';

import 'package:app_mobile/models/sessao.dart';
import 'package:app_mobile/models/usuario.dart';

class _Cores {
  static const Color background = Color(0xFFF8F5F0);
  static const Color teal = Color(0xFF22555A);
  static const Color sage = Color(0xFF94AB9B);
  static const Color orange = Color(0xFFEC9E80);
  static const Color grayLine = Color(0xFFC3C6BF);
  static const Color cardWhite = Color(0xFFFBF9F5);
  static const Color subtitleColor = Color(0xFF3A484D);
}

const _visitante = Usuario(
  id: '—',
  nome: 'Visitante',
  email: 'não autenticado',
  senha: '',
);

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({
    super.key,
    this.totalProvas,
    this.totalCorrigidas,
    this.totalQuestoes,
  });

  final int? totalProvas;
  final int? totalCorrigidas;
  final int? totalQuestoes;

  String _iniciais(String nome) {
    final partes = nome.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes.first[0] + partes.last[0]).toUpperCase();
  }

  Future<void> _sair(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _Cores.cardWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Sair da conta?',
          style: TextStyle(
            color: _Cores.teal,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: const Text(
          'Você voltará para a tela de login.',
          style: TextStyle(color: _Cores.subtitleColor, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: _Cores.subtitleColor),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair', style: TextStyle(color: _Cores.orange)),
          ),
        ],
      ),
    );

    if (confirmou != true || !context.mounted) return;

    Sessao.sair();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (rota) => false);
  }

  void _emBreve(BuildContext context, String nome) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$nome ainda não faz parte da N1.'),
        backgroundColor: _Cores.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Sessao.usuarioAtual ?? _visitante;

    return Scaffold(
      backgroundColor: _Cores.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                children: [
                  _buildCartaoIdentificacao(usuario),
                  const SizedBox(height: 16),
                  _buildEstatisticas(),
                  const SizedBox(height: 16),
                  _buildInformacoes(usuario),
                  const SizedBox(height: 16),
                  _buildAcoes(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: _Cores.subtitleColor,
            ),
            tooltip: 'Voltar',
          ),
          const Text(
            'Perfil',
            style: TextStyle(
              color: _Cores.teal,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartao({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _Cores.cardWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _Cores.grayLine.withValues(alpha: 0.4)),
      ),
      child: child,
    );
  }

  Widget _buildCartaoIdentificacao(Usuario usuario) {
    return _buildCartao(
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
              color: _Cores.teal,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _iniciais(usuario.nome),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            usuario.nome,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _Cores.teal,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            usuario.email,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _Cores.subtitleColor.withValues(alpha: 0.8),
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _Cores.sage.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Professor',
              style: TextStyle(
                color: _Cores.teal,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstatisticas() {
    return Row(
      children: [
        Expanded(
          child: _buildTileNumero(
            Icons.description_outlined,
            totalProvas,
            'Provas',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTileNumero(
            Icons.menu_book_rounded,
            totalQuestoes,
            'Questões',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTileNumero(
            Icons.check_circle_outline,
            totalCorrigidas,
            'Corrigidas',
          ),
        ),
      ],
    );
  }

  Widget _buildTileNumero(IconData icone, int? valor, String rotulo) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: _Cores.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _Cores.grayLine.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Icon(icone, color: _Cores.sage, size: 20),
          const SizedBox(height: 8),
          Text(
            valor?.toString() ?? '—',
            style: const TextStyle(
              color: _Cores.teal,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            rotulo,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _Cores.subtitleColor.withValues(alpha: 0.8),
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformacoes(Usuario usuario) {
    final disciplinas = usuario.disciplinas.isEmpty
        ? ['Nenhuma cadastrada']
        : usuario.disciplinas;

    return _buildCartao(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informações da conta',
            style: TextStyle(
              color: _Cores.teal,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          _buildLinhaInfo(Icons.badge_outlined, 'Matrícula', usuario.id),
          const SizedBox(height: 14),
          _buildLinhaInfo(
            Icons.school_outlined,
            'Instituição',
            usuario.instituicao.isEmpty ? '—' : usuario.instituicao,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.local_library_outlined,
                size: 18,
                color: _Cores.sage,
              ),
              const SizedBox(width: 10),
              Text(
                'Disciplinas',
                style: TextStyle(
                  color: _Cores.subtitleColor.withValues(alpha: 0.7),
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final disciplina in disciplinas)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _Cores.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _Cores.grayLine.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    disciplina,
                    style: const TextStyle(
                      color: _Cores.subtitleColor,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinhaInfo(IconData icone, String rotulo, String valor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icone, size: 18, color: _Cores.sage),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rotulo,
                style: TextStyle(
                  color: _Cores.subtitleColor.withValues(alpha: 0.7),
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                valor,
                style: const TextStyle(
                  color: _Cores.subtitleColor,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAcoes(BuildContext context) {
    return _buildCartao(
      child: Column(
        children: [
          _buildItemAcao(
            icone: Icons.edit_outlined,
            rotulo: 'Editar perfil',
            onTap: () => _emBreve(context, 'Edição de perfil'),
          ),
          const Divider(height: 24, color: Color(0xFFEBE8E0)),
          _buildItemAcao(
            icone: Icons.notifications_none_rounded,
            rotulo: 'Notificações',
            onTap: () => _emBreve(context, 'Notificações'),
          ),
          const Divider(height: 24, color: Color(0xFFEBE8E0)),
          _buildItemAcao(
            icone: Icons.logout_rounded,
            rotulo: 'Sair da conta',
            cor: _Cores.orange,
            onTap: () => _sair(context),
          ),
        ],
      ),
    );
  }

  Widget _buildItemAcao({
    required IconData icone,
    required String rotulo,
    required VoidCallback onTap,
    Color cor = _Cores.subtitleColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icone, size: 20, color: cor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                rotulo,
                style: TextStyle(
                  color: cor,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: _Cores.grayLine),
          ],
        ),
      ),
    );
  }
}
