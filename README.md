# AgroMind

## 🌿 AI-Driven Plant Health Advisor
AgroMind is an intelligent mobile application designed to help home gardeners monitor and maintain plant health using AI-powered diagnosis and personalized care recommendations. This app leverages **machine learning, image processing, and AI-driven insights** to detect plant diseases, provide treatment solutions, and guide users on optimal plant care.

## 📷UI
![AgroMind](https://github.com/user-attachments/assets/eb6f18ea-aede-41ae-ae4d-23886abd85e7)

## 🚀 Features
### 🔹 **User Authentication**
- Firebase Authentication for secure login and registration.
- Email verification and password reset functionality.

### 🌱 **Plant Health Diagnosis**
- Users can upload plant images for disease detection.
- AI-driven plant disease diagnosis using a trained **machine learning model**.
- Personalized care recommendations based on the diagnosis.

### 📚 **Plant Library**
- A database of various plants with care guides.
- Users can explore detailed information about plant species.

### 🏡 **My Garden**
- Users can save their plants and track their health progress.
- AI-generated reminders for watering, fertilization, and pruning.

### 🗣️ **AI Chatbot (Plant Health Advisor)**
- Users can interact with an **AI-powered assistant** to get gardening tips.
- Voice and text-based interactions supported.

### 🌍 **Community Forum**
- Users can create and share posts with the gardening community.
- Like and comment on posts.
- Edit and delete comments using swipe gestures.

### 📌 **Profile Management**
- Users can update their profile, including username and profile picture.
- Personalized dashboard for tracking activities.

### 🔔 **Push Notifications & Reminders**
- Timely notifications for plant care.
- Community post interactions and updates.

## 🛠️ Tech Stack
### 📱 **Frontend:**
- Flutter (Dart)
- GetX for state management
- Firebase Authentication

### 🏗️ **Backend & Database:**
- Firebase Firestore for real-time database
- Firebase Storage for image storage
- Cloud Functions for AI integration

### 🤖 **Machine Learning & AI:**
- TensorFlow Lite for on-device AI-based plant disease detection
- Google Firebase ML Kit for image analysis

## 📂 Folder Structure
```
├── lib
│   ├── bindings/ (State management bindings)
│   ├── controllers/ (Business logic controllers)
│   ├── models/ (Data models)
│   ├── screens/ (UI screens)
│   ├── widgets/ (Reusable UI components)
│   ├── main.dart (Main application file)
│
├── assets
│   ├── images/ (UI assets & icons)
│   ├── fonts/ (Custom fonts)
│
├── firebase_options.dart (Firebase configuration)
├── pubspec.yaml (Dependencies & assets configuration)
├── README.md (Project documentation)
```

## 🔥 Installation & Setup
### 1️⃣ **Clone the Repository**
```bash
git clone https://github.com/your-repo/agromind.git
cd agromind
```

### 2️⃣ **Install Dependencies**
```bash
flutter pub get
```

### 3️⃣ **Set Up Firebase**
- Create a Firebase project.
- Enable Firestore, Authentication, and Storage.
- Download `google-services.json` (for Android) & `GoogleService-Info.plist` (for iOS) and place them in the respective folders.

### 4️⃣ **Run the App**
```bash
flutter run
```

## 📜 Firestore Security Rules
```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /community_posts/{postId} {
      allow read, write: if request.auth != null;
      allow update, delete: if request.auth.uid == resource.data.userId;
    }
  }
}
```

## 🤝 Contributing
Feel free to contribute to AgroMind! Follow these steps:
1. Fork the repository.
2. Create a new branch (`feature-xyz`).
3. Commit your changes.
4. Push to your fork and submit a Pull Request.

## 📩 Contact
For inquiries or issues, contact: **kusumkarsuyash1234@gmail.com**

---
_🚀 Developed with ❤️ by AgroMind Team (Suyash Kusumkar)._

