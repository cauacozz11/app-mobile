class Turma {
  final String id;
  final String nome;
  final String disciplina;

  const Turma({required this.id, required this.nome, required this.disciplina});

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'disciplina': disciplina,
  };

  factory Turma.fromMap(Map<String, dynamic> map) => Turma(
    id: map['id'] as String,
    nome: map['nome'] as String,
    disciplina: map['disciplina'] as String,
  );
}
