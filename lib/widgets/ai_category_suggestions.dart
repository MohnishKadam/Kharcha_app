import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense_category.dart';
import '../providers/expense_provider.dart';
import '../services/ai_categorization_service.dart';
import '../core/theme/app_theme.dart';

class AiCategorySuggestions extends ConsumerWidget {
  final String description;
  final String? notes;
  final String? selectedCategoryId;
  final Function(String categoryId) onCategorySelected;

  const AiCategorySuggestions({
    super.key,
    required this.description,
    this.notes,
    this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    if (description.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    // Get AI suggestions
    final suggestions = AiCategorizationService.getSuggestedCategories(
      description,
      notes: notes,
      maxSuggestions: 3,
    );

    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.smart_toy,
                size: 16,
                color: AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'AI Suggestions',
                style: AppTypography.caption1.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: suggestions.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                final categoryId = suggestion.key;
                final confidence = suggestion.value;

                final category = categories.firstWhere(
                  (cat) => cat.id == categoryId,
                  orElse: () => categories.first,
                );

                final isSelected = selectedCategoryId == categoryId;

                return _buildSuggestionCard(
                  category: category,
                  confidence: confidence,
                  isSelected: isSelected,
                  onTap: () => onCategorySelected(categoryId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard({
    required ExpenseCategory category,
    required int confidence,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 120,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withValues(alpha: 0.1)
              : AppColors.surface,
          border: Border.all(
            color: isSelected ? category.color : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: category.color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : AppShadow.small,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
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
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                category.name,
                style: AppTypography.caption2.copyWith(
                  color: isSelected ? category.color : AppColors.primaryText,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: _getConfidenceColor(confidence).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              child: Text(
                '$confidence%',
                style: AppTypography.caption2.copyWith(
                  color: _getConfidenceColor(confidence),
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(int confidence) {
    if (confidence >= 70) return Colors.green;
    if (confidence >= 40) return Colors.orange;
    return Colors.red;
  }
}

/// Widget to show AI categorization status in expense list
class AiCategoryIndicator extends ConsumerWidget {
  final String description;
  final String categoryId;
  final String? notes;

  const AiCategoryIndicator({
    super.key,
    required this.description,
    required this.categoryId,
    this.notes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confidence = AiCategorizationService.getConfidenceScore(
      description,
      categoryId,
      notes: notes,
    );

    if (confidence < 30) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.smart_toy,
            size: 10,
            color: AppColors.accent,
          ),
          const SizedBox(width: 2),
          Text(
            'AI',
            style: AppTypography.caption2.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}
