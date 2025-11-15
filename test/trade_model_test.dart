import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:trade_tracker/models/trade.dart';
import 'package:trade_tracker/hive_adapters.dart';

import 'test_hive_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Box<Trade> tradesBox;

  setUpAll(() async {
    await initTestHive();
    registerHiveAdapters();
    tradesBox = await openTestBox<Trade>('trades');
  });

  tearDownAll(() async {
    await disposeTestHive();
  });

  test('Trade can be stored and retrieved', () async {
    final trade = Trade(
      id: 'T1',
      ticker: 'AAPL',
      shares: 10,
      price: 150.0,
      tradeDate: DateTime(2025, 11, 14),
    );

    await tradesBox.put(trade.id, trade);
    final retrieved = tradesBox.get(trade.id);

    expect(retrieved?.ticker, 'AAPL');
    expect(retrieved?.shares, 10);
    expect(retrieved?.price, 150.0);
  });
}
