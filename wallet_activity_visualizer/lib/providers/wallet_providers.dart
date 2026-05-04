import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/wallet_info.dart';
import '../services/wallet_service.dart';

final walletServiceProvider = Provider<WalletService>((ref) => WalletService());

final walletAddressProvider = StateProvider<String>((ref) => '');

final walletInfoProvider = FutureProvider<WalletInfo?>((ref) async {
  final address = ref.watch(walletAddressProvider);
  if (address.isEmpty) return null;
  if (!WalletService.isValidAddress(address)) {
    throw Exception('Invalid Ethereum address');
  }
  final service = ref.read(walletServiceProvider);
  return service.getWalletInfo(address);
});

final txFilterProvider = StateProvider<String>((ref) => 'all');

final filteredTransfersProvider = Provider((ref) {
  final walletAsync = ref.watch(walletInfoProvider);
  final filter = ref.watch(txFilterProvider);
  final address = ref.watch(walletAddressProvider).toLowerCase();

  return walletAsync.whenData((info) {
    if (info == null) return [];
    final txs = info.transfers;
    switch (filter) {
      case 'received':
        return txs.where((t) => t.to.toLowerCase() == address).toList();
      case 'sent':
        return txs.where((t) => t.from.toLowerCase() == address).toList();
      case 'tokens':
        return txs.where((t) => t.category != 'external').toList();
      default:
        return txs;
    }
  });
});
