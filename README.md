<img width="344" height="530" alt="image" src="" />
# Slate: Production-Ready Kanban UI

[![Watch the Slate Demo](https://github.com/user-attachments/assets/804b6fb7-8899-4801-ad08-1f7683ea79f3)](https://www.youtube.com/shorts/LxyEU6Q8-Nk)

## Overview
Slate is a productivity board engineered to showcase absolute control over complex frontend state and gesture hierarchies. Founders building SaaS or productivity tools require zero-latency interactions; this project proves that complex state updates can happen instantly without a single dropped frame.

## Technical Execution
* **Gesture Separation:** Solved the classic gesture arena conflict by engineering a custom hierarchy. It seamlessly separates a long-press drag-and-drop action from a horizontal swipe-to-delete action on the same data card.
* **Fluid State Management:** Dragging a card across columns instantly triggers state updates in the background, ensuring the UI remains perfectly fluid during complex data mutations.
* **Premium UX:** Built-in seamless dark mode transitions, comprehensive keyboard inset handling, and accessible secondary popup menus.

## Tech Stack
* **Frontend:** Flutter
* **State Management:** Riverpod
* **Language:** Dart

---

### Local Development Setup
> **Note:** This project is a pure frontend architecture demonstration focused on custom gesture recognizers and local state mutation.
>
> To run this project locally:
> 1. Clone the repository.
> 2. Run `flutter pub get` to install dependencies (Riverpod).
> 3. Run `flutter run` to launch the application.
