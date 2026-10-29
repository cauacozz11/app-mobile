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

  // A senha não vai pro Firestore de propósito (guardar senha em texto é inseguro).
  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'email': email,
    'instituicao': instituicao,
    'disciplinas': disciplinas,
  };

  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
    id: map['id'] as String,
    nome: map['nome'] as String,
    email: map['email'] as String,
    senha: '',
    instituicao: (map['instituicao'] as String?) ?? '',
    disciplinas: List<String>.from((map['disciplinas'] as List?) ?? const []),
  );
}