class TokenBalance {
  final String contractAddress;
  final String name;
  final String symbol;
  final double balance;
  final int decimals;
  final String? logo;
  final double? usdPrice;

  const TokenBalance({
    required this.contractAddress,
    required this.name,
    required this.symbol,
    required this.balance,
    required this.decimals,
    this.logo,
    this.usdPrice,
  });

  factory TokenBalance.fromJson(Map<String, dynamic> json) {
    final rawBalance = json['tokenBalance'] as String? ?? '0x0';
    final decimals = json['decimals'] as int? ?? 18;
    final balanceInt = BigInt.tryParse(
          rawBalance.startsWith('0x') ? rawBalance.substring(2) : rawBalance,
          radix: 16,
        ) ??
        BigInt.zero;
    final balance = balanceInt / BigInt.from(10).pow(decimals);

    return TokenBalance(
      contractAddress: json['contractAddress'] ?? '',
      name: json['name'] ?? 'Unknown',
      symbol: json['symbol'] ?? '???',
      balance: balance.toDouble(),
      decimals: decimals,
      logo: json['logo'],
      usdPrice: json['usdPrice'] != null
          ? (json['usdPrice'] as num).toDouble()
          : null,
    );
  }

  double get usdValue => usdPrice != null ? balance * usdPrice! : 0;

  String get displayBalance {
    if (balance < 0.0001) return '< 0.0001';
    return balance.toStringAsFixed(4);
  }
}
