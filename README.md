# App Financeiro

Aplicativo de controle financeiro pessoal desenvolvido em **Flutter**, focado no registro de movimentações, acompanhamento de metas financeiras e visualização de resumos por categoria, com armazenamento local.

## Funcionalidades

- **Dashboard Financeiro:** Visão geral das movimentações e acesso rápido às principais ações.
- **Gestão de Metas:** Criação e acompanhamento de metas financeiras através de cartões dedicados.
- **Registro e Histórico:** Adição de novos registros financeiros e visualização do histórico de lançamentos.
- **Resumo por Categorias:** Tela de resumo para acompanhar a distribuição dos valores por categoria.
- **Armazenamento Local:** Persistência de dados diretamente no dispositivo (`banco_local.dart`).

## Estrutura do Projeto

```text
lib/
├── main.dart
├── servicos/
│   └── banco_local.dart          # Gerenciamento do armazenamento local
├── telas/
│   ├── dashboard.dart            # Tela principal
│   └── resumo_screen.dart        # Tela de resumo financeiro
├── utilitarios/
│   └── valor.dart                # Formatação e utilitários de valores
└── widgets/
    ├── cartao_meta.dart          # Componente visual de metas
    ├── dialogo_acao.dart         # Diálogo de ações rápidas
    ├── dialogo_meta.dart         # Diálogo para criar/editar metas
    ├── dialogo_registro.dart     # Diálogo para novos registros
    ├── item_historico.dart       # Item da lista de histórico
    ├── menu_inferior.dart        # Barra de navegação inferior
    └── resumo_categorias.dart    # Resumo agrupado por categorias
```

## Tecnologias Utilizadas

- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)

## Como Executar o Projeto

1. **Clone o repositório:**
   ```bash
   git clone [https://github.com/therryd/app_finaceiro.git](https://github.com/therryd/app_finaceiro.git)
   cd app_finaceiro
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo:**
   ```bash
   flutter run
   ```
