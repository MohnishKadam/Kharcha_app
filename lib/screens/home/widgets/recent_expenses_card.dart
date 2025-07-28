import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/expense_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../extensions/expense_extensions.dart';
import '../../../models/expense.dart';
import '../../../models/expense_category.dart';
import '../../../widgets/ai_category_suggestions.dart';

class RecentExpensesCard extends ConsumerWidget {
  const RecentExpensesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentExpenses = ref.watch(recentExpensesProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: AppColors.accent,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Recent Expenses',
                    style: AppTypography.headline,
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.go('/expenses'),
                child: Text(
                  'View All',
                  style: AppTypography.callout.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (recentExpenses.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 48,
                      color: AppColors.secondaryText.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No recent expenses',
                      style: AppTypography.callout.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Tap + to add your first expense',
                      style: AppTypography.caption1.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            const SizedBox(height: AppSpacing.md),
            ...recentExpenses.take(5).map(
                (expense) => _buildExpenseItem(ref, expense, currentUser?.id)),
          ],
        ],
      ),
    );
  }

  Widget _buildExpenseItem(
      WidgetRef ref, Expense expense, String? currentUserId) {
    final category = ref.watch(categoryByIdProvider(expense.categoryId));
    final paidByUser = ref.watch(userByIdProvider(expense.paidById));
    final timeAgo = _formatTimeAgo(expense.date);

    final isUserPaidBy = expense.paidById == currentUserId;
    final userAmount = isUserPaidBy
        ? expense.amount
        : expense.amountOwedBy(currentUserId ?? '');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          // Category Icon
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color:
                  (category?.color ?? AppColors.accent).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: Icon(
              category?.icon ?? Icons.category,
              color: category?.color ?? AppColors.accent,
              size: 20,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Expense Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.description,
                  style: AppTypography.callout.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text(
                      'Paid by ${isUserPaidBy ? 'you' : paidByUser?.name ?? 'Unknown'}',
                      style: AppTypography.caption1.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                    Text(
                      ' • $timeAgo',
                      style: AppTypography.caption1.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    AiCategoryIndicator(
                      description: expense.description,
                      categoryId: expense.categoryId,
                      notes: expense.notes,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${NumberFormat('#,##0').format(expense.amount)}',
                style: AppTypography.callout.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                isUserPaidBy
                    ? 'You paid'
                    : 'You owe ₹${NumberFormat('#,##0').format(userAmount)}',
                style: AppTypography.caption1.copyWith(
                  color: isUserPaidBy ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
