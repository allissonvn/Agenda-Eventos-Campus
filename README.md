# Agenda de Eventos do Campus

App em Flutter/Dart desenvolvido para a avaliação de Programação Móvel (IFBA), com o tema "Agenda de Eventos do Campus".

O aplicativo lista os eventos do campus (palestras e oficinas) com detalhes e comentários. Visitantes podem ver a lista, filtrar e ver os detalhes e os comentários; usuários logados também podem confirmar presença, publicar comentários e ver seus eventos.

O login é **mockado** (usuários fixos em `assets/usuarios.json`) e todos os dados vêm de **JSON estáticos** em `assets/` — nada é persistido, tudo fica em memória durante a sessão.

## Como executar

Pré-requisito: [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `^3.13.5`).

Instale as dependências:

```
flutter pub get
```

Execute no navegador (qualquer navegador, porta fixa):

```
flutter run -d web-server --web-port 8080
```

Depois abra [http://localhost:8080](http://localhost:8080) no navegador.

Outros alvos:

```
flutter run -d chrome
flutter run -d windows
flutter run -d linux
```

Em emulador Android:

```
flutter run
```

## Usuários de teste (login mockado)

Os dois usuários de `assets/usuarios.json`:

| Nome | E-mail | Senha |
| --- | --- | --- |
| Ana Souza | `ana.souza@aluno.ifba.edu.br` | `123456` |
| Bruno Lima | `bruno.lima@aluno.ifba.edu.br` | `senha123` |

Qualquer outro e-mail ou senha mostra a mensagem "E-mail ou senha inválidos.".

## Funcionalidades

### Visitante (sem login)

- Ver a lista de todos os eventos, com filtro por tipo (**Todos / Palestra / Oficina**)
- Ver os detalhes de um evento (tipo, data, horário, local, palestrante, vagas e descrição)
- Ver os comentários de cada evento
- Fazer login pelo botão "Entrar"

### Usuário logado

- **Confirmar presença** em eventos — o botão alterna para "Cancelar presença" e as vagas são ajustadas na hora
- **Comentar** nos eventos — o comentário aparece com o nome do usuário e a data
- Ver a tela **"Meus eventos"**: os eventos em que confirmou presença, com título, data e local
- **Sair** (logoff) pela lista de eventos ou pela tela "Meus eventos"

Obs.: presenças e comentários criados durante a sessão ficam apenas em memória — ao reiniciar o aplicativo, os dados voltam ao estado original dos JSONs.
