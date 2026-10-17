# Agenda de Eventos do Campus

App em Flutter/Dart para a avaliação de Programação Móvel (IFBA), com o tema "Agenda de Eventos do Campus".

O aplicativo lista os eventos do campus (palestras e oficinas) com detalhes, comentários e confirmação de presença. Visitantes navegam e leem o conteúdo; usuários logados também confirmam presença e publicam comentários. Todos os dados vêm de JSON estáticos em `assets/` e nada é persistido — as presenças e os comentários criados existem apenas em memória.

## Como instalar e rodar

Pré-requisito: [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `^3.13.5`).

1. Instale as dependências:

```bash
flutter pub get
```

2. Rode o app em um dos alvos abaixo.

**Navegador (qualquer navegador, porta fixa):**

```bash
flutter run -d web-server --web-port 8080
```

Depois abra [http://localhost:8080](http://localhost:8080) no navegador.

**Navegador (Chrome):**

```bash
flutter run -d chrome
```

**Desktop Windows:**

```bash
flutter run -d windows
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
- Ver os detalhes de um evento: tipo, data, horário, local, palestrante, vagas e descrição
- Ler os comentários de cada evento
- Fazer login pelo botão "Entrar" na barra superior

### Usuário logado

- Tudo o que o visitante pode fazer, e ainda:
- **Confirmar presença** em um evento — o botão alterna para "Cancelar presença" e as vagas são ajustadas na hora (na lista e nos detalhes)
- **Publicar comentários** nos eventos, que aparecem com o nome do usuário e a data de hoje
- Abrir a tela **"Meus eventos"** (botão na barra superior), com os eventos em que confirmou presença — título, data e local, abrindo os detalhes ao tocar
- Fazer **logoff** ("Sair") pela lista de eventos ou pela tela "Meus eventos"

Obs.: nada é salvo em disco — ao reiniciar o aplicativo, os dados voltam ao estado original dos JSONs.
