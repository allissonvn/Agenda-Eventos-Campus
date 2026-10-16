import 'package:flutter/material.dart';

import '../models/comentario.dart';
import '../models/evento.dart';
import '../services/data_service.dart';

/// Tela de detalhes de um evento: informações completas
/// e a lista de comentários daquele evento.
/// Aberta a partir da lista com Navigator.push (ainda sem login).
class DetalhesEventoScreen extends StatefulWidget {
  const DetalhesEventoScreen({super.key, required this.evento});

  final Evento evento;

  @override
  State<DetalhesEventoScreen> createState() => _DetalhesEventoScreenState();
}

class _DetalhesEventoScreenState extends State<DetalhesEventoScreen> {
  final DataService _service = DataService();
  late final Future<List<Comentario>> _comentariosFuture;

  @override
  void initState() {
    super.initState();
    _comentariosFuture = _service.carregarComentariosDoEvento(
      widget.evento.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final evento = widget.evento;
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Evento')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            evento.titulo,
            style: tema.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Chip(
            avatar: Icon(
              evento.isPalestra ? Icons.campaign : Icons.handyman,
              size: 18,
            ),
            label: Text(evento.isPalestra ? 'Palestra' : 'Oficina'),
          ),
          const SizedBox(height: 8),
          ListTile(
            dense: true,
            leading: const Icon(Icons.calendar_today),
            title: const Text('Data e horário'),
            subtitle: Text('${evento.data} às ${evento.horario}'),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.location_on),
            title: const Text('Local'),
            subtitle: Text(evento.local),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.person_outline),
            title: const Text('Palestrante'),
            subtitle: Text(evento.palestrante),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.event_seat),
            title: const Text('Vagas'),
            subtitle: Text('${evento.vagas} lugares disponíveis'),
          ),
          const Divider(),
          Text(
            'Sobre',
            style: tema.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(evento.descricao),
          const Divider(),
          Text(
            'Comentários',
            style: tema.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          FutureBuilder<List<Comentario>>(
            future: _comentariosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Erro ao carregar os comentários.'),
                );
              }
              final comentarios = snapshot.data ?? <Comentario>[];
              if (comentarios.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Nenhum comentário ainda.'),
                );
              }
              return Column(
                children: [
                  for (final comentario in comentarios)
                    ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          comentario.usuario.isNotEmpty
                              ? comentario.usuario[0].toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(
                        comentario.usuario,
                        style: tema.textTheme.titleSmall,
                      ),
                      subtitle: Text(comentario.texto),
                      trailing: Text(
                        comentario.data,
                        style: tema.textTheme.bodySmall,
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
