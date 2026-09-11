import 'package:flutter/material.dart';

import 'package:app_mobile/models/questao.dart';
import 'package:app_mobile/theme/app_colors.dart';

class ResponderQuestaoScreen extends StatefulWidget {
  const ResponderQuestaoScreen({
    super.key,
    required this.questao,
    required this.numero,
  });

  final Questao questao;
  final int numero;

  @override
  State<ResponderQuestaoScreen> createState() =>
      _ResponderQuestaoScreenState();
}

class _ResponderQuestaoScreenState extends State<ResponderQuestaoScreen> {
  int? _respostaSelecionada;
  bool _confirmado = false;

  bool get _acertou =>
      _respostaSelecionada == widget.questao.indiceAlternativaCorreta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Questão ${widget.numero}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: gradienteNavy),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              Text(
                widget.questao.enunciado,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              for (final alternativa in widget.questao.alternativas)
                _AlternativaOpcao(
                  letra: String.fromCharCode(65 + alternativa.ordem),
                  texto: alternativa.texto,
                  selecionada: _respostaSelecionada == alternativa.ordem,
                  correta: alternativa.ordem ==
                      widget.questao.indiceAlternativaCorreta,
                  confirmado: _confirmado,
                  onTap: _confirmado
                      ? null
                      : () => setState(
                          () => _respostaSelecionada = alternativa.ordem),
                ),
              const SizedBox(height: 12),
              if (_confirmado)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _acertou ? Colors.green : Colors.redAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _acertou
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _acertou
                              ? 'Você acertou!'
                              : 'Você errou. A resposta certa é a alternativa '
                                  '${String.fromCharCode(65 + widget.questao.indiceAlternativaCorreta)}.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corAccentCiano,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _confirmado
                      ? () => Navigator.of(context).pop()
                      : (_respostaSelecionada == null
                          ? null
                          : () => setState(() => _confirmado = true)),
                  child: Text(_confirmado ? 'Voltar' : 'Confirmar resposta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlternativaOpcao extends StatelessWidget {
  const _AlternativaOpcao({
    required this.letra,
    required this.texto,
    required this.selecionada,
    required this.correta,
    required this.confirmado,
    required this.onTap,
  });

  final String letra;
  final String texto;
  final bool selecionada;
  final bool correta;
  final bool confirmado;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color corBorda = Colors.transparent;
    Color corCirculo = corAccentCiano;

    if (confirmado) {
      if (correta) {
        corBorda = Colors.green;
        corCirculo = Colors.green;
      } else if (selecionada) {
        corBorda = Colors.redAccent;
        corCirculo = Colors.redAccent;
      }
    } else if (selecionada) {
      corBorda = corAccentCiano;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: corBorda, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: corCirculo,
                foregroundColor: Colors.white,
                child: Text(letra, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  texto,
                  style: const TextStyle(color: corNavyEscuro, fontSize: 16),
                ),
              ),
              if (confirmado && correta)
                const Icon(Icons.check_circle_rounded, color: Colors.green),
              if (confirmado && selecionada && !correta)
                const Icon(Icons.cancel_rounded, color: Colors.redAccent),
            ],
          ),
        ),
      ),
    );
  }
}
