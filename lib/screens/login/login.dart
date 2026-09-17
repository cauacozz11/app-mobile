import 'package:flutter/material.dart';

import 'package:app_mobile/models/sessao.dart';
import 'package:app_mobile/models/usuario.dart';
import 'package:app_mobile/screens/splash.dart' show LogoCard, BlobPainter;

import 'mock_usuario.dart';

class _Cores {
  static const Color background = Color(0xFFF8F5F0);
  static const Color blobColor = Color(0xFFF2EEE4);
  static const Color teal = Color(0xFF22555A);
  static const Color sage = Color(0xFF94AB9B);
  static const Color orange = Color(0xFFEC9E80);
  static const Color grayLine = Color(0xFFC3C6BF);
  static const Color cardWhite = Color(0xFFFBF9F5);
  static const Color subtitleColor = Color(0xFF3A484D);
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();

  bool _senhaOculta = true;

  String? _erroLogin;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  String? _validaEmail(String? valor) {
    final texto = (valor ?? '').trim();
    if (texto.isEmpty) return 'Informe o e-mail';
    if (!texto.contains('@') || !texto.contains('.')) return 'E-mail inválido';
    return null;
  }

  String? _validaSenha(String? valor) {
    final texto = valor ?? '';
    if (texto.isEmpty) return 'Informe a senha';
    if (texto.length < 6) return 'A senha tem no mínimo 6 caracteres';
    return null;
  }

  void _entrar() {
    setState(() => _erroLogin = null);

    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtrl.text.trim().toLowerCase();
    final senha = _senhaCtrl.text;

    Usuario? usuario;
    for (final u in usuariosMock) {
      if (u.email.toLowerCase() == email && u.senha == senha) {
        usuario = u;
        break;
      }
    }

    if (usuario == null) {
      setState(() => _erroLogin = 'E-mail ou senha inválidos');
      return;
    }

    Sessao.entrar(usuario);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bem-vindo, ${usuario.nome}!'),
        backgroundColor: _Cores.teal,
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pushReplacementNamed('/provas');
  }

  void _esqueciSenha() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fale com a sua instituição para redefinir a senha.'),
        backgroundColor: _Cores.teal,
      ),
    );
  }

  InputDecoration _decoracao({
    required String label,
    required String hint,
    required IconData icone,
    Widget? suffixIcon,
  }) {
    OutlineInputBorder borda(Color cor, double espessura) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: cor, width: espessura),
    );

    const estiloLabel = TextStyle(
      color: Color(0xB33A484D),
      fontSize: 13,
    );

    return InputDecoration(
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: estiloLabel,
      floatingLabelStyle: estiloLabel,
      hintStyle: TextStyle(
        color: _Cores.subtitleColor.withValues(alpha: 0.35),
        fontSize: 15,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 14, right: 10),
        child: Icon(icone, size: 20, color: _Cores.teal),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: _Cores.background,
      contentPadding: const EdgeInsets.fromLTRB(0, 14, 14, 14),
      enabledBorder: borda(_Cores.grayLine.withValues(alpha: 0.5), 1),
      focusedBorder: borda(_Cores.teal, 1.4),
      errorBorder: borda(_Cores.orange, 1),
      focusedErrorBorder: borda(_Cores.orange, 1.4),
      errorStyle: const TextStyle(color: _Cores.orange, fontSize: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _Cores.background,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: CustomPaint(
              size: Size(size.width * 0.42, size.height * 0.30),
              painter: const BlobPainter(color: _Cores.blobColor),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Transform.rotate(
              angle: 3.14159,
              child: CustomPaint(
                size: Size(size.width * 0.50, size.height * 0.26),
                painter: const BlobPainter(color: _Cores.blobColor),
              ),
            ),
          ),

          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                const SizedBox(height: 12),

                const Center(child: LogoCard(escala: 0.55)),

                const SizedBox(height: 4),

                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Prova',
                        style: TextStyle(
                          color: _Cores.teal,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                      TextSpan(
                        text: 'Leve',
                        style: TextStyle(
                          color: _Cores.sage,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Container(
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
                  decoration: BoxDecoration(
                    color: _Cores.cardWhite,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Bem-vindo de volta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _Cores.teal,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Entre para cuidar das suas provas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _Cores.subtitleColor.withValues(alpha: 0.75),
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 24),

                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          validator: _validaEmail,
                          style: const TextStyle(
                            color: _Cores.subtitleColor,
                            fontSize: 15,
                          ),
                          decoration: _decoracao(
                            label: 'E-mail',
                            hint: 'professor@escola.com',
                            icone: Icons.mail_outline,
                          ),
                        ),

                        const SizedBox(height: 14),

                        TextFormField(
                          controller: _senhaCtrl,
                          obscureText: _senhaOculta,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _entrar(),
                          validator: _validaSenha,
                          style: const TextStyle(
                            color: _Cores.subtitleColor,
                            fontSize: 15,
                          ),
                          decoration: _decoracao(
                            label: 'Senha',
                            hint: '••••••••',
                            icone: Icons.lock_outline,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _senhaOculta
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                                color: _Cores.teal,
                              ),
                              tooltip: _senhaOculta
                                  ? 'Mostrar senha'
                                  : 'Ocultar senha',
                              onPressed: () =>
                                  setState(() => _senhaOculta = !_senhaOculta),
                            ),
                          ),
                        ),

                        if (_erroLogin != null) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: _Cores.orange,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _erroLogin!,
                                  style: const TextStyle(
                                    color: _Cores.orange,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _esqueciSenha,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 32),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: _Cores.orange,
                            ),
                            child: const Text(
                              'Esqueci minha senha',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _entrar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _Cores.teal,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shadowColor: _Cores.teal.withValues(alpha: 0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Ainda não possui acesso? Fale com sua instituição.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _Cores.subtitleColor.withValues(alpha: 0.6),
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
