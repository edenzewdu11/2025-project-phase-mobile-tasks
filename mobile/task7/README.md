# 🛍️ Task 7: Flutter E‑commerce Navigation & Routing Project

## 🚀 Overview

This Flutter project demonstrates a simple **e‑commerce application** with **structured navigation and routing** using Flutter's built‑in Navigator and named routes.  
The app allows users to **create, view, update, and delete products**, while ensuring a seamless user experience through smooth transitions and proper data flow between screens.

## 📌 Navigation Flow

- **Home Screen**
  - Displays a list of all products.
  - **Add Button:** Navigates to the Add/Edit Product Screen using a named route.
  - **Product Cards:** Navigate to the Product Details Screen, passing the selected product data as arguments.

- **Product Details Screen**
  - Shows detailed information about a product.
  - **Edit Button:** Routes to the Add/Edit Product Screen with the product data passed for editing.
  - **Delete Button:** Deletes the product and pops back to the Home Screen.

- **Add/Edit Product Screen**
  - Allows adding a new product or editing an existing one.
  - On submit, product data is returned to the Home Screen to update the product list.
  - A back button or navigation action properly returns to the Home Screen.

## ✨ Features Implemented

✅ **Screen Navigation:**  
Home ➡️ Add/Edit ➡️ View details, with smooth transitions.

✅ **Named Routes:**  
Each screen is registered with a named route and navigated via `Navigator.pushNamed`.

✅ **Passing Data Between Screens:**  
Products are passed as arguments to detail and edit screens and returned to update the list.

✅ **Navigation Animations:**  
Smooth, built‑in animations when navigating between screens.

✅ **Handling Navigation Events:**  
Pressing the system back button or custom back arrows returns users to the previous screen gracefully.

## 📦 Getting Started

1. Ensure Flutter is installed and configured.
2. Clone or download the repository.
3. Run the following commands inside the project folder:

```bash
flutter pub get
flutter run
