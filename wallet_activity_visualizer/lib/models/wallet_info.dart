import 'token_balance.dart';
import 'transfer.dart';

class WalletInfo {
  final String address;
  final double ethBalance;
  final List<TokenBalance> tokens;
  final List<Transfer> transfers;
  final DateTime fetchedAt;

  const WalletInfo({
    required this.address,
    required this.ethBalance,
    required this.tokens,
    required this.transfers,
    required this.fetchedAt,
  });

  double get totalUsdValue {
    double total = 0;
    for (final t in tokens) {
      total += t.usdValue;
    }
    return total;
  }

  int get tokenCount => tokens.where((t) => t.balance > 0).length;

  Map<String, int> get txFrequencyByDay {
    final map = <String, int>{};
    for (final tx in transfers) {
      if (tx.timestamp != null) {
        final key =
            '${tx.timestamp!.year}-${tx.timestamp!.month.toString().padLeft(2, '0')}-${tx.timestamp!.day.toString().padLeft(2, '0')}';
        map[key] = (map[key] ?? 0) + 1;
      }
    }
    return map;
  }

  Map<String, double> get tokenDistribution {
    final map = <String, double>{};
    for (final t in tokens) {
      if (t.balance > 0) {
        map[t.symbol] = t.usdValue > 0 ? t.usdValue : t.balance;
      }
    }
    return map;
  }
}
