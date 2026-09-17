import 'package:app_mobile/models/usuario.dart';

class Sessao {
  Sessao._();

  static Usuario? _usuario;

  static Usuario? get usuarioAtual => _usuario;

  static void entrar(Usuario usuario) => _usuario = usuario;

  static void sair() => _usuario = null;
}
