import 'package:flutter/material.dart';

import 'package:app_mobile/data/turmas_repository.dart';
import 'package:app_mobile/models/sessao.dart';
import 'package:app_mobile/models/turma.dart';
import 'package:app_mobile/utils/mensagem_erro.dart';
import 'package:app_mobile/utils/validators.dart';
import 'package:app_mobile/widgets/estado_tela.dart';

class _Cores {
  static const Color background = Color(0xFFF8F5F0);
  static const Color teal = Color(0xFF22555A);
  static const Color orange = Color(0xFFEC9E80);
  static const Color grayLine = Color(0xFFC3C6BF);
  static const Color cardWhite = Color(0xFFFBF9F5);
  static const Color subtitleColor = Color(0xFF3A484D);
  static const Color verde = Color(0xFF16846C);
}

const List<String> _disciplinasPadrao = [
  'Matemática',
  'Ciências',
  'História',
  'Geografia',
  'Português',
];

/// Turmas e disciplinas do professor, gravadas na coleção `turmas` do Firestore.
class TurmasScreen extends StatefulWidget {
  const TurmasScreen({super.key});

  @override
  State<TurmasScreen> createState() => _TurmasScreenState();
}

class _TurmasScreenState extends State<TurmasScreen> {
  List<Turma> _turmas = [];
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
      final turmas = await TurmasRepository.instance.listar();
      turmas.sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
      if (!mounted) return;
      setState(() {
        _turmas = turmas;
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

  void _avisar(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _novaTurma() async {
    final turma = await showDialog<Turma>(
      context: context,
      builder: (context) => const _NovaTurmaDialog(),
    );
    if (!mounted || turma == null) return;
    try {
      await TurmasRepository.instance.criar(turma);
      if (!mounted) return;
      setState(() => _turmas = [..._turmas, turma]);
      _avisar('Turma criada com sucesso!');
    } catch (e) {
      if (!mounted) return;
      _avisar('Não foi possível criar a turma. ${mensagemErro(e)}');
    }
  }

  Future<void> _excluir(Turma turma) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir turma'),
        content: Text('Deseja excluir a turma "${turma.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await TurmasRepository.instance.excluir(turma.id);
      if (!mounted) return;
      setState(() => _turmas = _turmas.where((t) => t.id != turma.id).toList());
      _avisar('Turma excluída.');
    } catch (e) {
      if (!mounted) return;
      _avisar('Não foi possível excluir a turma. ${mensagemErro(e)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Cores.background,
      appBar: AppBar(
        title: const Text('Turmas e disciplinas'),
        backgroundColor: _Cores.background,
        foregroundColor: _Cores.teal,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _novaTurma,
        backgroundColor: _Cores.orange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Nova turma',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: RefreshIndicator(
        color: _Cores.teal,
        onRefresh: _carregar,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: _conteudo(),
        ),
      ),
    );
  }

  List<Widget> _conteudo() {
    if (_carregando) {
      return const [EstadoTela.carregando(titulo: 'Carregando turmas...')];
    }
    final erro = _erro;
    if (erro != null) {
      return [EstadoTela.erro(mensagem: erro, onTentarNovamente: _carregar)];
    }
    if (_turmas.isEmpty) {
      return const [
        EstadoTela.vazio(
          titulo: 'Nenhuma turma criada',
          mensagem: 'Toque em "Nova turma" para cadastrar a primeira.',
          icone: Icons.groups_outlined,
        ),
      ];
    }
    return [
      for (final turma in _turmas)
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: _Cores.cardWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _Cores.grayLine.withValues(alpha: 0.4)),
          ),
          child: ListTile(
            leading: const Icon(Icons.groups_outlined, color: _Cores.teal),
            title: Text(
              turma.nome,
              style: const TextStyle(
                color: _Cores.teal,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(turma.disciplina),
            trailing: IconButton(
              tooltip: 'Excluir turma',
              icon: const Icon(Icons.delete_outline, color: _Cores.subtitleColor),
              onPressed: () => _excluir(turma),
            ),
          ),
        ),
    ];
  }
}

class _NovaTurmaDialog extends StatefulWidget {
  const _NovaTurmaDialog();

  @override
  State<_NovaTurmaDialog> createState() => _NovaTurmaDialogState();
}

class _NovaTurmaDialogState extends State<_NovaTurmaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  late final List<String> _disciplinas;
  late String _disciplina;

  @override
  void initState() {
    super.initState();
    final doProfessor = Sessao.usuarioAtual?.disciplinas ?? const <String>[];
    _disciplinas = doProfessor.isNotEmpty ? doProfessor : _disciplinasPadrao;
    _disciplina = _disciplinas.first;
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      Turma(
        id: 'turma-${DateTime.now().millisecondsSinceEpoch}',
        nome: _nomeCtrl.text.trim(),
        disciplina: _disciplina,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nova turma'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nomeCtrl,
              textCapitalization: TextCapitalization.sentences,
              validator: (v) => Validators.minimo(v, 2, campo: 'Nome da turma'),
              decoration: const InputDecoration(
                labelText: 'Nome da turma',
                hintText: 'Ex.: 8º ano A',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _disciplina,
              items: [
                for (final d in _disciplinas)
                  DropdownMenuItem(value: d, child: Text(d)),
              ],
              onChanged: (v) => setState(() => _disciplina = v ?? _disciplina),
              decoration: const InputDecoration(labelText: 'Disciplina'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(onPressed: _salvar, child: const Text('Criar')),
      ],
    );
  }
}
