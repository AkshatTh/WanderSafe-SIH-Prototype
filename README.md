# 🌍WanderSafe - Smart Tourist Safety Monitoring System🌍  
*A Submission for the Smart India Hackathon 2025 by Team MeowMeow*  

---

## 📌 Project Overview  

| Attribute         | Details                                                                 |
|-------------------|-------------------------------------------------------------------------|
| **Team Name**     | Team MeowMeow                                                           |
| **Problem Statement** | SIH25002 - Smart Tourist Safety Monitoring & Incident Response System |
| **Theme**         | Travel & Tourism                                                        |

---

## 🚀 Project Vision  

**WanderSafe** is an **AI-powered, decentralized ecosystem** designed to revolutionize tourist safety.  
Our platform shifts the paradigm from **reactive incident reporting** to **proactive, real-time safety monitoring**.  

By integrating:  
- ⚡ **AI Safety Engine**  
- 🔐 **Blockchain-based Digital Identity**  
- 📍 **Geo-fencing Technology**  

WanderSafe provides tourists with:  
✅ A **dynamic safety score** for their surroundings  
✅ **Instant access to help** when needed  
✅ A **seamless connection to authorities**  

This repository contains the **high-fidelity, interactive Flutter mobile application prototype**, which demonstrates the complete user-facing experience of the WanderSafe ecosystem.  

---

## ✨ Features Implemented in This Prototype  

This prototype is a **fully interactive simulation** of the WanderSafe mobile app. Every screen is functional, with mock data and live API calls to demonstrate the full user journey.  

### ✅ Core Onboarding & Identity  
- **Personalized User Registration**: Three-step onboarding to create a Digital ID.  
- **Dynamic Username**: Captured during sign-up and used throughout the app.  
- **Mandatory Emergency Contact**: At least one required, integrated into safety features.  
- **Optional Trip Itinerary**: Privacy-respecting, clearly marked as optional.  

### ✅ Main Dashboard  
- **Cohesive UI** with professional branding.  
- **Dynamic 3D Safety Score**: Animated gauge that transitions from 🔴 (unsafe) → 🟢 (safe).  
- **Interactive Panic Button**: “Press-and-hold” SOS (3-second hold) to avoid false alarms.  

### ✅ Live Map & Navigation  
- **Real-time GPS Tracking**: User location shown with correctly scaling circle.  
- **Dynamic POIs**: Mock safe zones, unsafe areas, tourist spots, and community alerts.  
- **Functional Filters & Search**:  
  - Filter chips (Food, Hotels, etc.) refresh results dynamically.  
  - Search bar integrates with **native Google Maps app** via `url_launcher`.  

### ✅ AI-Powered Assistance  
- **Live AI Companion**: Connected to **Google Gemini API** with Search Grounding.  
- **Context-Aware Responses** about travel, safety, and local spots in Hyderabad.  
- **Personalized Greetings** using the user’s actual name.  

### ✅ Incident Reporting & Utilities  
- **Pre-filled E-FIR**: Auto-populates with name, emergency contacts, and timestamp.  
- **Crypto Gateway Simulation**:  
  - Real-time INR conversion.  
  - Mock balance updates.  

---

## 🛠 Tech Stack  

| Category    | Technology / Package |
|-------------|-----------------------|
| **Framework** | Flutter |
| **Language**  | Dart |
| **Mapping**   | `maps_flutter`, `location` |
| **AI**        | Google Gemini API (`gemini-2.5-flash-preview-05-20`) with Search Grounding |
| **Networking**| `http`, `url_launcher` |

---

## ⚡ How to Run This Prototype  

### Step 1: Clone the Repository  

```bash
git clone https://github.com/YourUsername/WanderSafe-SIH-Prototype.git
cd WanderSafe-SIH-Prototype
```

### Step 2: Add API Keys  

This project needs **two API keys** from Google Cloud Platform:  

#### 🔑 Google Maps API Key  
1. Open `android/app/src/main/AndroidManifest.xml`  
2. Find:  
   ```xml
   android:value="YOUR_API_KEY_HERE"

   Replace with your Google Maps API Key.
   ```
3. Ensure the key is authorized for both debug and release SHA-1 fingerprints in the Google Cloud Console.

🔑 Google Gemini API Key

Navigate to: `lib/core/services/`

Copy the file `api_keys.dart.example` → rename it to `api_keys.dart`.

Open `api_keys.dart` and paste your Gemini API Key in place of the placeholder.

Step 3: Install Dependencies

Run the following command to fetch all the required Flutter packages:

```flutter pub get```

Step 4: Run the App

Before running the app, clean and rebuild the project:
```
flutter clean
flutter pub get
flutter run
```

If you have multiple devices or emulators connected, specify a target device explicitly:
```
flutter run -d <device_id>
```
🎉 You’re All Set!

After completing these steps, the WanderSafe prototype app will launch on your connected Android/iOS device or emulator.

💡 WanderSafe empowers tourists with proactive safety monitoring, real-time assistance, and seamless reporting — making travel safer, smarter, and stress-free. 🌍
