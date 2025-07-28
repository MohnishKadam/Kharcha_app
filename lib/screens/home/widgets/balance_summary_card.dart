import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/balance_provider.dart';
import '../../../providers/user_provider.dart';

class BalanceSummaryCard extends ConsumerWidget {
  const BalanceSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalOwedByUser = ref.watch(totalOwedByUserProvider);
    final totalOwedToUser = ref.watch(totalOwedToUserProvider);
    final balancesByUser = ref.watch(balancesByUserProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.balance,
                color: AppColors.accent,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Balance Overview',
                style: AppTypography.headline,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Balance Summary Row
          Row(
            children: [
              Expanded(
                child: _buildBalanceItem(
                  'You Owe',
                  totalOwedByUser,
                  AppColors.error,
                  Icons.arrow_upward,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildBalanceItem(
                  'Owed to You',
                  totalOwedToUser,
                  AppColors.success,
                  Icons.arrow_downward,
                ),
              ),
            ],
          ),

          if (balancesByUser.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),

            // Individual Balances
            ...balancesByUser.entries.take(3).map((entry) =>
                _buildIndividualBalance(ref, entry.key, entry.value)),

            if (balancesByUser.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  '+${balancesByUser.length - 3} more',
                  style: AppTypography.caption1.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildBalanceItem(
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: AppTypography.caption1.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '₹${NumberFormat('#,##0').format(amount)}',
            style: AppTypography.title3.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndividualBalance(WidgetRef ref, String userId, double amount) {
    final user = ref.watch(userByIdProvider(userId));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.accent.withValues(alpha: 0.1),
            child: Text(
              (user?.name ?? 'U').substring(0, 1).toUpperCase(),
              style: AppTypography.caption1.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              user?.name ?? 'Unknown User',
              style: AppTypography.callout,
            ),
          ),
          Text(
            amount >= 0
                ? '+₹${NumberFormat('#,##0').format(amount)}'
                : '-₹${NumberFormat('#,##0').format(amount.abs())}',
            style: AppTypography.callout.copyWith(
              color: amount >= 0 ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
