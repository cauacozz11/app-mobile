import 'package:flutter/material.dart';

class _Cores {
  static const Color teal = Color(0xFF22555A);
  static const Color grayLine = Color(0xFFC3C6BF);
  static const Color subtitleColor = Color(0xFF3A484D);
}

class EstadoTela extends StatelessWidget {
  const EstadoTela.carregando({super.key, this.titulo = 'Carregando...'})
    : mensagem = null,
      icone = null,
      onTentarNovamente = null;

  const EstadoTela.vazio({
    super.key,
    required this.titulo,
    this.mensagem,
    IconData this.icone = Icons.inbox_outlined,
  }) : onTentarNovamente = null;

  const EstadoTela.erro({
    super.key,
    required String this.mensagem,
    required VoidCallback this.onTentarNovamente,
  }) : titulo = 'Não foi possível carregar',
       icone = Icons.wifi_off_rounded;

  final String titulo;
  final String? mensagem;
  final IconData? icone;
  final VoidCallback? onTentarNovamente;

  @override
  Widget build(BuildContext context) {
    final icone = this.icone;
    final mensagem = this.mensagem;
    final onTentarNovamente = this.onTentarNovamente;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _Cores.grayLine.withValues(alpha: 0.2),
            ),
            child: icone == null
                ? const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: _Cores.teal,
                    ),
                  )
                : Icon(icone, size: 32, color: _Cores.grayLine),
          ),
          const SizedBox(height: 16),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _Cores.subtitleColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (mensagem != null) ...[
            const SizedBox(height: 6),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _Cores.subtitleColor.withValues(alpha: 0.6),
                fontSize: 13.5,
              ),
            ),
          ],
          if (onTentarNovamente != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onTentarNovamente,
              style: OutlinedButton.styleFrom(
                foregroundColor: _Cores.teal,
                side: const BorderSide(color: _Cores.teal),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Tentar novamente'),
            ),
          ],
        ],
      ),
    );
  }
}
