class Usuario {
  final String id;
  final String nome;
  final String email;
  final String senha;
  final String instituicao;
  final List<String> disciplinas;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.instituicao = '',
    this.disciplinas = const [],
  });
}
