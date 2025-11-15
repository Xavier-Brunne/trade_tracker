🧪 Test Suite Guide
This project’s test suite is fully harmonised around Hive test helpers to keep setup consistent and eliminate duplicate boilerplate.

🔑 Conventions
Helpers: All tests use test_hive_utils.dart for Hive lifecycle.

initTestHive() → initialise Hive in memory

registerAdapterSafely() → register adapters only if not already registered

openTestBox<T>() → open a box safely

disposeTestHive() → close and clean up Hive after tests

Lifecycle:

setUpAll() → initialise Hive, register adapters, open boxes

tearDownAll() → dispose Hive

setUp() → clear boxes before each test

Imports:

✅ Test files import test_hive_utils.dart

❌ Production code (/lib/) never imports test helpers — it uses direct Hive API

📂 File Patterns
*_test.dart files live under /test/

Each test file follows the same structure:

TestWidgetsFlutterBinding.ensureInitialized()

Hive setup via helpers

Grouped tests with clear names

📋 Examples
Smoke Test
dart
testWidgets('App launches and shows Dashboard', (tester) async {
  await tester.pumpWidget(MaterialApp(home: DashboardScreen(hiveService: hiveService)));
  expect(find.text('Dashboard'), findsOneWidget);
});
Service Test
dart
test('CIK lookup resolves Microsoft ticker', () async {
  final cikService = CikLookupService();
  final cik = await cikService.getCikForTicker('MSFT');
  expect(cik, equals('0000789019'));
});
✅ Best Practices
Keep tests lean — helpers handle boilerplate.

Use clear group names (App smoke test, CIKLookupService, SecSplashScreen integration).

Seed boxes with minimal data for widget tests.

Run flutter analyze regularly — suite should stay lint‑clean.

🧪 Test Suite Guide
This project’s test suite is harmonised around Hive test helpers to keep setup consistent and eliminate duplicate boilerplate.

🔑 Conventions
Helpers: All tests use test_hive_utils.dart for Hive lifecycle.

initTestHive() → initialise Hive in memory

registerAdapterSafely() → register adapters only if not already registered

openTestBox<T>() → open a box safely

disposeTestHive() → close and clean up Hive after tests

Lifecycle:

setUpAll() → initialise Hive, register adapters, open boxes

tearDownAll() → dispose Hive

setUp() → clear boxes before each test

Imports:

✅ Test files import test_hive_utils.dart

❌ Production code (/lib/) never imports test helpers — it uses direct Hive API

📂 File Patterns
*_test.dart files live under /test/

Each test file follows the same structure:

TestWidgetsFlutterBinding.ensureInitialized()

Hive setup via helpers

Grouped tests with clear names

📋 Examples
Smoke Test
dart
testWidgets('App launches and shows Dashboard', (tester) async {
  await tester.pumpWidget(MaterialApp(home: DashboardScreen(hiveService: hiveService)));
  expect(find.text('Dashboard'), findsOneWidget);
});
Service Test
dart
test('CIK lookup resolves Microsoft ticker', () async {
  final cikService = CikLookupService();
  final cik = await cikService.getCikForTicker('MSFT');
  expect(cik, equals('0000789019'));
});
🛠 Adding New Tests
When creating a new test file:

Create the file under /test/ with a descriptive name, e.g. my_feature_test.dart.

Import the helpers:

dart
import 'test_hive_utils.dart';
Set up Hive lifecycle:

dart
setUpAll(() async {
  await initTestHive();
  registerAdapterSafely(MyAdapter());
  await openTestBox<MyModel>('myBox');
});

tearDownAll(() async {
  await disposeTestHive();
});
Write your tests inside group() blocks:

dart
group('MyFeature', () {
  setUp(() async {
    await Hive.box<MyModel>('myBox').clear();
  });

  test('does something useful', () async {
    final box = Hive.box<MyModel>('myBox');
    await box.put('id1', MyModel(...));
    expect(box.values.length, 1);
  });
});
Keep tests lean — rely on helpers for setup, only write unique logic.

✅ Best Practices
Use clear group names (App smoke test, CIKLookupService, SecSplashScreen integration).

Seed boxes with minimal data for widget tests.

Run flutter analyze regularly — suite should stay lint‑clean.

Don’t duplicate Hive setup — always use helpers.

Here’s a concise, one‑page **README scaffold for your test suite**. It explains the Hive box setup, adapter registration rules, and the workflow so collaborators can get productive quickly.

---

# 🧪 Trade Tracker Test Suite Guide

This document explains how our Hive‑based test environment is set up and how to register adapters/boxes correctly. It’s designed to eliminate confusion and prevent common errors like *“Box not found”* or *“TypeAdapter already registered”*.

---

## 📦 Hive Box Setup

We use Hive boxes to persist model data during tests. Each box name is consistent across app and test code:

| Box Name     | Model/Class       | TypeId |
|--------------|------------------|--------|
| `people`     | `Person`         | 0 |
| `secFilings` | `SecFiling`      | 1 |
| `settings`   | `Settings`       | 2 |
| `cikCache`   | `CikCacheEntry`  | 3 |
| `trades`     | `Trade`          | 4 |
| `portfolios` | `Portfolio`      | 5 |
| `userPrefs`  | `UserPrefs`      | 6 |

---

## 🛠 Adapter Registration

All adapters are registered centrally in **`lib/hive_adapters.dart`**:

```dart
void registerHiveAdapters() {
  Hive.registerAdapter(PersonAdapter());        // typeId 0
  Hive.registerAdapter(SecFilingAdapter());     // typeId 1
  Hive.registerAdapter(SettingsAdapter());      // typeId 2
  Hive.registerAdapter(CikCacheEntryAdapter()); // typeId 3
  Hive.registerAdapter(TradeAdapter());         // typeId 4
  Hive.registerAdapter(PortfolioAdapter());     // typeId 5
  Hive.registerAdapter(UserPrefsAdapter());     // typeId 6
}
```

👉 **Rule:** Every model must have a unique `@HiveType(typeId: X)` annotation. Never reuse IDs.

---

## 🧩 Test Workflow

1. **Initialise Hive test environment**  
   ```dart
   await initTestHive();
   registerHiveAdapters();
   ```

2. **Open required boxes**  
   ```dart
   await openTestBox<Person>('people');
   await openTestBox<SecFiling>('secFilings');
   await openTestBox<Settings>('settings');
   await openTestBox<CikCacheEntry>('cikCache');
   await openTestBox<Trade>('trades');
   await openTestBox<Portfolio>('portfolios');
   await openTestBox<UserPrefs>('userPrefs');
   ```

3. **Clean up after tests**  
   ```dart
   await disposeTestHive();
   ```

---

## 🚨 Common Pitfalls

- **Duplicate typeIds** → causes `HiveError: TypeAdapter already registered`. Fix by assigning unique IDs.
- **Box not opened** → causes `HiveError: Box not found`. Always open boxes in `setUpAll`.
- **Forgetting adapter registration** → causes serialization errors. Always call `registerHiveAdapters()` before opening boxes.

---

## ✅ Quick Checklist for New Models

- Add `@HiveType(typeId: X)` with a unique ID.
- Add `part 'model_name.g.dart';`.
- Run:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- Register adapter in `hive_adapters.dart`.
- Open the box in tests with `openTestBox<Model>('boxName');`.

---

👉 With this README, collaborators can onboard quickly, avoid schema errors, and keep the test suite consistent.  

Would you like me to also scaffold a **developer onboarding checklist** (step‑by‑step commands and gotchas) so new contributors can set up Hive locally without hitting common traps?