import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../core/theme/app_theme.dart';
import '../providers/budget_provider.dart';
import '../providers/expense_provider.dart';

class BudgetProgressWidget extends ConsumerWidget {
  const BudgetProgressWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetProgressAsync = ref.watch(budgetProgressProvider);
    final categories = ref.watch(categoriesProvider);

    return budgetProgressAsync.when(
      data: (progressList) {
        if (progressList.isEmpty) {
          return _buildEmptyState(context);
        }

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
                  const Row(
                    children: [
                      Icon(
                        Icons.pie_chart,
                        color: AppColors.accent,
                        size: 20,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        'Budget Progress',
                        style: AppTypography.headline,
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.push('/budget-recommendations'),
                    child: Text(
                      'Manage',
                      style: AppTypography.callout.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),

              // Budget summary
              _buildBudgetSummary(progressList),
              SizedBox(height: AppSpacing.lg),

              // Individual category progress
              ...progressList.take(4).map((progress) {
                final category = categories.firstWhere(
                  (cat) => cat.id == progress.categoryId,
                  orElse: () => categories.first,
                );
                return _buildProgressItem(progress, category);
              }),

              if (progressList.length > 4) ...[
                SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => context.push('/budget-progress'),
                  child: Text(
                    'View ${progressList.length - 4} more categories',
                    style: AppTypography.caption1.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(
                Icons.psychology,
                color: AppColors.accent,
                size: 20,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Smart Budget Recommendations',
                style: AppTypography.headline,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.accent,
                  size: 32,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Get AI-powered budget recommendations',
                  style: AppTypography.callout.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Based on your spending patterns, get personalized budget suggestions to save 10% monthly.',
                  style: AppTypography.caption1.copyWith(
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/budget-recommendations'),
                    icon: const Icon(Icons.psychology, size: 18),
                    label: const Text('Get Recommendations'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSummary(List<SimpleBudgetProgress> progressList) {
    final totalBudget =
        progressList.fold(0.0, (sum, progress) => sum + progress.budgetLimit);
    final totalSpent = progressList.fold(
        0.0, (sum, progress) => sum + progress.currentSpending);
    final overBudgetCount = progressList.where((p) => p.isOverBudget).length;
    final onTrackCount = progressList.where((p) => p.isOnTrack).length;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              '₹${NumberFormat('#,##0').format(totalSpent)}',
              'Total Spent',
              AppColors.primaryText,
            ),
          ),
          Container(
            width: 1,
            height: 32,
            color: AppColors.divider,
          ),
          Expanded(
            child: _buildSummaryItem(
              '₹${NumberFormat('#,##0').format(totalBudget)}',
              'Total Budget',
              AppColors.accent,
            ),
          ),
          Container(
            width: 1,
            height: 32,
            color: AppColors.divider,
          ),
          Expanded(
            child: _buildSummaryItem(
              '$onTrackCount',
              'On Track',
              AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.callout.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption2.copyWith(
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressItem(SimpleBudgetProgress progress, dynamic category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: 16,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category.name,
                          style: AppTypography.callout.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(progress.status)
                                .withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.sm),
                          ),
                          child: Text(
                            progress.statusMessage,
                            style: AppTypography.caption2.copyWith(
                              color: _getStatusColor(progress.status),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '₹${NumberFormat('#,##0').format(progress.currentSpending)} of ₹${NumberFormat('#,##0').format(progress.budgetLimit)}',
                      style: AppTypography.caption1.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Progress bar
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor:
                      (progress.progressPercentage / 100).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getStatusColor(progress.status),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${progress.progressPercentage.round()}% used',
                style: AppTypography.caption2.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              Text(
                '${progress.daysLeftInMonth} days left',
                style: AppTypography.caption2.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 32,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Error loading budget data',
            style: AppTypography.callout.copyWith(
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => context.push('/budget-recommendations'),
            child: const Text('Set up budgets'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.safe:
        return AppColors.success;
      case BudgetStatus.warning:
        return AppColors.warning;
      case BudgetStatus.danger:
        return AppColors.error;
      case BudgetStatus.exceeded:
        return AppColors.error;
    }
  }
}
