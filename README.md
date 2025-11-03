
# 📊 TradeTracker

TradeTracker is a Flutter mobile app designed to help users monitor insider trading activity, track personal investments, and stay informed about market movements — all in one place.

---

## 🚀 Project Overview

TradeTracker fetches SEC Form 4 filings daily, highlights high-interest trades, and allows users to track their own investments with customizable alerts. It combines real-time data, offline storage, and smart automation to deliver a powerful insider trading companion.

---

## 🏠 Dashboard Home Screen

The app opens to a dashboard-style home screen with quick access to key features:

- 📊 **Your Current Holdings**: Displays a summary of tracked assets (planned feature).
- 📰 **Latest SEC Filings**: Fetches recent Form 4 insider trading filings from the SEC RSS feed.
- 📈 **Charts and Trends**: Visualizes holdings and market data (planned feature).

---

## 🔌 SEC Form 4 Integration
We use the official SEC RSS feed to fetch the latest Form 4 filings:

- Source: [SEC Form 4 RSS Feed](https://www.sec.gov/)
- Parsed using Dart's `http` and `xml` packages
- Displayed in a scrollable list with filing titles and timestamps

### 🔄 Why RSS Feed?

Originally, the app used the SEC EDGAR JSON API (`https://data.sec.gov/submissions/CIK##########.json`) to fetch filings by CIK. However, due to network restrictions and reliability issues, we switched to the SEC's public RSS feed, which:

- Requires no authentication
- Works reliably across all platforms
- Provides real-time access to Form 4 filings

---

## 📋 Feature List

### 🔍 Core Functionality
- Fetch daily insider trading filings from sec.gov
- Filter by date (default: today)
- Display results in a readable list
- Color-coded priority:
  - 🟨 Yellow: Normal filings
  - 🟩 Green: High-interest (large trades or executive roles)
- Clickable links to view more details
### 📦 Offline Storage & Backup
- Local storage using Hive
- Export data to `.zip` file
- Import from backup `.zip`

### 📱 User Interface
- Home screen with “Fetch Today’s Filings” button
- List of recent filings
- Search history by date
- Live chart screen for selected stock/crypto
- “Additional Info” button to fetch news articles about the company

### 📈 Watchlist & Alerts
- Add stocks/crypto to personal watchlist
- Set custom low/high price thresholds
- Monitor live prices via API
- Push notifications when thresholds are crossed
- Watchlist screen with current status and quick actions
### 🔔 Notifications
- Daily reminder to check filings
- Price alerts for watchlist items
- Notification modes:
  - Text only
  - Text + sound

### 📤 APK Management
- Build debug and release APKs
- Sideload via ADB
- Share APKs privately (e.g., Google Drive, Signal)

### 🤖 Smart Automation & Intelligence Features
- **AI-Powered Filing Prioritization**: Score filings based on keywords, roles, and trade amounts
- **Auto-Watchlist Suggestions**: Suggest adding stocks based on high-interest filings
- **Scheduled Background Fetching**: Automatically fetch filings and check watchlist prices daily
- **Auto-Backup**: Weekly/monthly backup to local or cloud storage
- **Sentiment Analysis**: Analyze tone of news articles (Positive, Neutral, Negative)
- **Price Trend Prediction**: Show upward/downward trends using regression or moving averages
- **Insider Pattern Detection**: Alert on unusual insider activity (e.g., multiple executives buying)

---

## 🧰 Tech Stack

- **Frontend**: Flutter
- **Local Storage**: Hive
- **APIs**:
  - SEC.gov for Form 4 filings
  - Yahoo Finance / Alpha Vantage / CoinGecko for live prices
  - News API or web scraping for articles
- **Notifications**: Flutter Local Notifications
- **Backup**: File I/O and ZIP utilities

---

## 🖼️ UI Mockups (Placeholder)

Screenshots and design mockups will be added here as development progresses.

---

## 🛣️ Vision & Roadmap

### ✅ Phase 1: Core MVP
- Fetch and display SEC filings
- Local storage and backup
- Basic UI and notifications

### 🚧 Phase 2: Watchlist & Charts
- Add personal investments
- Live charts and news integration
- Price alerts and push notifications

### 🔮 Phase 3: Smart Automation
- AI-powered prioritization
- Auto-watchlist suggestions
- Sentiment analysis and trend prediction
---

## 🎨 UI/UX Design Goals

TradeTracker is designed with simplicity and clarity in mind. Our goals include:

- Minimalist dashboard layout for quick access to key features
- Clear visual hierarchy to guide user attention
- Responsive design for mobile devices
- Color-coded indicators for filing priority and alerts
- Smooth navigation between screens with consistent styling

---

## 🔁 User Flow Overview

1. **App Launch** → Dashboard Home Screen  
2. **Tap “Fetch Latest Filings”** → View SEC Form 4 list  
3. **Tap Filing Entry** → Open filing details (planned)  
4. **Navigate to Holdings** → View tracked assets and charts  
5. **Access Watchlist** → Monitor prices and receive alerts  

---

## 🖼️ Dashboard Screenshot or Wireframe

*Placeholder for future screenshot or wireframe of the dashboard layout.*

---

## 📦 Project Structure


ib/
├── services/
│   └── sec_form4_rss_service.dart   # Fetches and parses SEC RSS feed
├── screens/
│   └── sec_form4_screen.dart        # UI for displaying Form 4 filings
└── main.dart                        # Entry point with dashboard layout

---
