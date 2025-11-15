import 'package:hive/hive.dart';

part 'trade.g.dart';

@HiveType(typeId: 4) // ✅ unique typeId
class Trade {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String ticker;

  @HiveField(2)
  final int shares;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final DateTime tradeDate;

  Trade({
    required this.id,
    required this.ticker,
    required this.shares,
    required this.price,
    required this.tradeDate,
  });
}
