# 🏍️ Flutter E-Commerce UI App (Clean Architecture)

A modern, cleanly structured E-Commerce Product Management app built with Flutter using Clean Architecture principles. This app enables users to view, add, update, and delete products with a sleek, intuitive UI and smooth animations.

---

## ✨ Features

* 📦 View a list of available products
* ➕ Add new products with name, category, price, and description
* ✏️ Update existing products
* 🗑️ Delete products
* 🔍 View detailed product information including size selection
* 💫 Smooth page transitions (fade, slide, scale animations)

---

## 🧠 Architecture

This project follows the **Clean Architecture** pattern, promoting separation of concerns, testability, and scalability.

```
lib/
🔽️ core/                       # Core utilities (common widgets, styles, constants, error handling)
🔽️ features/
│   └🔾 product/
│       ├🔾 data/               # Data layer (models, datasources, repositories implementation)
│       ├🔾 domain/             # Domain layer (entities, repository abstract classes, use cases)
│       └🔾 presentation/       # Presentation layer (UI screens, widgets, blocs/cubits/providers)
🔽️ main.dart                   # App entry point and routing
```

### 📂 Test Structure

The `test/` directory mirrors the `lib/` structure for easy unit and widget testing:

```
test/
🔾 features/
    └🔾 product/
        ├🔾 data/
        ├🔾 domain/
        └🔾 presentation/
```

---

## 🔄 Data Flow

![Clean Architecture Diagram](screenshots/Clean-Architecture-Flutter-Diagram.webp)


Each layer only depends on the layer directly below it. This ensures high decoupling and testability.

---

## 📸 Screenshots

| Home Page                     | Product Details                     | Add Product                 |
| ----------------------------- | ----------------------------------- | --------------------------- |
| ![Home](screenshots/home.jpg) | ![Details](screenshots/details.jpg) | ![Add](screenshots/add.jpg) |

---

## 🚀 Getting Started

### ✅ Prerequisites

* Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
* IDE: VS Code / Android Studio
* Android/iOS emulator or real device

---

### 🛠️ Installation

Clone the repository and run the app:

```bash
# Clone this repository
git clone https://github.com/your-username/flutter-ecommerce-ui.git

# Go into the project folder
cd flutter-ecommerce-ui

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## ✅ Testing

Run all tests:

```bash
flutter test
```

Test files are organized using the same structure as the `lib/` directory to ensure alignment and clarity.

---

## 🧩 Technologies Used

* 🧱 Flutter 
* 🗺 Clean Architecture
* 💡 Provider 
* 🧪 flutter\_test & mockito (for testing)

---

## 🤝 Contributing

Feel free to open issues or submit pull requests. Contributions are welcome!
