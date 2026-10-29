class Resultado {
  final String id;
  final String provaId;
  final List<int> respostasMarcadas;
  final double nota;

  Resultado({
    required this.id,
    required this.provaId,
    required this.respostasMarcadas,
    required this.nota,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'provaId': provaId,
    'respostasMarcadas': respostasMarcadas,
    'nota': nota,
  };

  factory Resultado.fromMap(Map<String, dynamic> map) => Resultado(
    id: map['id'] as String,
    provaId: map['provaId'] as String,
    respostasMarcadas: List<int>.from(map['respostasMarcadas'] as List),
    nota: (map['nota'] as num).toDouble(),
  );
}