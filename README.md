
# 📊 Trade Tracker

[![Flutter](https://img.shields.io/badge/Flutter-3.4.4-blue?logo=flutter)](https://flutter.dev)
[![Hive](https://img.shields.io/badge/Hive-2.2.3-yellow?logo=hive)](https://pub.dev/packages/hive)
[![Build Runner](https://img.shields.io/badge/build_runner-enabled-green)](https://pub.dev/packages/build_runner)
[![Test Coverage](https://img.shields.io/badge/tests-passing-brightgreen)](#)

A fresh scaffold with Hive and build_runner — **Trade Tracker** helps users monitor insider trading activity, track personal investments, and stay informed about market movements — all in one place.

---

## 🚀 Project Overview

Trade Tracker fetches SEC Form 4 filings daily, highlights high-interest trades, and allows users to track their own investments with customizable alerts. It combines real-time data, offline storage, and smart automation to deliver a powerful insider trading companion.

---

## 🛠️ Installation

```bash
git clone https://github.com/Xavier-Brunne/trade_tracker.git
cd trade_tracker
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d windows
```

🧪 Running Tests
```bash
flutter test
```

Includes widget tests and mock-safe Hive overrides.

---

## 🧰 Tech Stack
- **Frontend**: Flutter  
- **Local Storage**: Hive  
- **APIs**: SEC.gov (RSS + JSON), Yahoo Finance, CoinGecko  
- **Notifications**: flutter_local_notifications  
- **Backup**: File I/O and ZIP utilities  

---

## 📰 SEC Form 4 Integration
We use the official SEC RSS feed to fetch the latest Form 4 filings:

- Source: SEC Form 4 RSS Feed  
- JSON API (`https://data.sec.gov/submissions/CIK##########.json`) also supported  
- RSS chosen for reliability, no auth, and real-time access  

---

## 📋 Feature List
### 🔍 Core Functionality
- Fetch daily insider trading filings from sec.gov  
- Filter by date (default: today)  
- Display results in a readable list  
- Color-coded priority:  
  - 🟨 Normal filings  
  - 🟩 High-interest (large trades or executive roles)  
- Clickable links to view more details  

### 📦 Offline Storage & Backup
- Local storage using Hive  
- Export data to `.zip`  
- Import from backup `.zip`  

### 📱 User Interface
- Dashboard home screen  
- “Fetch Today’s Filings” button  
- List of recent filings  
- Saved filings section  
- Search history by date  
- Live chart screen (planned)  
- “Additional Info” button for news  

### 📈 Watchlist & Alerts
- Add stocks/crypto to personal watchlist  
- Set custom low/high price thresholds  
- Monitor live prices via API  
- Push notifications when thresholds are crossed  

### 🔔 Notifications
- Daily filing reminders  
- Price alerts  
- Modes: text only or text + sound  

### 🤖 Smart Automation
- AI-powered filing prioritization  
- Auto-watchlist suggestions  
- Scheduled background fetching  
- Auto-backup (weekly/monthly)  
- Sentiment analysis  
- Price trend prediction  
- Insider pattern detection  

---

## 🧠 Strategic Use of SEC Filing Data
- Recent Filings Feed: Scrollable list, color-coded priority  
- Watchlist Suggestions: Based on high-interest trades  
- Insider Pattern Detection: Clusters of executive trades  
- Offline Archive & Search: Browse historical filings, export/import  
- Sentiment & News Integration: Enrich filings with external context  

---

## 🛣️ Vision & Roadmap
- ✅ Phase 1: Core MVP  
- 🚧 Phase 2: Watchlist & Charts  
- 🔮 Phase 3: Smart Automation  

---

## 🎨 UI/UX Design Goals
- Minimalist dashboard layout  
- Clear visual hierarchy  
- Responsive design  
- Color-coded indicators  
- Smooth navigation  

---

## 🔁 User Flow Overview
```
App Launch
↓
Dashboard Home Screen
↓
Tap “Fetch Latest Filings”
↓
View SEC Form 4 list
↓
Tap Filing Entry → Filing Details
↓
Navigate to Holdings → Charts & Watchlist
↓
Monitor prices and receive alerts
```

---

## 📦 Project Structure
```
lib/
├── services/
│   ├── hive_service.dart             # Hive utility functions
│   ├── mock_filing_generator.dart    # Generates mock filings for testing
│   ├── sec_form4_rss_service.dart    # Fetches and parses SEC RSS feed
│   └── sec_form4_json_service.dart   # Fetches SEC JSON filings
├── screens/
│   ├── dashboard_screen.dart         # Dashboard with recent & saved filings
│   ├── sec_form4_screen.dart         # UI for displaying Form 4 filings
│   └── filing_detail_screen.dart     # Filing detail view with save toggle
├── models/
│   └── sec_filing.dart               # Filing model with Hive annotations
├── person.dart                       # Hive model for Person
└── main.dart                         # Entry point with Hive init + dashboard
```

---

## 🤝 Contributing
We welcome contributions! Please fork the repo and submit a pull request.  
For major changes, open an issue first to discuss what you'd like to change.  

👉 See [CONTRIBUTING.md](CONTRIBUTING.md) for full setup instructions, workflow, and CI details.

---

## 📄 License
This project is licensed under the MIT License. See the LICENSE file for details.

---

## 📬 Contact
For questions, suggestions, or feedback, feel free to open an issue or reach out via GitHub.
```

---

### 🔑 What Changed
- Added **Saved Filings section** to match your new UI.  
- Updated **Project Structure** to include `hive_service.dart` and `mock_filing_generator.dart`.  
- Linked **CONTRIBUTING.md** in the Contributing section.  
- Kept badges and polished formatting consistent.

---

This version is drop‑in ready. Would you like me to also scaffold a **CONTRIBUTING.md** file so new collaborators know exactly how to set up Hive, run build_runner, and follow your workflow?