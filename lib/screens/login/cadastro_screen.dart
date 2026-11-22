import 'package:flutter/material.dart';

import 'package:app_mobile/models/sessao.dart';
import 'package:app_mobile/utils/autenticacao.dart';
import 'package:app_mobile/utils/validators.dart';

class _Cores {
  static const Color background = Color(0xFFF8F5F0);
  static const Color teal = Color(0xFF22555A);
  static const Color orange = Color(0xFFEC9E80);
  static const Color grayLine = Color(0xFFC3C6BF);
  static const Color cardWhite = Color(0xFFFBF9F5);
  static const Color subtitleColor = Color(0xFF3A484D);
  static const Color verde = Color(0xFF16846C);
}

/// Criar conta de professor: grava o acesso no Firebase Authentication e o
/// perfil na coleção `usuarios` do Firestore.
class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _instituicaoCtrl = TextEditingController();
  final _disciplinasCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();

  bool _senhaOculta = true;
  bool _salvando = false;
  String? _erro;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _instituicaoCtrl.dispose();
    _disciplinasCtrl.dispose();
    _senhaCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  Future<void> _criarConta() async {
    setState(() => _erro = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);
    try {
      final usuario = await Autenticacao.cadastrar(
        nome: _nomeCtrl.text.trim(),
        email: _emailCtrl.text.trim().toLowerCase(),
        senha: _senhaCtrl.text,
        instituicao: _instituicaoCtrl.text.trim(),
        disciplinas: _disciplinasCtrl.text
            .split(',')
            .map((d) => d.trim())
            .where((d) => d.isNotEmpty)
            .toList(),
      );
      Sessao.entrar(usuario);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Conta criada! Bem-vindo, ${usuario.nome}!'),
          backgroundColor: _Cores.teal,
        ),
      );
      Navigator.of(context).pushNamedAndRemoveUntil('/provas', (_) => false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _salvando = false;
        _erro = Autenticacao.mensagem(e);
      });
    }
  }

  InputDecoration _decoracao(String label, IconData icone, {Widget? sufixo}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icone, size: 20, color: _Cores.teal),
      suffixIcon: sufixo,
      filled: true,
      fillColor: _Cores.cardWhite,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Cores.background,
      appBar: AppBar(
        title: const Text('Criar conta'),
        backgroundColor: _Cores.background,
        foregroundColor: _Cores.teal,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const Text(
                'Cadastro de professor',
                style: TextStyle(
                  color: _Cores.teal,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeCtrl,
                textCapitalization: TextCapitalization.words,
                validator: Validators.nome,
                decoration: _decoracao('Nome completo', Icons.person_outline),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
                decoration: _decoracao('E-mail', Icons.mail_outline),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _instituicaoCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: _decoracao(
                  'Instituição (opcional)',
                  Icons.school_outlined,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _disciplinasCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: _decoracao(
                  'Disciplinas, separadas por vírgula (opcional)',
                  Icons.menu_book_outlined,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _senhaCtrl,
                obscureText: _senhaOculta,
                validator: Validators.senha,
                decoration: _decoracao(
                  'Senha',
                  Icons.lock_outline,
                  sufixo: IconButton(
                    icon: Icon(
                      _senhaOculta
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _senhaOculta = !_senhaOculta),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmarCtrl,
                obscureText: _senhaOculta,
                validator: (v) => Validators.confirmarSenha(v, _senhaCtrl.text),
                decoration: _decoracao('Confirmar senha', Icons.lock_outline),
              ),
              if (_erro != null) ...[
                const SizedBox(height: 12),
                Text(
                  _erro!,
                  style: const TextStyle(color: _Cores.orange, fontSize: 13),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _salvando ? null : _criarConta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _Cores.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _salvando
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Criar conta',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
