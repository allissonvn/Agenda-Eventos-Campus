import 'package:flutter/material.dart';

import '../models/evento.dart';
import '../services/data_service.dart';
import 'detalhes_evento_screen.dart';

/// Tela inicial: lista todos os eventos do campus,
/// com filtro por tipo (Todos, Palestra, Oficina).
class ListaEventosScreen extends StatefulWidget {
  const ListaEventosScreen({super.key});

  @override
  State<ListaEventosScreen> createState() => _ListaEventosScreenState();
}

class _ListaEventosScreenState extends State<ListaEventosScreen> {
  final DataService _service = DataService();
  late final Future<List<Evento>> _eventosFuture;

  static const List<String> _filtros = ['Todos', 'Palestra', 'Oficina'];
  String _filtroSelecionado = 'Todos';

  @override
  void initState() {
    super.initState();
    _eventosFuture = _service.carregarEventos();
  }

  List<Evento> _eventosFiltrados(List<Evento> eventos) {
    if (_filtroSelecionado == 'Todos') {
      return eventos;
    }
    return eventos
        .where(
          (evento) => evento.tipo.toLowerCase() == _filtroSelecionado.toLowerCase(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda de Eventos do Campus')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: [
                for (final filtro in _filtros)
                  ChoiceChip(
                    label: Text(filtro),
                    selected: _filtroSelecionado == filtro,
                    onSelected: (selecionado) {
                      if (selecionado) {
                        setState(() => _filtroSelecionado = filtro);
                      }
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Evento>>(
              future: _eventosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro ao carregar os eventos:\n${snapshot.error}'),
                  );
                }
                final eventos = _eventosFiltrados(snapshot.data ?? <Evento>[]);
                if (eventos.isEmpty) {
                  return const Center(child: Text('Nenhum evento encontrado.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  itemCount: eventos.length,
                  itemBuilder: (context, indice) {
                    final evento = eventos[indice];
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          evento.isPalestra ? Icons.campaign : Icons.handyman,
                        ),
                        title: Text(evento.titulo),
                        subtitle: Text(
                          '${evento.data} às ${evento.horario}\n${evento.local}',
                        ),
                        trailing: Text(
                          '${evento.vagas} vagas',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        isThreeLine: true,
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
          ),
        ],
      ),
    );
  }
}
