# 📝 Todo Application

Aplicativo de lista de tarefas desenvolvido em Flutter com arquitetura robusta e escalável, preparado para crescimento e manutenção de longo prazo.

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Funcionalidades](#funcionalidades)
- [Arquitetura](#arquitetura)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Instalação](#instalação)
- [Como Usar](#como-usar)
- [Testes](#testes)
- [Padrões de Código](#padrões-de-código)

## 🎯 Sobre o Projeto

Este é um aplicativo de gerenciamento de tarefas (To-Do List) desenvolvido com foco em qualidade de código, escalabilidade e experiência do usuário. O projeto foi construído seguindo princípios de Clean Architecture e boas práticas de desenvolvimento Flutter.

## ✨ Funcionalidades

### Principais Recursos

- ✅ **Criar Tarefas**: Adicione novas tarefas com título e status personalizável
- ✏️ **Editar Tarefas**: Modifique título e status de tarefas existentes
- 🗑️ **Excluir Tarefas**: Remova múltiplas tarefas selecionadas de uma vez
- ☑️ **Marcar/Desmarcar**: Selecione tarefas para exclusão ou alteração de status
- 🔍 **Filtros**: Visualize tarefas por status (Todas, Pendentes, Concluídas)
- 💾 **Persistência**: Dados salvos localmente com SharedPreferences
- 🎨 **UI Moderna**: Interface limpa e intuitiva com design responsivo

### Status de Tarefas

- **Pending**: Tarefa pendente
- **In Progress**: Tarefa em andamento
- **Done**: Tarefa concluída

## 🏗️ Arquitetura

O projeto segue os princípios de **Clean Architecture** e **SOLID**, garantindo:

- **Separação de responsabilidades**
- **Facilidade de manutenção**
- **Testabilidade**
- **Escalabilidade**
- **Baixo acoplamento**

### Camadas da Arquitetura

```
lib/
├── core/                      # Núcleo da aplicação
│   ├── app/                   # Estados e configurações globais
│   ├── config/                # Configurações (cache, etc)
│   ├── routers/               # Roteamento modular
│   └── theme/                 # Tema e estilos
│
├── modules/                   # Módulos da aplicação
│   ├── shared/                # Componentes compartilhados
│   └── todo/                  # Módulo de tarefas
│       ├── domain/            # Regras de negócio e modelos
│       ├── presentation/      # UI e gerenciamento de estado
│       │   ├── cubits/        # Lógica de estado (BLoC)
│       │   ├── pages/         # Telas
│       │   └── widgets/       # Componentes reutilizáveis
│       └── todo_module.dart   # Configuração do módulo
│
└── main.dart                  # Ponto de entrada
```

## 🛠️ Tecnologias Utilizadas

### Dependências Principais

- **[flutter_modular](https://pub.dev/packages/flutter_modular)** - Gerenciamento de rotas e injeção de dependências
- **[flutter_bloc](https://pub.dev/packages/flutter_bloc)** - Gerenciamento de estado
- **[shared_preferences](https://pub.dev/packages/shared_preferences)** - Persistência local

### Dependências de Desenvolvimento

- **[bloc_test](https://pub.dev/packages/bloc_test)** - Testes de BLoC/Cubit
- **[mocktail](https://pub.dev/packages/mocktail)** - Mocks para testes
- **[flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html)** - Framework de testes
- **[flutter_lints](https://pub.dev/packages/flutter_lints)** - Análise de código

## 📁 Estrutura do Projeto

### Domain Layer (Domínio)

```dart
// Modelo de dados
TodoItemModel
  - id: String
  - title: String
  - status: TodoItemStatus (pending, inProgress, done)
```

### Presentation Layer (Apresentação)

#### Cubit (Gerenciamento de Estado)

```dart
TodoCubit
  - onInit()                    // Inicialização e carregamento
  - addTodo()                   // Adicionar tarefa
  - editTodo()                  // Editar tarefa
  - excludeTodo()               // Excluir tarefas selecionadas
  - onSelectItem()              // Selecionar/desselecionar tarefa
  - onFilterChanged()           // Alterar filtro
```

#### State (Estado)

```dart
TodoState
  - status: PageStatus          // Estado da página
  - todoList: List<TodoItem>    // Lista completa
  - selectedItems: List<TodoItem> // Itens selecionados
  - selectedFilter: String      // Filtro ativo
  - filteredTodoList: List      // Lista filtrada (getter)
```

### Core Layer (Núcleo)

#### SharedPreferences Wrapper

```dart
CustomSharedPreferences
  - setTodoList()               // Salvar lista
  - getTodoList()               // Recuperar lista
  - removeTodoItem()            // Remover itens
```

## 🚀 Instalação

### Pré-requisitos

- Flutter SDK (>=3.5.4)
- Dart SDK (>=3.5.4)
- Android Studio / VS Code
- Emulador ou dispositivo físico

### Passos

1. **Clone o repositório**
```bash
git clone <repository-url>
cd todo_application
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute o aplicativo**
```bash
flutter run
```

## 💡 Como Usar

### Adicionar uma Tarefa

1. Toque no botão flutuante azul **+**
2. Digite o título da tarefa
3. Selecione o status (Pending, In Progress, Done)
4. Toque em **Add Task**

### Editar uma Tarefa

1. Toque no ícone de edição (✏️) na tarefa
2. Modifique o título e/ou status
3. Toque em **Save**

### Excluir Tarefas

1. Selecione as tarefas marcando o checkbox
2. Toque no botão vermelho de exclusão (🗑️)
3. As tarefas selecionadas serão removidas

### Filtrar Tarefas

Use os botões segmentados no topo:
- **All**: Mostra todas as tarefas
- **Pending**: Apenas tarefas pendentes
- **Done**: Apenas tarefas concluídas

## 🧪 Testes

O projeto possui cobertura de testes para garantir qualidade e confiabilidade.

### Executar todos os testes

```bash
flutter test
```

### Executar com cobertura

```bash
flutter test --coverage
```

### Tipos de Testes

- **Testes Unitários**: Modelos e lógica de negócio
- **Testes de Cubit**: Gerenciamento de estado
- **Testes de Integração**: Fluxos completos da aplicação

### Estrutura de Testes

```
test/
├── helpers/                   # Utilitários de teste
├── modules/
│   └── todo/
│       ├── domain/            # Testes de modelos
│       └── presentation/
│           ├── cubits/        # Testes de Cubit/State
│           └── pages/         # Testes de integração
```

## 📐 Padrões de Código

### Convenções

- **Nomenclatura**: camelCase para variáveis, PascalCase para classes
- **Arquivos**: snake_case
- **Constantes**: kPrefixName (ex: kMarginDefault)
- **Widgets**: Sempre const quando possível
- **Imports**: Ordenados (dart, flutter, packages, relative)

### Boas Práticas Implementadas

✅ Separação de responsabilidades (SRP)  
✅ Injeção de dependências  
✅ Imutabilidade de estados  
✅ Widgets reutilizáveis  
✅ Tratamento de erros  
✅ Código limpo e documentado  
✅ Testes automatizados  

### Análise de Código

O projeto usa `flutter_lints` para garantir qualidade:

```bash
flutter analyze
```

## 🎨 Design System

### Cores

- **Primary**: Dark Blue (#1971BE)
- **Background**: Light Gray (#F5F5F5)
- **Error**: Red
- **Success**: Green
- **Text**: Black/Gray

### Tipografia

- **Fonte**: Nunito (Google Fonts)
- **Tamanhos**: 12, 14, 16, 18, 20, 24

### Espaçamentos

- **Small**: 8px
- **Default**: 16px
- **Medium**: 24px
- **Large**: 32px

## 👨‍💻 Desenvolvedor

**Rivaldo Pedro**
