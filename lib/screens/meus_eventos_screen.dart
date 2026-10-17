import 'package:flutter/material.dart';

import '../models/evento.dart';
import '../services/app_state.dart';
import '../services/data_service.dart';
import 'detalhes_evento_screen.dart';

/// Tela "Meus eventos": lista os eventos em que o usuário logado
/// confirmou presença, com título, data e local.
/// Disponível apenas para usuários logados.
class MeusEventosScreen extends StatefulWidget {
  const MeusEventosScreen({super.key});

  @override
  State<MeusEventosScreen> createState() => _MeusEventosScreenState();
}

class _MeusEventosScreenState extends State<MeusEventosScreen> {
  final AppState _appState = AppState.instance;
  final DataService _service = DataService();
  late final Future<List<Evento>> _eventosFuture;

  @override
  void initState() {
    super.initState();
    _eventosFuture = _service.carregarEventos();
  }

  void _sair() {
    _appState.sair();
    // Volta para a lista de eventos: sem usuário logado,
    // esta tela não faz sentido.
    Navigator.pop(context);
  }

  List<Evento> _eventosConfirmados(List<Evento> eventos) {
    return eventos
        .where((evento) => _appState.presencaConfirmada(evento.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Meus eventos'),
            actions: [
              TextButton(
                onPressed: _sair,
                child: const Text('Sair'),
              ),
            ],
          ),
          body: FutureBuilder<List<Evento>>(
            future: _eventosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Erro ao carregar os eventos:\n${snapshot.error}',
                  ),
                );
              }
              final eventos = _eventosConfirmados(
                snapshot.data ?? <Evento>[],
              );
              if (eventos.isEmpty) {
                return const Center(
                  child: Text(
                    'Você ainda não confirmou presença em nenhum evento',
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: eventos.length,
                itemBuilder: (context, indice) {
                  final evento = eventos[indice];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.event_available),
                      title: Text(evento.titulo),
                      subtitle: Text('${evento.data} • ${evento.local}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (contexto) =>
                                DetalhesEventoScreen(evento: evento),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
