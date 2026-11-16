# APP_UiKit_Acompanhamento-Hidrico

Aplicativo iOS em **UIKit** para acompanhamento de ingestão diária de água.

## Objetivo

Permitir que o usuário registre a quantidade de água bebida, visualize o progresso em relação a uma meta diária, edite/exclua registros do dia e tenha reset automático ao mudar de dia, com histórico armazenado localmente.

---

## Arquitetura do Projeto

O projeto segue o padrão **MVC (Model-View-Controller)**, recomendado pela Apple para UIKit, com uma camada adicional de **Manager** para centralizar persistência e regras de negócio.

### Estrutura de Pastas

```
APP_UiKit_Acompanhamento-Hidrico/
├── Models/           → Entidades de dados (Model)
├── Managers/         → Lógica de negócio e persistência
├── Views/            → Componentes de interface reutilizáveis (View)
└── ViewControllers/  → Orquestração entre Model e View (Controller)
```

### Responsabilidades por Camada

#### Models
Contém apenas estruturas de dados. Não depende de UIKit.  
Exemplo: `WaterEntry` — representa um registro de água ingerida (id, quantidade em litros, data).

#### Managers
Encapsula regras de negócio e acesso a dados. É singleton (`WaterManager.shared`) para ser acessível de qualquer controller.  
Responsabilidades:
- Adicionar e remover entradas
- Calcular total do dia
- Persistir dados em `UserDefaults` (via `JSONEncoder/Decoder`)
- Detectar mudança de dia e resetar o contador automaticamente

#### Views
Classes `UIView` customizadas que desenham a interface e expõem apenas o necessário.  
Não conhecem regras de negócio. Recebem dados via propriedades públicas e chamam métodos do Controller quando o usuário interage.  
Exemplo: `WaterProgressView` — barra de progresso visual da meta diária.

#### ViewControllers
Orquestram a tela. Instanciam as Views, conectam ações de botões (`addTarget`), consultam o Manager e atualizam a interface.  
Não contêm lógica de negócio complexa nem acesso direto a banco/arquivos.

---

## Regras de Convenção

1. **Nenhuma lógica de negócio em `ViewController`**: se envolve cálculo, persistência ou decisão de dados, vá para o `Manager`.
2. **View não importa `Manager`**: Views são estúpidas (dumb views). Elas só exibem o que recebem.
3. **Auto Layout programático**: todas as views usam `translatesAutoresizingMaskIntoConstraints = false` e `NSLayoutConstraint`. Não use frames fixos.
4. **Nomes em inglês para classes e identificadores**: comentários e documentação em português são aceitáveis, mas o código segue padrão da comunidade Swift/iOS.
5. **`final` em classes**: use `final` sempre que não houver intenção de herança (otimização e clareza de design).
6. **Evitar Storyboards/XIBs**: este projeto é 100% programmatic UI para facilitar versionamento e code review.

---

## Como Definir a Tela Inicial

No `SceneDelegate.swift` (ou `AppDelegate.swift`), defina o `ViewController` raiz:

```swift
let rootVC = WaterTrackerViewController()
let navController = UINavigationController(rootViewController: rootVC)
window?.rootViewController = navController
window?.makeKeyAndVisible()
```

---

## Escopo Atual (MVP)

- [x] Campo de entrada de quantidade (litros)
- [x] Botão "Adicionar" com validação
- [x] Barra de progresso em relação à meta diária (2 L)
- [x] Lista de entradas do dia (`UITableView`)
- [x] Exclusão por swipe em uma entrada
- [x] Persistência local em `UserDefaults`
- [x] Reset automático do contador ao mudar de dia

---

## Próximos Passos Sugeridos (se houver tempo)

- Tela de edição de entrada existente
- Meta diária ajustável pelo usuário
- Histórico de dias anteriores com gráfico simples
- Notificações locais para lembrar de beber água
