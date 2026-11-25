import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:app_mobile/models/prova.dart';
import 'package:app_mobile/utils/correcao.dart';
import 'package:app_mobile/utils/prova_pdf.dart';
import 'package:app_mobile/utils/validators.dart';

class _Cores {
  static const Color background = Color(0xFFF8F5F0);
  static const Color teal = Color(0xFF22555A);
  static const Color grayLine = Color(0xFFC3C6BF);
  static const Color cardWhite = Color(0xFFFBF9F5);
  static const Color subtitleColor = Color(0xFF3A484D);
}

/// Gabarito do aluno: o aluno informa o nome e marca a alternativa de cada
/// questão, e a tela gera o QRCode com essas respostas. O professor lê esse
/// QRCode na prova ("Corrigir lendo o QRCode do gabarito") e a correção é automática.
class GabaritoAlunoScreen extends StatefulWidget {
  const GabaritoAlunoScreen({super.key, required this.prova});

  final Prova prova;

  @override
  State<GabaritoAlunoScreen> createState() => _GabaritoAlunoScreenState();
}

class _GabaritoAlunoScreenState extends State<GabaritoAlunoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  late final List<int> _respostas;
  String? _qrData;

  @override
  void initState() {
    super.initState();
    _respostas = List.filled(widget.prova.questoes.length, semResposta);
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    super.dispose();
  }

  void _gerar() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _qrData = conteudoQrGabarito(
        widget.prova,
        aluno: _nomeCtrl.text,
        respostas: _respostas,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final questoes = widget.prova.questoes;
    return Scaffold(
      backgroundColor: _Cores.background,
      appBar: AppBar(
        title: const Text('Gabarito do aluno'),
        backgroundColor: _Cores.background,
        foregroundColor: _Cores.teal,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            Text(
              '${widget.prova.titulo} · ${widget.prova.disciplina}',
              style: const TextStyle(
                color: _Cores.subtitleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _nomeCtrl,
              textCapitalization: TextCapitalization.words,
              validator: Validators.nome,
              onChanged: (_) => setState(() => _qrData = null),
              decoration: InputDecoration(
                labelText: 'Nome do aluno',
                filled: true,
                fillColor: _Cores.cardWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < questoes.length; i++)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _Cores.cardWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _Cores.grayLine.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${i + 1}. ${questoes[i].enunciado}',
                      style: const TextStyle(
                        color: _Cores.teal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (var j = 0; j < questoes[i].alternativas.length; j++)
                          ChoiceChip(
                            label: Text(String.fromCharCode(65 + j)),
                            selected: _respostas[i] == j,
                            onSelected: (marcada) => setState(() {
                              _respostas[i] = marcada ? j : semResposta;
                              _qrData = null;
                            }),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 6),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _gerar,
                icon: const Icon(Icons.qr_code_2),
                label: const Text(
                  'Gerar QRCode do gabarito',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _Cores.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            if (_qrData != null) ...[
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.white,
                  child: QrImageView(data: _qrData!, size: 240),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'O professor lê este QRCode na prova, em "Corrigir lendo o QRCode do gabarito".',
                textAlign: TextAlign.center,
                style: TextStyle(color: _Cores.subtitleColor, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
