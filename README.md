
# 💪 GymSync – Smart Gym Membership Tracker

**GymSync** is a scalable, cross-platform gym management application built with **Flutter**. Designed for gym owners to easily manage memberships, renewals, and client communication, **GymSync** synchronizes data securely across devices using **Firebase Google Authentication**, **Cloud Firestore**, and **SQLite** for offline support.

---

## 📱 Features

✅ **Google Sign-In**  
Secure sign-up and login with Google accounts for gym owners.

✅ **Multi-Gym Support**  
Each gym creates its own unique profile with an owner name and gym name.

✅ **Home Dashboard**  
Quickly navigate between dashboards and manage customers easily.

✅ **Customer Management**  
- Search, filter, and manage customers with a smart search bar and clear customer cards.
- Add new customers in two simple steps: **Personal Details** and **Membership Details**.
- View detailed customer profiles, including active and past membership records.

✅ **Automated Reminders**  
- Expired memberships are flagged clearly.
- Send reminders directly via WhatsApp or SMS.
- Dialog box lets you choose to send via WhatsApp, SMS, or both.

✅ **Cross-Device Sync**  
Keep membership data consistent across devices with real-time Firestore updates and local timestamp checks.

✅ **Offline Mode**  
Work offline with **SQLite** local storage — all changes sync automatically once you’re connected again (feature work in progress).

✅ **Data Backup**  
Optional Google Sheets integration for exporting membership data for backup and reporting.

---

## 🛠️ Tech Stack

- **Frontend:** Flutter (Dart)
- **Authentication:** Firebase Google Sign-In
- **Backend Database:** Firebase Firestore
- **Offline Storage:** SQLite
- **Backup & Reporting:** Google Sheets Integration
- **Notifications:** SMS & WhatsApp API

---

## 🚀 Getting Started

### ✅ Prerequisites

- Flutter SDK installed
- Firebase project set up with Google Authentication enabled
- Android Studio or VS Code installed

### 📥 Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/Hrushikesh-0105/Gym-Sync.git
   cd Gym-Sync
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase**

   - Add your `google-services.json` to `android/app/`
   - Add your `GoogleService-Info.plist` to `ios/Runner/`

4. **Run the application**

   ```bash
   flutter run
   ```

---

## 📌 Project Structure

### 🔑 Sign Up  
Secure Google Sign-In for gym owners.  
<img src="/assets/screenshots/signup.jpg" alt="Sign Up Screen" width="300"/>

---

### 📝 Profile Setup  
Enter owner name and gym name after sign-up.  
<img src="/assets/screenshots/profile_setup.jpg" alt="Profile Setup Screen" width="300"/>

---

### 🏠 Home Screen  
Navigate to customer list and manage memberships.  
<img src="/assets/screenshots/home_screen.jpg" alt="Home Screen" width="300"/>

---

### 👥 Customer Screen  

**Customers Page:** Show key info with status and filter customers.  
<img src="/assets/screenshots/customer_page.jpg" alt="Customer Cards" width="300"/>

<img src="/assets/screenshots/filters.jpg" alt="Customer Cards" width="300"/>

**Add Customer:** Add new customer with two steps: personal details + membership details.  
<img src="/assets/screenshots/add_customer_details.jpg" alt="Add Customer" width="300"/>

<img src="/assets/screenshots/add_customer_membership.jpg" alt="Add Customer" width="300"/>

**Customer Details:** Tap a customer to see profile, past and current memberships.  
<img src="/assets/screenshots/customer_details.jpg" alt="Customer Details" width="300"/>

**Message Button:** Visible when a membership is expired — send reminders via WhatsApp/SMS.  
<img src="/assets/screenshots/message_button.jpg" alt="Message Button" width="300"/>

---

## 📃 License

This project is licensed under the [MIT License](LICENSE).

---
