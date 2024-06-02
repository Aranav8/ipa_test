import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ridobiko/core/Constants.dart';

import 'package:ridobiko/data/security_deposit_data.dart';

class SecurityDeposit {
  int balance = 0;
  int refundableAmount = 0;
  String accountName = '';
  String accountNumber = '';
  String ifsc = '';
  List<SecurityDepositData> transactions = [];
  SecurityDeposit({
    required this.balance,
    required this.refundableAmount,
    required this.accountName,
    required this.accountNumber,
    required this.ifsc,
    required this.transactions,
  });

  SecurityDeposit copyWith({
    int? balance,
    int? refundableAmount,
    String? accountName,
    String? accountNumber,
    String? ifsc,
    List<SecurityDepositData>? transactions,
  }) {
    return SecurityDeposit(
      balance: balance ?? this.balance,
      refundableAmount: refundableAmount ?? this.refundableAmount,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifsc: ifsc ?? this.ifsc,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  String toString() {
    return 'SecurityDeposit(balance: $balance, accountName: $accountName, accountNumber: $accountNumber, ifsc: $ifsc, transactions: $transactions, refundableAmount : $refundableAmount)';
  }

  @override
  bool operator ==(covariant SecurityDeposit other) {
    if (identical(this, other)) return true;

    return other.balance == balance &&
        other.accountName == accountName &&
        other.accountNumber == accountNumber &&
        other.ifsc == ifsc &&
        listEquals(other.transactions, transactions);
  }

  @override
  int get hashCode {
    return balance.hashCode ^
        accountName.hashCode ^
        accountNumber.hashCode ^
        ifsc.hashCode ^
        transactions.hashCode;
  }
}

class SecurityDepositNotifier extends StateNotifier<SecurityDeposit> {
  SecurityDepositNotifier()
      : super(SecurityDeposit(
          balance: 0,
          refundableAmount: 0,
          accountName: '',
          accountNumber: '',
          ifsc: '',
          transactions: [],
        ));

  Future<void> fetch(String token) async {
    print("Token::");
    print(token);
    List<SecurityDepositData> list = [];
    try {
      var call = await http.post(
        Uri.parse(
            '${Constants().url}android_app_customer/api/getWalletDetails.php'),
        headers: {
          'token': token,
        },
      );
      var response = jsonDecode(call.body);
      print(response);
      if (response['success']) {
        if (response['data'] != null) {
          print(response['data']);
          final int? currentBal = response['data']['wallet_amount'] ?? 0;
          final int? refundable = response['data']['refundable_amount'] ?? 0;
          for (var data in response['data']['wallet_transaction']) {
            list.add(SecurityDepositData.fromJson(data));
          }
          String? accName = response['data']['account_name'] ?? '';
          String? accNum = response['data']['account_no'] ?? '';
          String? ifsc = response['data']['ifsc'] ?? '';
          state = state.copyWith(
            accountName: accName,
            accountNumber: accNum,
            balance: currentBal,
            refundableAmount: refundable,
            ifsc: ifsc,
            transactions: list,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }
}
