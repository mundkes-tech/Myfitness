# 🏆 MyFitness — Smart Fitness & Wellness App

A comprehensive mobile fitness application built with Flutter & Firebase to help users track workouts, plan diets, manage routines, and achieve their fitness goals — featuring voice-guided exercises, personalized plans, progress tracking, and real-time data sync.

<div align="center">

![alt text](image.png)

![alt text](image-1.png)

</div>

## ✨ Core Highlights

- ✅ Full workout module suite
- ✅ Personalized diet planning
- ✅ Daily routine manager
- ✅ Built-in workout timer
- ✅ Voice guidance + haptic feedback
- ✅ Firebase-powered authentication & storage
- ✅ Clean & interactive UI with animations

## 🏋️ Workout Modules

Includes structured training programs for:

- Chest
- Back
- Shoulders
- Abs / Core
- Legs
- Biceps
- Triceps
- Forearms

### 🧘‍♂️ Mind Relaxation & Breathing Exercises

Each workout includes:

- Guided reps & rest intervals
- Visual progress indicators
- Voice instructions
- Motivation feedback animations 🎉

## 🍎 Diet Planner

Personalized diet planning based on:

- Age, height, weight
- Gender
- Fitness goal
- Activity level

**Features:**

- Customizable meal plans
- Smart calorie recommendations
- Editable inputs & preferences

## 📅 Daily Routine Manager

- Create and track daily habits
- Routine reminders
- Progress visualization
- Activity logs

Helps users stay consistent 💪

## ⏱ Workout Timer & Feedback

- Adjustable workout intervals
- Voice prompts (TTS)
- Vibration alerts
- Confetti celebration animations 🎊

Keeps workouts engaging & gamified.

## 👤 User & Profile Management

- Firebase authentication (secure login)
- User profiles & preferences
- Shared Preferences for local state
- Cloud-synced progress storage

## 🛠 Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **Backend:** Firebase

### Modules Used:
- Firestore
- Realtime Database
- Authentication

### State & Utilities:
- Shared Preferences
- Custom Widgets
- Utility helpers

### Additional Libraries:
- `flutter_tts` — voice guidance
- `vibration` — haptic feedback
- `confetti` — celebration effects
- `percent_indicator` — progress bars

## 🚀 Installation & Setup

### ✅ Prerequisites
- Flutter SDK (>= 3.3.4)
- Dart SDK
- Android Studio / VS Code
- Firebase project

### 🔧 Clone Repository
```bash
git clone https://github.com/your-username/myfitness.git
cd myfitness
```

### 📦 Install Dependencies
```bash
flutter pub get
```

### 🔗 Firebase Configuration
- Create project in Firebase Console
- Enable:
  - Firestore
  - Realtime Database
- Download `google-services.json`
- Place in: `android/app/`
- Update Firebase config in: `lib/firebase_options.dart`

### ▶️ Run the App
```bash
flutter run
```

## 📱 App Workflow

1. **Launch** → Splash Screen
2. **Register / Login**
3. **Select Workout or Diet Module**
4. **Create Custom Plans**
5. **Track Daily Routine**
6. **Train using Voice-Guided Workouts**

## 📂 Project Structure

```
lib/
├── main.dart
├── firebase_options.dart
├── SplashScreen.dart
├── LoginScreen.dart
├── RegistrationScreen.dart
├── HomeScreen.dart
├── DietPlanner.dart
├── TimerScreen.dart
├── dailyroutine.dart
├── myplanScreen.dart
├── addplanScreen.dart
├── [Workout Modules].dart
└── Common.dart
```

## 🤝 Contributing

Contributions are welcome!

- Fork repo
- Create branch
- Commit changes
- Push branch
- Open PR

## 📄 License

MIT License — see LICENSE for details.

## 🙌 Acknowledgments

- Flutter team
- Firebase community
- Open-source contributors

💪 **Stay fit, stay consistent — build healthy habits!**