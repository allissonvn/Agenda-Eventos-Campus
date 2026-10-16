import 'package:flutter/material.dart';

import 'screens/lista_eventos_screen.dart';
import 'services/app_state.dart';

Future<void> main() async {
  // Necessário para usar rootBundle antes do runApp().
  WidgetsFlutterBinding.ensureInitialized();
  // Usuários e comentários ficam em memória no AppState.
  await AppState.instance.carregarDados();
  runApp(const AgendaEventosApp());
}

class AgendaEventosApp extends StatelessWidget {
  const AgendaEventosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda de Eventos do Campus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const ListaEventosScreen(),
    );
  }
}
