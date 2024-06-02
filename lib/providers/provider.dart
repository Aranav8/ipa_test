import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/GST.dart';
import './GSTNotifier.dart';
import 'SecurityDepositNotifier.dart';

final gstProvider =
    StateNotifierProvider<GSTNotififer, GST>((ref) => GSTNotififer());

final securityDepositDataProvider =
    StateNotifierProvider<SecurityDepositNotifier, SecurityDeposit>(
        (ref) => SecurityDepositNotifier());
