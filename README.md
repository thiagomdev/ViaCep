# 📮 ViaCep

Um app iOS para consulta de CEPs brasileiros, construído com UIKit e arquitetura VIP (Clean Swift).

<p align="left">
  <img width="300" alt="ViaCepApp Demo" src="https://github.com/thiagomdev/ViaCepApp/assets/67831549/cd0ee52b-206f-42e3-a7f7-1e90b127cfbc" />
</p>

## 🏛 Arquitetura

- **VIP** — View → Interactor → Presenter
- **Factory Pattern** — composição de dependências centralizada
- **WebService genérico** — camada de rede reutilizável

## 🛠 Tecnologias

- Swift
- UIKit
- URLSession
- CocoaPods
- GitHub Actions (CI)

## 🧪 Testes

- XCTest
- Padrão de **Fixtures** para dados de teste
- **Spies** para verificação de interações
- Estrutura espelhando a do app

## 📂 Estrutura de Pastas

```
ViaCep/
├── Scenes/
│   ├── View/
│   ├── Interactor/
│   ├── Presenter/
├── Services/
│   └── WebService/
├── Factories/
├── Models/
└── Resources/

ViaCepTests/
├── Fixtures/
├── Spies/
└── Scenes/
```

## 🌐 API

O app consome a API pública do [ViaCEP](https://viacep.com.br):

```
GET https://viacep.com.br/ws/{cep}/json/
```

## 🚀 Como rodar

1. Clone o repositório
2. Rode `pod install` na raiz do projeto
3. Abra o `ViaCep.xcworkspace` (não o `.xcodeproj`)
4. Rode no simulador com `Cmd + R`
