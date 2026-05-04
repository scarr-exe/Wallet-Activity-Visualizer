import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/transfer.dart';
import '../models/token_balance.dart';
import '../models/wallet_info.dart';

class WalletService {
  static String get _rpcUrl =>
      dotenv.env['ALCHEMY_RPC_URL'] ??
      'https://eth-mainnet.g.alchemy.com/v2/3-8Zi3zIA7HZWI881n3CL';

  static const _headers = {'Content-Type': 'application/json'};

  Future<Map<String, dynamic>> _post(Map<String, dynamic> body) async {
    final response = await http
        .post(
          Uri.parse(_rpcUrl),
          headers: _headers,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data.containsKey('error')) {
      throw Exception(data['error']['message'] ?? 'RPC error');
    }
    return data;
  }

  Future<double> getEthBalance(String address) async {
    final data = await _post({
      'jsonrpc': '2.0',
      'id': 1,
      'method': 'eth_getBalance',
      'params': [address, 'latest'],
    });
    final hex = data['result'] as String;
    final wei = BigInt.parse(hex.substring(2), radix: 16);
    return (wei.toDouble() / 1e18);
  }

  Future<List<Transfer>> getTransfers(String address) async {
    final sent = await _post({
      'jsonrpc': '2.0',
      'id': 2,
      'method': 'alchemy_getAssetTransfers',
      'params': [
        {
          'fromAddress': address,
          'category': ['external', 'erc20', 'erc721', 'erc1155'],
          'withMetadata': true,
          'maxCount': '0x19',
          'order': 'desc',
        }
      ],
    });

    final received = await _post({
      'jsonrpc': '2.0',
      'id': 3,
      'method': 'alchemy_getAssetTransfers',
      'params': [
        {
          'toAddress': address,
          'category': ['external', 'erc20', 'erc721', 'erc1155'],
          'withMetadata': true,
          'maxCount': '0x19',
          'order': 'desc',
        }
      ],
    });

    final sentList = ((sent['result']?['transfers'] as List?) ?? [])
        .map((e) => Transfer.fromJson(e as Map<String, dynamic>))
        .toList();

    final receivedList = ((received['result']?['transfers'] as List?) ?? [])
        .map((e) => Transfer.fromJson(e as Map<String, dynamic>))
        .toList();

    final all = [...sentList, ...receivedList];
    final seen = <String>{};
    final unique = all.where((t) => seen.add(t.hash)).toList();
    unique.sort((a, b) {
      if (a.timestamp == null && b.timestamp == null) return 0;
      if (a.timestamp == null) return 1;
      if (b.timestamp == null) return -1;
      return b.timestamp!.compareTo(a.timestamp!);
    });
    return unique;
  }

  Future<List<TokenBalance>> getTokenBalances(String address) async {
    final data = await _post({
      'jsonrpc': '2.0',
      'id': 4,
      'method': 'alchemy_getTokenBalances',
      'params': [address],
    });

    final balances = (data['result']?['tokenBalances'] as List?) ?? [];
    final nonZero = balances
        .cast<Map<String, dynamic>>()
        .where((b) => b['tokenBalance'] != null && b['tokenBalance'] != '0x0')
        .toList();

    if (nonZero.isEmpty) return [];

    final metaBatch = await Future.wait(
      nonZero.take(20).map((b) => _getTokenMetadata(b['contractAddress'] as String)),
    );

    final result = <TokenBalance>[];
    for (var i = 0; i < nonZero.length && i < metaBatch.length; i++) {
      final meta = metaBatch[i];
      if (meta != null) {
        result.add(TokenBalance.fromJson({
          ...nonZero[i],
          ...meta,
        }));
      }
    }
    result.sort((a, b) => b.balance.compareTo(a.balance));
    return result;
  }

  Future<Map<String, dynamic>?> _getTokenMetadata(String contractAddress) async {
    try {
      final data = await _post({
        'jsonrpc': '2.0',
        'id': 5,
        'method': 'alchemy_getTokenMetadata',
        'params': [contractAddress],
      });
      return data['result'] as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  Future<WalletInfo> getWalletInfo(String address) async {
    final addr = address.trim().toLowerCase();

    final results = await Future.wait([
      getEthBalance(addr),
      getTransfers(addr),
      getTokenBalances(addr),
    ]);

    return WalletInfo(
      address: address.trim(),
      ethBalance: results[0] as double,
      transfers: results[1] as List<Transfer>,
      tokens: results[2] as List<TokenBalance>,
      fetchedAt: DateTime.now(),
    );
  }

  static bool isValidAddress(String address) {
    final trimmed = address.trim();
    if (!trimmed.startsWith('0x')) return false;
    if (trimmed.length != 42) return false;
    final hex = trimmed.substring(2);
    return RegExp(r'^[0-9a-fA-F]+$').hasMatch(hex);
  }
}
