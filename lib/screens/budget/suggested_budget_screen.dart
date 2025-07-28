import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/budget_provider.dart';
import '../../providers/expense_provider.dart';

class SuggestedBudgetScreen extends ConsumerStatefulWidget {
  const SuggestedBudgetScreen({super.key});

  @override
  ConsumerState<SuggestedBudgetScreen> createState() =>
      _SuggestedBudgetScreenState();
}

class _SuggestedBudgetScreenState extends ConsumerState<SuggestedBudgetScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _selectedRecommendations = {};
  bool _isLoading = false;

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recommendations = ref.watch(budgetRecommendationsProvider);
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Budget Recommendations'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (recommendations.isNotEmpty &&
              _selectedRecommendations.values.any((selected) => selected))
            TextButton(
              onPressed: _isLoading ? null : _acceptSelectedBudgets,
              child: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Accept',
                      style: AppTypography.callout.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
        ],
      ),
      body: recommendations.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppSpacing.xl),
                  ...recommendations.map((recommendation) {
                    final category = categories.firstWhere(
                      (cat) => cat.id == recommendation.categoryId,
                      orElse: () => categories.first,
                    );

                    return _buildRecommendationCard(
                      recommendation,
                      category,
                    );
                  }),
                  const SizedBox(height: AppSpacing.xl),
                  _buildAcceptAllButton(),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'AI Budget Recommendations',
                style: AppTypography.title3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Based on your last 3 months of spending, here are personalized budget suggestions that can help you save 10% per category.',
            style: AppTypography.callout.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: AppColors.secondaryText.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Not Enough Data',
              style: AppTypography.title3.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'We need at least 3 months of expense data to generate personalized budget recommendations.',
              style: AppTypography.callout.copyWith(
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.add),
              label: const Text('Add More Expenses'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
    SimpleBudgetRecommendation recommendation,
    dynamic category,
  ) {
    final isSelected =
        _selectedRecommendations[recommendation.categoryId] ?? false;

    // Initialize controller if not exists
    if (!_controllers.containsKey(recommendation.categoryId)) {
      _controllers[recommendation.categoryId] = TextEditingController(
        text: NumberFormat('#,##0')
            .format(recommendation.recommendedBudget.round()),
      );
    }

    final controller = _controllers[recommendation.categoryId]!;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(
          color: isSelected ? AppColors.accent : AppColors.divider,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? AppShadow.medium : AppShadow.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _toggleRecommendation(recommendation.categoryId),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.accent : AppColors.divider,
                      width: 2,
                    ),
                    color: isSelected ? AppColors.accent : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: AppTypography.headline,
                    ),
                    Text(
                      '${recommendation.monthsOfData} months of data',
                      style: AppTypography.caption1.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: _getConfidenceColor(recommendation.confidenceScore)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: Text(
                  '${recommendation.confidenceScore.round()}% confidence',
                  style: AppTypography.caption2.copyWith(
                    color: _getConfidenceColor(recommendation.confidenceScore),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Spending Analysis
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Average Monthly Spending',
                      style: AppTypography.footnote,
                    ),
                    Text(
                      '₹${NumberFormat('#,##0').format(recommendation.averageSpending)}',
                      style: AppTypography.footnote.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommended Budget',
                      style: AppTypography.callout.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                    Text(
                      '₹${NumberFormat('#,##0').format(recommendation.recommendedBudget)}',
                      style: AppTypography.callout.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Potential Monthly Savings',
                      style: AppTypography.caption1.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                    Text(
                      '₹${NumberFormat('#,##0').format(recommendation.averageSpending - recommendation.recommendedBudget)}',
                      style: AppTypography.caption1.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Budget Input
          Text(
            'Customize Budget (Optional)',
            style: AppTypography.callout.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter budget amount',
              prefixText: '₹',
              suffixText: '/month',
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  _selectedRecommendations[recommendation.categoryId] = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptAllButton() {
    final recommendations = ref.read(budgetRecommendationsProvider);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading
            ? null
            : () => _acceptAllRecommendations(recommendations),
        icon: const Icon(Icons.check_circle),
        label: const Text('Accept All Recommendations'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        ),
      ),
    );
  }

  void _toggleRecommendation(String categoryId) {
    setState(() {
      _selectedRecommendations[categoryId] =
          !(_selectedRecommendations[categoryId] ?? false);
    });
  }

  Future<void> _acceptSelectedBudgets() async {
    setState(() => _isLoading = true);

    try {
      final acceptBudgets = ref.read(acceptBudgetRecommendationsProvider);
      final recommendations = ref.read(budgetRecommendationsProvider);

      final selectedRecommendations = recommendations
          .where((rec) => _selectedRecommendations[rec.categoryId] == true)
          .map((rec) {
        final controller = _controllers[rec.categoryId];
        final customAmount = controller != null && controller.text.isNotEmpty
            ? double.tryParse(controller.text.replaceAll(',', '')) ??
                rec.recommendedBudget
            : rec.recommendedBudget;

        return SimpleBudgetRecommendation(
          categoryId: rec.categoryId,
          averageSpending: rec.averageSpending,
          recommendedBudget: customAmount,
          confidenceScore: rec.confidenceScore,
          monthsOfData: rec.monthsOfData,
          monthlySpending: rec.monthlySpending,
        );
      }).toList();

      await acceptBudgets(selectedRecommendations);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${selectedRecommendations.length} budgets created successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating budgets: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _acceptAllRecommendations(
      List<SimpleBudgetRecommendation> recommendations) async {
    setState(() => _isLoading = true);

    try {
      final acceptBudgets = ref.read(acceptBudgetRecommendationsProvider);
      await acceptBudgets(recommendations);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'All ${recommendations.length} budgets created successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating budgets: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 80) return AppColors.success;
    if (confidence >= 60) return AppColors.warning;
    return AppColors.error;
  }
}
