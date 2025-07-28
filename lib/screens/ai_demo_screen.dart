import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../core/theme/app_theme.dart';
import '../models/expense_category.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';

class SmartInsightsScreen extends ConsumerWidget {
  const SmartInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider);
    final categories = ref.watch(categoriesProvider);
    final monthlyTotal = ref.watch(monthlyTotalProvider);
    final categorySpending = ref.watch(categorySpendingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.insights,
              color: AppColors.accent,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text('Smart Insights'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Monthly Overview Card
            _buildMonthlyOverviewCard(monthlyTotal),
            const SizedBox(height: AppSpacing.lg),

            // Top Spending Categories
            _buildTopCategoriesCard(categorySpending, categories),
            const SizedBox(height: AppSpacing.lg),

            // Spending Trends
            _buildTrendsCard(expenses, monthlyTotal),
            const SizedBox(height: AppSpacing.lg),

            // Smart Recommendations
            _buildRecommendationsCard(expenses, monthlyTotal, categorySpending),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyOverviewCard(double monthlyTotal) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final daysLeft = daysInMonth - now.day;
    final dailyAverage = monthlyTotal / now.day;
    final projectedTotal = dailyAverage * daysInMonth;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accent, AppColors.accent.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: AppShadow.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'This Month',
                style: AppTypography.title3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${NumberFormat('#,##0').format(monthlyTotal)}',
                      style: AppTypography.title1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Spent so far',
                      style: AppTypography.caption2.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Column(
                  children: [
                    Text(
                      '$daysLeft',
                      style: AppTypography.title2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Days left',
                      style: AppTypography.caption2.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(
            value: now.day / daysInMonth,
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Projected: ₹${NumberFormat('#,##0').format(projectedTotal)}',
            style: AppTypography.caption2.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCategoriesCard(
      Map<String, double> categorySpending, List<ExpenseCategory> categories) {
    final sortedCategories = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: AppShadow.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.category,
                color: AppColors.accent,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Top Spending Categories',
                style: AppTypography.title3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...sortedCategories.take(5).map((entry) {
            final category = categories.firstWhere(
              (cat) => cat.id == entry.key,
              orElse: () => ExpenseCategory(
                id: entry.key,
                name: 'Unknown',
                iconName: 'help',
                colorIndex: 0,
              ),
            );
            final percentage = (entry.value /
                    categorySpending.values
                        .fold(0.0, (sum, amount) => sum + amount)) *
                100;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
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
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: AppTypography.callout.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${percentage.toStringAsFixed(1)}% of total',
                          style: AppTypography.caption2.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${NumberFormat('#,##0').format(entry.value)}',
                    style: AppTypography.callout.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTrendsCard(List<Expense> expenses, double monthlyTotal) {
    final now = DateTime.now();
    final daysInMonth = now.day;
    final dailyAverage = daysInMonth > 0 ? monthlyTotal / daysInMonth : 0.0;

    // Find biggest expense
    Expense? biggestExpense;
    if (expenses.isNotEmpty) {
      biggestExpense = expenses.reduce((a, b) => a.amount > b.amount ? a : b);
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: AppShadow.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: AppColors.accent,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Spending Trends',
                style: AppTypography.title3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTrendItem(
            'Daily Average',
            '₹${NumberFormat('#,##0').format(dailyAverage)}',
            dailyAverage > 1000 ? 'High spending' : 'Good control',
            dailyAverage > 1000 ? AppColors.error : AppColors.success,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildTrendItem(
            'Biggest Expense',
            '₹${NumberFormat('#,##0').format(biggestExpense?.amount ?? 0)}',
            biggestExpense?.description ?? 'No expenses yet',
            AppColors.warning,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildTrendItem(
            'Expense Count',
            '${expenses.length}',
            'This month',
            AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendItem(
      String title, String value, String subtitle, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.caption2.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              Text(
                value,
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: AppTypography.caption2.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsCard(List<Expense> expenses, double monthlyTotal,
      Map<String, double> categorySpending) {
    final recommendations =
        _generateRecommendations(expenses, monthlyTotal, categorySpending);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: AppShadow.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: AppColors.accent,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Smart Recommendations',
                style: AppTypography.title3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...recommendations
              .map((rec) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Row(
                      children: [
                        Icon(
                          rec['icon'],
                          color: rec['color'],
                          size: 16,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            rec['message'],
                            style: AppTypography.callout,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _generateRecommendations(List<Expense> expenses,
      double monthlyTotal, Map<String, double> categorySpending) {
    final recommendations = <Map<String, dynamic>>[];

    // Daily spending recommendation
    final now = DateTime.now();
    final dailyAverage = now.day > 0 ? monthlyTotal / now.day : 0.0;

    if (dailyAverage > 1000) {
      recommendations.add({
        'message': 'Your daily spending is high. Try to stay under ₹800/day.',
        'icon': Icons.trending_down,
        'color': AppColors.warning,
      });
    } else {
      recommendations.add({
        'message': 'Great job! Your daily spending is well controlled.',
        'icon': Icons.thumb_up,
        'color': AppColors.success,
      });
    }

    // Category recommendations
    if (categorySpending.isNotEmpty) {
      final topCategory =
          categorySpending.entries.reduce((a, b) => a.value > b.value ? a : b);

      if (topCategory.value > monthlyTotal * 0.4) {
        recommendations.add({
          'message':
              '${topCategory.key} is your biggest expense. Consider reducing it.',
          'icon': Icons.category,
          'color': AppColors.warning,
        });
      }
    }

    // General recommendations
    if (expenses.length < 5) {
      recommendations.add({
        'message': 'Add more expenses to get better insights.',
        'icon': Icons.add_circle,
        'color': AppColors.accent,
      });
    }

    return recommendations;
  }
}
