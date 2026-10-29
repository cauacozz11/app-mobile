class Alternativa {
  final String texto;
  final int ordem;

  Alternativa({required this.texto, required this.ordem});

  Map<String, dynamic> toMap() => {
    'texto': texto,
    'ordem': ordem,
  };

  factory Alternativa.fromMap(Map<String, dynamic> map) => Alternativa(
    texto: map['texto'] as String,
    ordem: map['ordem'] as int,
  );
}