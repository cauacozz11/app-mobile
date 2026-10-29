// Tarefa 14 – Validação de formulários antes de gravar.
// Coloque em lib/utils/validators.dart e use nos TextFormField (validator:).
// Adapte os campos às telas do grupo.

class Validators {
  /// Campo obrigatório.
  static String? obrigatorio(String? valor, {String campo = 'Este campo'}) {
    if (valor == null || valor.trim().isEmpty) {
      return '$campo é obrigatório';
    }
    return null;
  }

  /// Tamanho mínimo (já exige preenchimento).
  static String? minimo(String? valor, int min, {String campo = 'Este campo'}) {
    final erro = obrigatorio(valor, campo: campo);
    if (erro != null) return erro;
    if (valor!.trim().length < min) {
      return '$campo deve ter pelo menos $min caracteres';
    }
    return null;
  }

  static String? email(String? valor) {
    final erro = obrigatorio(valor, campo: 'E-mail');
    if (erro != null) return erro;
    final regex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
    return regex.hasMatch(valor!.trim()) ? null : 'E-mail inválido';
  }

  /// Telefone brasileiro com 10 ou 11 dígitos (aceita máscara).
  static String? telefone(String? valor) {
    final erro = obrigatorio(valor, campo: 'Telefone');
    if (erro != null) return erro;
    final digitos = valor!.replaceAll(RegExp(r'\D'), '');
    return (digitos.length == 10 || digitos.length == 11)
        ? null
        : 'Telefone inválido';
  }

  /// Número decimal positivo (aceita vírgula ou ponto).
  static String? numeroPositivo(String? valor, {String campo = 'Valor'}) {
    final erro = obrigatorio(valor, campo: campo);
    if (erro != null) return erro;
    final n = double.tryParse(valor!.trim().replaceAll(',', '.'));
    if (n == null) return '$campo deve ser um número';
    if (n <= 0) return '$campo deve ser maior que zero';
    return null;
  }

  /// Data no formato dd/MM/aaaa.
  static String? data(String? valor) {
    final erro = obrigatorio(valor, campo: 'Data');
    if (erro != null) return erro;
    final m = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(valor!.trim());
    if (m == null) return 'Use o formato dd/mm/aaaa';
    final d = int.parse(m.group(1)!);
    final mes = int.parse(m.group(2)!);
    final a = int.parse(m.group(3)!);
    final dt = DateTime(a, mes, d);
    if (dt.day != d || dt.month != mes || dt.year != a) return 'Data inexistente';
    return null;
  }

  /// Senha: obrigatória, mínimo de 6 caracteres.
  static String? senha(String? valor, {int min = 6}) {
    final texto = valor ?? '';
    if (texto.isEmpty) return 'Informe a senha';
    if (texto.length < min) return 'A senha tem no mínimo $min caracteres';
    return null;
  }

  /// Confirmação de senha (use no cadastro): compara com a senha digitada.
  static String? confirmarSenha(String? valor, String senhaOriginal) {
    if ((valor ?? '').isEmpty) return 'Confirme a senha';
    if (valor != senhaOriginal) return 'As senhas não coincidem';
    return null;
  }

  /// Nome de pessoa: obrigatório, mínimo de 3 caracteres.
  static String? nome(String? valor) => minimo(valor, 3, campo: 'Nome');
}