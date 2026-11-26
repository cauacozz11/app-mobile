import 'package:flutter/material.dart';

import 'package:app_mobile/models/sessao.dart';

const List<String> disciplinasPadrao = [
  'Matemática',
  'Ciências',
  'História',
  'Geografia',
  'Português',
];

/// Valor da opção "Outra disciplina..." nas listas de escolha.
const String outraDisciplina = '__outra_disciplina__';

/// Disciplinas que o professor pode escolher: as do cadastro dele, as padrão,
/// as já usadas ([extras], como as de questões existentes) e a [atual].
List<String> disciplinasDisponiveis({
  String? atual,
  Iterable<String> extras = const [],
}) {
  final lista = <String>{
    ...(Sessao.usuarioAtual?.disciplinas ?? const <String>[]),
    ...disciplinasPadrao,
    ...extras,
    if (atual != null && atual.isNotEmpty) atual,
  };
  return lista.where((d) => d.trim().isNotEmpty).toList();
}

/// Item final das listas de disciplina, que permite digitar uma nova.
DropdownMenuItem<String> itemOutraDisciplina() => const DropdownMenuItem<String>(
  value: outraDisciplina,
  child: Text('Outra disciplina...'),
);

/// Pergunta o nome de uma nova disciplina. Devolve `null` se cancelar.
Future<String?> pedirNovaDisciplina(BuildContext context) {
  final controlador = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Nova disciplina'),
      content: TextField(
        controller: controlador,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(labelText: 'Nome da disciplina'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final nome = controlador.text.trim();
            Navigator.of(context).pop(nome.length >= 2 ? nome : null);
          },
          child: const Text('Adicionar'),
        ),
      ],
    ),
  );
}
