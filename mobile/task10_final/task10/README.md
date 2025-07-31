# eCommerce App - Clean Architecture Refactoring

This project demonstrates an eCommerce mobile application developed with Flutter, refactored to adhere to Clean Architecture principles. The primary focus is on implementing robust CRUD (Create, Read, Update, Delete) operations for product management, with a clear separation of concerns across different layers.

## Architecture Overview

This application follows a layered Clean Architecture approach to ensure maintainability, testability, and scalability.

### Layers:

1.  **Presentation Layer (`lib/features/product/presentation`)**:
    * **Screens (`lib/features/product/presentation/screens`)**: The UI components (Widgets) that users interact with. They display data and dispatch user actions. They depend only on the Domain Layer (specifically, Use Cases) and Flutter's framework.
    * **Widgets**: Reusable UI elements.

2.  **Domain Layer (`lib/features/product/domain`)**:
    * **Entities (`lib/core/entities`)**: Pure Dart objects that encapsulate enterprise-wide business rules. They are the most stable part of the application and have no dependencies on other layers. The `Product` entity defines the core product structure.
    * **Use Cases (`lib/features/product/domain/usecases` and `lib/core/usecases`)**: Contain the application-specific business rules. Each use case represents a single, specific operation (e.g., `CreateProductUsecase`, `ViewAllProductsUsecase`). They orchestrate the flow of data to and from the repositories. They depend only on Entities and Repositories (interfaces).
    * **Repositories (`lib/features/product/domain/repositories`)**: Abstract interfaces that define contracts for data operations. These interfaces are part of the Domain Layer, ensuring the Domain Layer remains independent of how data is actually stored or retrieved.

3.  **Data Layer (`lib/features/product/data`)**:
    * **Models (`lib/features/product/data/models`)**: Data structures used for communication with external data sources (e.g., JSON serialization/deserialization). `ProductModel` extends `Product` and includes `fromJson`/`toJson` methods.
    * **Repository Implementations (`lib/features/product/data/repositories`)**: Concrete implementations of the Repository interfaces defined in the Domain Layer. They handle the actual data fetching (e.g., from a network API, local database, or in-memory storage like in this demo). They depend on Models and external data sources.

4.  **Core Layer (`lib/core`)**:
    * **Entities (`lib/core/entities`)**: Shared domain entities that might be used across multiple features.
    * **Use Cases (`lib/core/usecases`)**: Base classes or common utilities for use cases (e.g., `UseCase` abstract class, `NoParams`).
    * **Error Handling (`lib/core/error`)**: Common failure types used throughout the application.

### Data Flow for CRUD Operations:

#### 1. Viewing All Products (`ViewAllProductsUsecase`)

* **Presentation**: `HomeScreen` calls `ViewAllProductsUsecase`.
* **Domain (Use Case)**: `ViewAllProductsUsecase` calls `ProductRepository.getAllProducts()`.
* **Data (Repository Impl)**: `ProductRepositoryImpl` fetches `ProductModel` objects from its in-memory list (simulating a data source). It then converts these `ProductModel` objects into `Product` entities using `toEntity()` and returns them.
* **Presentation**: `HomeScreen` receives the list of `Product` entities and displays them.

#### 2. Creating a New Product (`CreateProductUsecase`)

* **Presentation**: `AddEditProductScreen` collects user input and creates a `Product` entity. It then calls `CreateProductUsecase` with this `Product` entity.
* **Domain (Use Case)**: `CreateProductUsecase` calls `ProductRepository.createProduct(product)`.
* **Data (Repository Impl)**: `ProductRepositoryImpl` receives the `Product` entity, converts it into a `ProductModel` using `fromEntity()`, assigns a unique ID, and adds it to its in-memory list. It might also handle sending this data to a remote API in a real application.
* **Presentation**: `AddEditProductScreen` pops back, and `HomeScreen` reloads its products to reflect the new addition.

#### 3. Updating an Existing Product (`UpdateProductUsecase`)

* **Presentation**: `AddEditProductScreen` (in edit mode) collects updated user input and creates an updated `Product` entity (using `copyWith` on the original product). It then calls `UpdateProductUsecase` with this updated `Product` entity.
* **Domain (Use Case)**: `UpdateProductUsecase` calls `ProductRepository.updateProduct(product)`.
* **Data (Repository Impl)**: `ProductRepositoryImpl` receives the updated `Product` entity, converts it to a `ProductModel`, finds the corresponding `ProductModel` by ID in its in-memory list, and updates it.
* **Presentation**: `AddEditProductScreen` pops back, and `HomeScreen` updates the specific product in its list.

#### 4. Deleting a Product (`DeleteProductUsecase`)

* **Presentation**: `HomeScreen` or `ProductDetailScreen` triggers a delete action, calling `DeleteProductUsecase` with the product's ID.
* **Domain (Use Case)**: `DeleteProductUsecase` calls `ProductRepository.deleteProduct(id)`.
* **Data (Repository Impl)**: `ProductRepositoryImpl` removes the `ProductModel` with the specified ID from its in-memory list.
* **Presentation**: The respective screen updates its UI (e.g., removes the item from the list) and shows a success message.

#### 5. Viewing a Specific Product (`ViewProductUsecase`)

* **Presentation**: (Currently not explicitly used in navigation, but would be if `ProductDetailScreen` only received an ID). A screen would call `ViewProductUsecase` with a product ID.
* **Domain (Use Case)**: `ViewProductUsecase` calls `ProductRepository.getProductById(id)`.
* **Data (Repository Impl)**: `ProductRepositoryImpl` finds the `ProductModel` by ID, converts it to a `Product` entity, and returns it.
* **Presentation**: The screen receives the `Product` entity and displays its details.

## Getting Started

1.  **Clone the repository:**
    ```bash
    git clone <YOUR_GITHUB_REPO_LINK>
    cd ecommerce_app
    ```
2.  **Ensure Flutter is installed:**
    ```bash
    flutter doctor
    ```
3.  **Get dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Run the app:**
    ```bash
    flutter run -d chrome --web-renderer html
    # Or for Android emulator:
    # flutter run
    ```
5.  **Run tests:**
    ```bash
    flutter test
    ```

---

**Final Steps for You:**

1.  **Perform the File Movements:** Create the new folders and move the files as described in the "Refactoring Plan & New Folder Structure" section.
2.  **Update `pubspec.yaml`:** Ensure `uuid` is still there.
3.  **Replace File Contents:** Copy and paste the code provided above into the respective files, making sure the import paths are correct for their new locations.
4.  **Run `flutter pub get`**: After moving files and updating imports, this is crucial to ensure Dart resolves all new paths.
5.  **Run `flutter test`**: To verify the `ProductModel` tests pass.
6.  **Run the app**: To verify everything works as expected.
7.  **Push to GitHub:** Update your GitHub repository with these changes and ensure the `README.md` is included.

This refactoring significantly enhances the project's adherence to Clean Architecture, making it a robust foundation for future development.