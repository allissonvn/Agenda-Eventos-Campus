import 'package:flutter/material.dart';

import '../models/comentario.dart';
import '../models/evento.dart';
import '../services/app_state.dart';
import 'login_screen.dart';

/// Tela de detalhes de um evento: informações completas e comentários.
/// Usuário logado pode confirmar presença e publicar comentário;
/// visitante vê o conteúdo e um aviso para entrar.
class DetalhesEventoScreen extends StatefulWidget {
  const DetalhesEventoScreen({super.key, required this.evento});

  final Evento evento;

  @override
  State<DetalhesEventoScreen> createState() => _DetalhesEventoScreenState();
}

class _DetalhesEventoScreenState extends State<DetalhesEventoScreen> {
  final AppState _appState = AppState.instance;
  final TextEditingController _comentarioController = TextEditingController();

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  void _abrirLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (contexto) => const LoginScreen()),
    );
  }

  void _publicarComentario() {
    final String texto = _comentarioController.text.trim();
    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreva algo para comentar.')),
      );
      return;
    }
    _appState.adicionarComentario(widget.evento.id, texto);
    _comentarioController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Evento evento = widget.evento;
    final ThemeData tema = Theme.of(context);

    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        final bool logado = _appState.isLogado;
        final bool presenca = _appState.presencaConfirmada(evento.id);
        final int vagas = _appState.vagasDisponiveis(evento);
        final List<Comentario> comentarios = _appState
            .comentariosDoEvento(evento.id);

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
                subtitle: Text('$vagas lugares disponíveis'),
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

              // Presença: botão para quem está logado, aviso para visitante.
              if (logado)
                presenca
                    ? OutlinedButton.icon(
                        onPressed: () =>
                            _appState.alternarPresenca(evento.id),
                        icon: const Icon(Icons.event_busy),
                        label: const Text('Cancelar presença'),
                      )
                    : ElevatedButton.icon(
                        onPressed: () =>
                            _appState.alternarPresenca(evento.id),
                        icon: const Icon(Icons.event_available),
                        label: const Text('Confirmar presença'),
                      )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: tema.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_outline),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Entre para confirmar presença e comentar.',
                          ),
                        ),
                        TextButton(
                          onPressed: _abrirLogin,
                          child: const Text('Entrar'),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Comentários',
                style: tema.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (comentarios.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Nenhum comentário ainda.'),
                ),
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

              // Campo para publicar um novo comentário (apenas logado).
              if (logado) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _comentarioController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Escreva um comentário',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _publicarComentario,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
