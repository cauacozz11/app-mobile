import 'package:flutter/material.dart';

import 'package:app_mobile/models/alternativa.dart';
import 'package:app_mobile/models/questao.dart';
import 'package:app_mobile/theme/app_colors.dart';

class CriarQuestaoScreen extends StatefulWidget {
  const CriarQuestaoScreen({super.key});

  @override
  State<CriarQuestaoScreen> createState() => _CriarQuestaoScreenState();
}

class _CriarQuestaoScreenState extends State<CriarQuestaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _enunciadoController = TextEditingController();
  final _alternativasControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  int _indiceCorreta = 0;

  @override
  void dispose() {
    _enunciadoController.dispose();
    for (final controller in _alternativasControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final questao = Questao(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      enunciado: _enunciadoController.text.trim(),
      alternativas: [
        for (var i = 0; i < _alternativasControllers.length; i++)
          Alternativa(texto: _alternativasControllers[i].text.trim(), ordem: i),
      ],
      indiceAlternativaCorreta: _indiceCorreta,
    );

    Navigator.of(context).pop(questao);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Nova Questão',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: gradienteNavy),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                const _CampoLabel('Enunciado'),
                _CampoCard(
                  child: TextFormField(
                    controller: _enunciadoController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Digite a pergunta da questão',
                    ),
                    validator: (value) => (value == null || value.trim().isEmpty)
                        ? 'Informe o enunciado'
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                const _CampoLabel('Alternativas (marque a correta)'),
                RadioGroup<int>(
                  groupValue: _indiceCorreta,
                  onChanged: (value) =>
                      setState(() => _indiceCorreta = value!),
                  child: Column(
                    children: [
                      for (var i = 0; i < _alternativasControllers.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CampoCard(
                            child: Row(
                              children: [
                                Radio<int>(
                                  value: i,
                                  activeColor: Colors.green,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _alternativasControllers[i],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText:
                                          'Alternativa ${String.fromCharCode(65 + i)}',
                                    ),
                                    validator: (value) =>
                                        (value == null || value.trim().isEmpty)
                                            ? 'Informe a alternativa'
                                            : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corAccentCiano,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _salvar,
                    icon: const Icon(Icons.check),
                    label: const Text('Salvar questão'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CampoLabel extends StatelessWidget {
  const _CampoLabel(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _CampoCard extends StatelessWidget {
  const _CampoCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: child,
    );
  }
}
