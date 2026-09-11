import 'package:flutter/material.dart';

import 'package:app_mobile/models/alternativa.dart';
import 'package:app_mobile/models/questao.dart';
import 'package:app_mobile/screens/questoes/criar_questao.dart';
import 'package:app_mobile/screens/questoes/responder_questao.dart';
import 'package:app_mobile/theme/app_colors.dart';

List<Questao> _questoesMock() {
  return [
    Questao(
      id: '1',
      enunciado:
          'Qual tipo de dado é usado em Dart para representar valores verdadeiro/falso?',
      alternativas: [
        Alternativa(texto: 'int', ordem: 0),
        Alternativa(texto: 'String', ordem: 1),
        Alternativa(texto: 'bool', ordem: 2),
        Alternativa(texto: 'double', ordem: 3),
      ],
      indiceAlternativaCorreta: 2,
    ),
    Questao(
      id: '2',
      enunciado:
          'Qual estrutura de dados segue o princípio LIFO (Last In, First Out)?',
      alternativas: [
        Alternativa(texto: 'Fila', ordem: 0),
        Alternativa(texto: 'Pilha', ordem: 1),
        Alternativa(texto: 'Árvore', ordem: 2),
        Alternativa(texto: 'Grafo', ordem: 3),
      ],
      indiceAlternativaCorreta: 1,
    ),
    Questao(
      id: '3',
      enunciado: 'Em Flutter, qual widget é usado para criar uma lista rolável?',
      alternativas: [
        Alternativa(texto: 'Column', ordem: 0),
        Alternativa(texto: 'ListView', ordem: 1),
        Alternativa(texto: 'Row', ordem: 2),
        Alternativa(texto: 'Stack', ordem: 3),
      ],
      indiceAlternativaCorreta: 1,
    ),
    Questao(
      id: '4',
      enunciado:
          'Em Dart, qual palavra-chave declara uma variável constante em tempo de compilação?',
      alternativas: [
        Alternativa(texto: 'var', ordem: 0),
        Alternativa(texto: 'final', ordem: 1),
        Alternativa(texto: 'const', ordem: 2),
        Alternativa(texto: 'static', ordem: 3),
      ],
      indiceAlternativaCorreta: 2,
    ),
  ];
}

class ListagemQuestoesScreen extends StatefulWidget {
  const ListagemQuestoesScreen({super.key});

  @override
  State<ListagemQuestoesScreen> createState() =>
      _ListagemQuestoesScreenState();
}

class _ListagemQuestoesScreenState extends State<ListagemQuestoesScreen> {
  final List<Questao> _questoes = _questoesMock();

  Future<void> _abrirCriarQuestao() async {
    final novaQuestao = await Navigator.of(context).push<Questao>(
      MaterialPageRoute(builder: (_) => const CriarQuestaoScreen()),
    );
    if (novaQuestao != null) {
      setState(() => _questoes.add(novaQuestao));
    }
  }

  void _abrirResponderQuestao(Questao questao, int numero) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            ResponderQuestaoScreen(questao: questao, numero: numero),
      ),
    );
  }

  Future<void> _excluirQuestao(Questao questao) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir questão'),
        content: const Text('Tem certeza que deseja excluir esta questão?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmou == true) {
      setState(() => _questoes.remove(questao));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.school_rounded, color: corAccentCiano, size: 22),
            SizedBox(width: 8),
            Text(
              'Banco de Questões',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: gradienteNavy),
        child: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: _questoes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final questao = _questoes[index];
              return _QuestaoCard(
                questao: questao,
                numero: index + 1,
                onTap: () => _abrirResponderQuestao(questao, index + 1),
                onDelete: () => _excluirQuestao(questao),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: corAccentCiano,
        foregroundColor: Colors.white,
        onPressed: _abrirCriarQuestao,
        icon: const Icon(Icons.add),
        label: const Text('Nova questão'),
      ),
    );
  }
}

class _QuestaoCard extends StatelessWidget {
  const _QuestaoCard({
    required this.questao,
    required this.numero,
    required this.onTap,
    required this.onDelete,
  });

  final Questao questao;
  final int numero;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final corretaLetra = String.fromCharCode(
      65 + questao.indiceAlternativaCorreta,
    );

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Questão $numero',
                    style: const TextStyle(
                      color: corAccentAzul,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onDelete,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                questao.enunciado,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: corNavyEscuro,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.list_alt_rounded,
                    size: 16,
                    color: Colors.black45,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${questao.alternativas.length} alternativas',
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Correta: $corretaLetra',
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
