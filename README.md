# ServeMe

Um novo projeto em Flutter.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Padrão de mensagens de commit (Conventional Commits)

A estrutura é: 

 **< tipo > ( escopo opcional ): < descrição curta >**


## Tipos principais
- **feat** → nova funcionalidade  
- **fix** → correção de bug  
- **docs** → mudanças na documentação  
- **style** → formatação, espaços, lint (sem alterar lógica)  
- **refactor** → refatoração de código sem mudar comportamento  
- **test** → adicionar ou corrigir testes  
- **chore** → tarefas de manutenção (build, configs, dependências)  

## Exemplos práticos para o ServeMe
- `feat: adicionada tela de gerenciamento de estabelecimento`  
- `feat: integração login com backend para recuperar userId`  
- `fix: corrigido aviso de BuildContext across async gaps`  
- `refactor: substituído value por initialValue em DropdownButtonFormField`  
- `chore: atualizado pubspec.yaml com novas dependências`  

---

## Benefícios
- Histórico mais **legível** e **padronizado**  
- Facilita **changelog automático** e integração com CI/CD  
- Ajuda a equipe a entender rapidamente o que mudou em cada commit  
