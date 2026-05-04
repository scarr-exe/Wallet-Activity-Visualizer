class Transfer {
  final String hash;
  final String from;
  final String to;
  final String? asset;
  final double? value;
  final String? tokenId;
  final String category;
  final String blockNum;
  final DateTime? timestamp;

  const Transfer({
    required this.hash,
    required this.from,
    required this.to,
    this.asset,
    this.value,
    this.tokenId,
    required this.category,
    required this.blockNum,
    this.timestamp,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      hash: json['hash'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      asset: json['asset'],
      value: json['value'] != null
          ? (json['value'] is String
              ? double.tryParse(json['value'])
              : (json['value'] as num).toDouble())
          : null,
      tokenId: json['tokenId'],
      category: json['category'] ?? 'external',
      blockNum: json['blockNum'] ?? '',
      timestamp: json['metadata']?['blockTimestamp'] != null
          ? DateTime.tryParse(json['metadata']['blockTimestamp'])
          : null,
    );
  }

  bool get isIncoming => to.toLowerCase() != from.toLowerCase();

  String get shortHash =>
      hash.length > 12 ? '${hash.substring(0, 6)}...${hash.substring(hash.length - 4)}' : hash;

  String get shortFrom =>
      from.length > 10 ? '${from.substring(0, 6)}...${from.substring(from.length - 4)}' : from;

  String get shortTo =>
      to.length > 10 ? '${to.substring(0, 6)}...${to.substring(to.length - 4)}' : to;

  String get displayValue {
    if (value == null) return '—';
    if (value! < 0.0001) return '< 0.0001';
    return value!.toStringAsFixed(4);
  }
}
