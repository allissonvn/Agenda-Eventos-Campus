/// Modelo de um evento do campus.
class Evento {
  final int id;
  final String titulo;
  final String tipo; // "palestra" ou "oficina"
  final String data; // formato dd/MM/aaaa
  final String horario;
  final String local;
  final String palestrante;
  final String descricao;
  final int vagas;

  const Evento({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.data,
    required this.horario,
    required this.local,
    required this.palestrante,
    required this.descricao,
    required this.vagas,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      tipo: json['tipo'] as String,
      data: json['data'] as String,
      horario: json['horario'] as String,
      local: json['local'] as String,
      palestrante: json['palestrante'] as String,
      descricao: json['descricao'] as String,
      vagas: json['vagas'] as int,
    );
  }

  /// Conveniência para diferenciar o ícone na lista.
  bool get isPalestra => tipo.toLowerCase() == 'palestra';
}
