import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/comentario.dart';
import '../models/evento.dart';
import '../models/usuario.dart';

/// Serviço que carrega os dados estáticos da aplicação
/// (eventos, comentários e usuários) a partir dos JSON em assets/.
class DataService {
  Future<List<Evento>> carregarEventos() async {
    return _carregarLista('assets/eventos.json', Evento.fromJson);
  }

  Future<List<Comentario>> carregarComentarios() async {
    return _carregarLista('assets/comentarios.json', Comentario.fromJson);
  }

  Future<List<Usuario>> carregarUsuarios() async {
    return _carregarLista('assets/usuarios.json', Usuario.fromJson);
  }

  /// Carrega um arquivo JSON de assets/, decodifica e converte cada item
  /// usando a função [fromJson] do modelo correspondente.
  Future<List<T>> _carregarLista<T>(
    String caminho,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final String conteudo = await rootBundle.loadString(caminho);
    final List<dynamic> jsonLista = jsonDecode(conteudo) as List<dynamic>;
    return jsonLista
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
