# Flash Chat ⚡️

A modern, real-time messaging application built with **Flutter** and **Firebase**. This project features user authentication, a live cloud database, and custom animations.

---

## 🚀 Features

* **User Authentication**: Secure registration and login powered by Firebase Auth.
* **Real-time Messaging**: Instant chat synchronization using Firebase Cloud Firestore streams.
* **Smooth UI & Animations**: Screen transitions powered by Flutter's `Hero` widget and custom `AnimationController` flows.
* **Auto-scrolling Chat View**: Dynamic `ListView` rendering for real-time conversation updates.

---

## 🧠 What I Learned

* **Firebase Integration**: Setting up Firebase Auth for email/password user management and Cloud Firestore for NoSQL data persistence.
* **Dart Streams & Reactive UI**: Utilizing `StreamBuilder` and asynchronous Dart streams to sync and render incoming messages in real-time.
* **Flutter Animations**: Implementing shared element screen transitions with the `Hero` widget and orchestrating custom UI animations using `AnimationController`.
* **Dart Mixins**: Leveraging `SingleTickerProviderStateMixin` to handle animation frame ticks efficiently.
* **Custom & Reusable UI Components**: Refactoring repetitive UI elements (such as styled text fields and custom buttons) into isolated, reusable Flutter widgets.

---

## 🛠️ Tech Stack

* **Framework**: Flutter (Dart)
* **Backend Services**: Firebase Authentication & Cloud Firestore
* **UI & Components**: Hero Animations, Custom Animation Controllers, StreamBuilder, ListView

---

## 📦 Getting Started

### Prerequisites

* [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.
* A [Firebase Console](https://console.firebase.google.com/) account.

### Installation

1. **Clone the repository**:
   ```bash
   git clone [https://github.com/YOUR_USERNAME/flash-chat-flutter.git](https://github.com/YOUR_USERNAME/flash-chat-flutter.git)
   cd flash-chat-flutter
