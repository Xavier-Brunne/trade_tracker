Got it, Darren — here’s a full **CONTRIBUTING.md draft** wrapped in a neat copy‑ready block with a copy button. You can paste this directly into your repo:

```markdown
# 🤝 Contributing to Trade Tracker

We’re excited that you want to contribute to **Trade Tracker**!  
This guide will help you set up your environment, run tests, and submit changes smoothly.

---

## 📦 Project Setup

1. **Clone the repo**
   ```bash
   git clone https://github.com/Xavier-Brunne/trade_tracker.git
   cd trade_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run -d windows
   ```

---

## 🧪 Running Tests

We use **Flutter’s test framework** with **mock-safe Hive overrides**.

- Run all tests:
  ```bash
  flutter test
  ```

- Run a specific test by name:
  ```bash
  flutter test test/widget_test.dart --plain-name "Tapping SEC card navigates to SEC screen"
  ```

---

## 🛠️ Development Workflow

- **Linting**: Custom rules are defined in `analysis_options.yaml`.  
- **Hive IDs**: Explicit type IDs enforced via `build.yaml`.  
- **Cleanup**: If tests or builds misbehave, run:
  ```powershell
  Remove-Item -Recurse -Force .dart_tool, build
  flutter clean
  flutter pub get
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

---

## 🔄 Pull Request Process

1. Fork the repository and create your branch:
   ```bash
   git checkout -b feature/amazing-feature
   ```

2. Commit your changes with clear messages:
   ```bash
   git commit -m "feat: add SEC filing card widget"
   ```

3. Push to your fork and open a Pull Request.

---

## ⚙️ Continuous Integration

Every PR runs:
- `flutter analyze`
- `flutter test`
- `flutter pub run build_runner build`

This ensures code quality and prevents regressions.

---

## 🎨 Collaboration Signals

We use playful cues to keep teamwork fun:
- ✅ Green check: tests passing
- ❌ Red cross: failing tests
- 🧪 Flask: experimental feature
- 🚧 Barrier: work in progress

---

## 📬 Communication

- Open an issue for bugs or feature requests.
- Use discussions for ideas and roadmap input.
- PRs are welcome — small or large!

---

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.
```

✅ Strengths
Structure & Flow: Clear sections (setup, tests, workflow, PR process, CI, signals, communication, license) make it easy to scan.

Consistency with README: Mirrors the style and tone of your README — badges, emojis, playful cues — so contributors feel continuity.

Practical Commands: Includes exact flutter and PowerShell commands for setup, cleanup, and test runs. This removes ambiguity for new contributors.

Collaboration Signals: The emoji legend is a nice touch — it keeps the repo approachable and fun.

CI Section: Even though you haven’t added the workflow file yet, the section sets expectations clearly.

🔧 Suggested Refinements
Copy Block Removal: Right now the file starts with “Got it, Darren — here’s a full draft…” and wraps the content in triple backticks. That’s meta‑text from our chat. For the actual repo file, strip that so it begins directly with:

markdown
# 🤝 Contributing to Trade Tracker
Link Back to README: Add a short note at the top or bottom:

markdown
See [README.md](README.md) for project overview and roadmap.
That ties the two docs together.

CI Workflow Reference: Since you mention CI, you could add:

markdown
See `.github/workflows/ci.yml` for the full configuration.