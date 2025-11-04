# 🌾 ClassGrão — Aplicativo de Classificação de Grãos

Aplicativo mobile desenvolvido em **Flutter** para o sistema de **classificação de grãos**, integrando-se com uma API Node.js e um serviço de processamento de imagens em Python (OpenCV).
O app permite que o usuário **autentique, envie imagens de grãos** e **visualize os resultados de classificação** diretamente no dispositivo.

---

## 📖 Sobre o Projeto

O **ClassGrão** tem como objetivo facilitar a **análise e o controle de qualidade de grãos** por meio de uma interface moderna e intuitiva.
Ele se comunica com a **API Node.js** (responsável por autenticação e controle de dados) e uma **API Python/OpenCV** (responsável pela classificação automatizada das imagens).

**Principais funcionalidades:**

* Autenticação de usuários (login e logout)
* Upload e visualização de imagens de grãos
* Exibição dos resultados de classificação
* Histórico de análises realizadas
* Interface moderna com feedback visual (loading, toasts e alerts)

---

## 🚀 Tecnologias Utilizadas

* **Flutter** — Framework multiplataforma (Dart)
* **Riverpod 3** — Gerência de estado e injeção de dependência
* **Dio** — Cliente HTTP para comunicação com a API
* **Shared Preferences** — Armazenamento local simples
* **Validatorless** — Validação de campos em formulários
* **Top Snackbar Flutter** — Notificações de sucesso e erro
* **Loading Animation Widget** — Animações de carregamento
* **Cupertino Icons** — Ícones no estilo iOS

---

## 📦 Instalação

### 🧩 Pré-requisitos

* Flutter SDK (versão 3.24 ou superior)
* Dart SDK
* Android Studio ou VS Code com extensão Flutter
* Dispositivo/emulador Android ou iOS
* API Node.js (backend) e API Python (processamento) em execução

---

### 🪜 Passo a passo

1. **Clone o repositório:**

```bash
git clone https://github.com/UBNoneCoders/classgrao-flutter.git
cd classgrao-flutter
```

2. **Instale as dependências:**

```bash
flutter pub get
```

3. **Gere os arquivos automáticos do Riverpod:**

```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Configure o ambiente (se necessário)**

Dentro da pasta `core/config`, existe um arquivo chamado `env.dart` responsável por centralizar as configurações do ambiente da aplicação, como a URL base da API e outras variáveis importantes.

```dart
// lib/core/config/env.dart
class Env {
  static const apiBaseUrl = 'https://api.classgrao.com.br';
}
```

5. **Execute o aplicativo:**

```bash
flutter run
```

> 💡 Para desenvolvimento contínuo:
>
> ```bash
> dart run build_runner watch --delete-conflicting-outputs
> ```

---

## 📱 Execução

Para iniciar o app no emulador ou dispositivo:

```bash
flutter run
```

Para rodar no navegador (modo web):

```bash
flutter run -d chrome
```

---

## 🧪 Testes

Execute os testes automatizados com:

```bash
flutter test
```

---

## 👥 Integrantes

* [Matheus Augusto Silva dos Santos](https://github.com/Matheuz233)
* [Luan Jacomini Klho](https://github.com/luanklo)
* [Guilherme Felipe Mendonça](https://github.com/guilherme-felipe123)
