import 'package:flutter/foundation.dart';

import '../models/comentario.dart';
import '../models/evento.dart';
import '../models/usuario.dart';

import 'data_service.dart';

/// Estado compartilhado da aplicação (singleton + ChangeNotifier,
/// sem pacotes externos). Guarda o usuário logado, as presenças
/// confirmadas e os comentários da sessão.
/// Tudo fica em memória — nada é persistido.
class AppState extends ChangeNotifier {
  // Singleton: uma única instância para o app inteiro.
  AppState._();
  static final AppState instance = AppState._();

  final DataService _dataService = DataService();

  final List<Usuario> _usuarios = [];
  final List<Comentario> _comentarios = [];
  int _proximoIdComentario = 1;

  // ---- Usuário logado ----

  Usuario? _usuarioLogado;
  Usuario? get usuarioLogado => _usuarioLogado;
  bool get isLogado => _usuarioLogado != null;

  // Ids dos eventos com presença confirmada pelo usuário logado.
  final Set<int> _presencas = {};

  /// Carrega usuários e comentários dos assets.
  /// Chamado uma única vez em main(), antes do runApp.
  Future<void> carregarDados() async {
    _usuarios.addAll(await _dataService.carregarUsuarios());
    final comentarios = await _dataService.carregarComentarios();
    _comentarios.addAll(comentarios);
    for (final comentario in comentarios) {
      if (comentario.id >= _proximoIdComentario) {
        _proximoIdComentario = comentario.id + 1;
      }
    }
  }

  /// Login mockado: procura e-mail e senha nos usuários carregados.
  /// Retorna true quando as credenciais são válidas.
  bool entrar(String email, String senha) {
    for (final usuario in _usuarios) {
      if (usuario.email == email && usuario.senha == senha) {
        _usuarioLogado = usuario;
        _presencas.clear();
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void sair() {
    _usuarioLogado = null;
    _presencas.clear();
    notifyListeners();
  }

  // ---- Presença ----

  bool presencaConfirmada(int eventoId) => _presencas.contains(eventoId);

  /// Confirma ou cancela a presença no evento (exige usuário logado).
  void alternarPresenca(int eventoId) {
    if (!isLogado) return;
    if (presencaConfirmada(eventoId)) {
      _presencas.remove(eventoId);
    } else {
      _presencas.add(eventoId);
    }
    notifyListeners();
  }

  /// Vagas do evento já descontando a presença do usuário logado.
  int vagasDisponiveis(Evento evento) {
    return presencaConfirmada(evento.id) ? evento.vagas - 1 : evento.vagas;
  }

  // ---- Comentários ----

  List<Comentario> comentariosDoEvento(int eventoId) {
    return _comentarios
        .where((comentario) => comentario.eventoId == eventoId)
        .toList();
  }

  /// Adiciona um comentário com o nome do usuário logado e a data de hoje.
  void adicionarComentario(int eventoId, String texto) {
    if (!isLogado) return;
    _comentarios.add(
      Comentario(
        id: _proximoIdComentario++,
        eventoId: eventoId,
        usuario: _usuarioLogado!.nome,
        texto: texto,
        data: _dataHoje(),
      ),
    );
    notifyListeners();
  }

  String _dataHoje() {
    final DateTime hoje = DateTime.now();
    String doisDigitos(int numero) => numero.toString().padLeft(2, '0');
    return '${doisDigitos(hoje.day)}/${doisDigitos(hoje.month)}/${hoje.year}';
  }
}
