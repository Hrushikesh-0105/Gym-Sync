
# 💪 GymSync – Smart Gym Membership Tracker

**GymSync** is a scalable, cross-platform gym management application built with Flutter. Designed to streamline membership tracking, renewals, and client communication, it offers seamless data synchronization across devices using Firebase and SQLite.

---

## 📱 Features

- **Multi-Gym Support**: Each gym can securely create and manage its own account using email-based authentication.
- **Membership Management**: Track active members, renewal dates, and expired memberships efficiently.
- **Cross-Device Sync**: Ensure data consistency across multiple devices with timestamp-based updates.
- **Offline Mode**: Utilize SQLite for offline data access, ensuring functionality without internet connectivity.
- **Automated Reminders**: Send bulk SMS reminders to members with expired or soon-to-expire memberships.
- **Data Backup**: Integrate with Google Sheets for data backup and easy access to membership records.

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Authentication & Firestore)
- **Local Storage**: SQLite
- **Backup & Reporting**: Google Sheets Integration
- **Notifications**: SMS API for bulk messaging

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed
- Firebase project setup
- Android Studio or VS Code

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/Hrushikesh-0105/Gym-Sync.git
   cd Gym-Sync
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Configure Firebase**:

   - Add your `google-services.json` file to the `android/app/` directory.
   - Add your `GoogleService-Info.plist` file to the `ios/Runner/` directory.

4. **Run the application**:

   ```bash
   flutter run
   ```
---
