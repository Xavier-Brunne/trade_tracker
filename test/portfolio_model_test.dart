import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/models/portfolio.dart';
import 'package:trade_tracker/hive_adapters.dart';

import 'test_hive_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Box<Portfolio> portfoliosBox;

  setUpAll(() async {
    await initTestHive();
    registerHiveAdapters();
    portfoliosBox = await openTestBox<Portfolio>('portfolios');
  });

  tearDownAll(() async {
    await disposeTestHive();
  });

  test('Portfolio can be stored and retrieved', () async {
    final portfolio = Portfolio(
      id: 'P1',
      name: 'Tech Holdings',
      tradeIds: ['T1', 'T2'],
    );

    await portfoliosBox.put(portfolio.id, portfolio);
    final retrieved = portfoliosBox.get(portfolio.id);

    expect(retrieved?.name, 'Tech Holdings');
    expect(retrieved?.tradeIds.length, 2);
    expect(retrieved?.tradeIds.contains('T1'), true);
  });
}
