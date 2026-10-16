/// Modelo de um comentário feito em um evento.
class Comentario {
  final int id;
  final int eventoId;
  final String usuario;
  final String texto;
  final String data; // formato dd/MM/aaaa

  const Comentario({
    required this.id,
    required this.eventoId,
    required this.usuario,
    required this.texto,
    required this.data,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id: json['id'] as int,
      eventoId: json['eventoId'] as int,
      usuario: json['usuario'] as String,
      texto: json['texto'] as String,
      data: json['data'] as String,
    );
  }
}
