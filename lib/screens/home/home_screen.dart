import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/balance_provider.dart';
import 'widgets/balance_summary_card.dart';
import 'widgets/recent_expenses_card.dart';
import 'widgets/quick_actions_section.dart';
import 'widgets/quick_add_expense_dialog.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final monthlyTotal = ref.watch(monthlyTotalProvider);
    final netBalance = ref.watch(netBalanceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              snap: true,
              backgroundColor: AppColors.background,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good ${_getGreeting()} 🌟',
                      style: AppTypography.caption1.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const Text(
                      'MOHNISH',
                      style: AppTypography.title3,
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.psychology,
                    color: AppColors.accent,
                  ),
                  onPressed: () => context.push('/ai-chat'),
                  tooltip: 'Chat with AI',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.smart_toy,
                    color: AppColors.accent,
                  ),
                  onPressed: () => context.push('/ai-demo'),
                  tooltip: 'AI Demo',
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.md),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Monthly Overview Card
                  _buildMonthlyOverviewCard(monthlyTotal, netBalance),
                  const SizedBox(height: AppSpacing.lg),

                  // Balance Summary
                  const BalanceSummaryCard(),
                  const SizedBox(height: AppSpacing.lg),

                  // Quick Actions
                  const QuickActionsSection(),
                  const SizedBox(height: AppSpacing.lg),

                  // Recent Expenses
                  const RecentExpensesCard(),
                  const SizedBox(height: AppSpacing.xxl),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuickAddExpenseDialog(context, ref),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMonthlyOverviewCard(double monthlyTotal, double netBalance) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: AppShadow.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This Month',
                style: AppTypography.headline.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              Icon(
                Icons.trending_up,
                color: Colors.white.withValues(alpha: 0.8),
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '₹${NumberFormat('#,##0').format(monthlyTotal)}',
            style: AppTypography.largeTitle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Total Spent',
            style: AppTypography.callout.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  netBalance >= 0 ? Icons.trending_up : Icons.trending_down,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  netBalance >= 0
                      ? 'You are owed ₹${NumberFormat('#,##0').format(netBalance)}'
                      : 'You owe ₹${NumberFormat('#,##0').format(netBalance.abs())}',
                  style: AppTypography.caption1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  void _showQuickAddExpenseDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const QuickAddExpenseDialog(),
    );
  }
}
