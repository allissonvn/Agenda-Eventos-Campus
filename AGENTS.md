# AGENTS.md

App Flutter/Dart da avaliação de Programação Móvel (IFBA). Tema: "Agenda de Eventos do Campus". Entrega do front-end: 17/10/2026.

## Comandos (Windows)
- `flutter pub get`
- `flutter analyze` deve passar sem erros antes de considerar uma etapa concluída.
- `flutter run -d windows` é o único alvo de execução configurado (sem Chrome e sem Android SDK).
- Não há testes escritos; não invente suíte de testes.

## Restrições da avaliação (não violar)
- Apenas Dart + Flutter com recursos simples de aula: StatefulWidget/setState, Navigator, ListView.builder, formulários. Não adicionar pacotes de estado (provider, bloc, riverpod etc.), backend ou banco de dados.
- Mínimo de 2 telas, com ao menos uma lista.
- Login/logoff mockado, com usuário hardcoded. Visitante (sem login) vê lista, detalhes e comentários; só o logado confirma presença e comenta.
- Dados vêm de JSON estáticos em `assets/` (eventos, comentarios, usuarios), carregados com `rootBundle` e registrados no `pubspec.yaml`. Nada é persistido além da memória.
- Proibido tema de "listagem de produtos de marcas".

## Estrutura planejada
- `lib/models`, `lib/screens`, `lib/services` e `assets/*.json`.
- Telas: lista de eventos, detalhes do evento, login, meus eventos.