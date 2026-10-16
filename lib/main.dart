import 'package:flutter/material.dart';

import 'screens/lista_eventos_screen.dart';

void main() {
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
