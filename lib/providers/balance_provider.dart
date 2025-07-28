import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/balance.dart';
import '../models/settlement.dart';
import '../extensions/balance_extensions.dart';
import 'user_provider.dart';

// Mock balance data
final balancesProvider = StateProvider<List<Balance>>((ref) {
  return [
    const Balance(
      id: 'bal_1',
      fromUserId: 'user_1',
      toUserId: 'user_2',
      amount: 225.0,
      currency: 'INR',
      lastUpdated: null,
    ),
    const Balance(
      id: 'bal_2',
      fromUserId: 'user_3',
      toUserId: 'user_1',
      amount: 960.0,
      currency: 'INR',
      lastUpdated: null,
    ),
    const Balance(
      id: 'bal_3',
      fromUserId: 'user_1',
      toUserId: 'user_4',
      amount: 150.0,
      currency: 'INR',
      lastUpdated: null,
    ),
  ];
});

// Settlements provider
final settlementsProvider = StateProvider<List<Settlement>>((ref) {
  return [];
});

// User's balances (where user owes or is owed money)
final userBalancesProvider = Provider<List<Balance>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final balances = ref.watch(balancesProvider);

  if (currentUser == null) return [];

  return balances
      .where((balance) => balance.involvesUser(currentUser.id))
      .toList();
});

// Total amount user owes
final totalOwedByUserProvider = Provider<double>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final userBalances = ref.watch(userBalancesProvider);

  if (currentUser == null) return 0.0;

  return userBalances.fold(0.0, (total, balance) {
    final amount = balance.amountForUser(currentUser.id);
    return amount < 0 ? total + amount.abs() : total;
  });
});

// Total amount owed to user
final totalOwedToUserProvider = Provider<double>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final userBalances = ref.watch(userBalancesProvider);

  if (currentUser == null) return 0.0;

  return userBalances.fold(0.0, (total, balance) {
    final amount = balance.amountForUser(currentUser.id);
    return amount > 0 ? total + amount : total;
  });
});

// Net balance (positive = owed to you, negative = you owe)
final netBalanceProvider = Provider<double>((ref) {
  final owedToUser = ref.watch(totalOwedToUserProvider);
  final owedByUser = ref.watch(totalOwedByUserProvider);

  return owedToUser - owedByUser;
});

// Group balances by other user
final balancesByUserProvider = Provider<Map<String, double>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final userBalances = ref.watch(userBalancesProvider);

  if (currentUser == null) return {};

  final balancesByUser = <String, double>{};

  for (final balance in userBalances) {
    final otherUserId = balance.getOtherUserId(currentUser.id);
    final amount = balance.amountForUser(currentUser.id);

    balancesByUser[otherUserId] = (balancesByUser[otherUserId] ?? 0) + amount;
  }

  return balancesByUser;
});

// Settle balance method
final settleBalanceProvider =
    Provider<void Function(String, String, double)>((ref) {
  return (String fromUserId, String toUserId, double amount) {
    // Create settlement record
    final settlement = Settlement(
      id: 'settlement_${DateTime.now().millisecondsSinceEpoch}',
      fromUserId: fromUserId,
      toUserId: toUserId,
      amount: amount,
      currency: 'INR',
      method: SettlementMethod.upi,
      date: DateTime.now(),
      createdAt: DateTime.now(),
    );

    // Add to settlements
    final settlements = ref.read(settlementsProvider.notifier);
    settlements.update((state) => [...state, settlement]);

    // Update balances
    final balances = ref.read(balancesProvider.notifier);
    balances.update((state) {
      final updatedBalances = List<Balance>.from(state);

      // Find and update the relevant balance
      for (int i = 0; i < updatedBalances.length; i++) {
        final balance = updatedBalances[i];
        if ((balance.fromUserId == fromUserId &&
                balance.toUserId == toUserId) ||
            (balance.fromUserId == toUserId &&
                balance.toUserId == fromUserId)) {
          final currentAmount = balance.amountForUser(fromUserId).abs();
          final newAmount = currentAmount - amount;

          if (newAmount <= 0) {
            // Balance is settled, remove it
            updatedBalances.removeAt(i);
          } else {
            // Update the balance
            updatedBalances[i] = balance.copyWith(
              amount: newAmount,
              lastUpdated: DateTime.now(),
            );
          }
          break;
        }
      }

      return updatedBalances;
    });
  };
});
