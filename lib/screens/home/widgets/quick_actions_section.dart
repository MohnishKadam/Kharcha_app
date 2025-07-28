import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

class QuickActionsSection extends ConsumerWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTypography.headline,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'Add Expense',
                Icons.add,
                AppColors.accent,
                () => context.push('/add-expense'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildActionButton(
                context,
                'Settle Up',
                Icons.handshake,
                AppColors.success,
                () {
                  // TODO: Implement settle up flow
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settle up coming soon!')),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'View Friends',
                Icons.people,
                AppColors.categoryColors[1],
                () => context.go('/friends'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildActionButton(
                context,
                'AI Insights',
                Icons.insights,
                AppColors.categoryColors[2],
                () => context.go('/insights'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: AppTypography.callout.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
