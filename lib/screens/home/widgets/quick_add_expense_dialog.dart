import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/expense.dart';
import '../../../providers/expense_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../services/ai_categorization_service.dart';
import '../../../widgets/ai_category_suggestions.dart';

class QuickAddExpenseDialog extends ConsumerStatefulWidget {
  const QuickAddExpenseDialog({super.key});

  @override
  ConsumerState<QuickAddExpenseDialog> createState() =>
      _QuickAddExpenseDialogState();
}

class _QuickAddExpenseDialogState extends ConsumerState<QuickAddExpenseDialog> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedCategoryId;
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Quick Add Expense',
                    style: AppTypography.title3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  splashRadius: 20,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Description Field
            Text(
              'Description',
              style: AppTypography.callout.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'e.g., Lunch at restaurant',
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.md),

            // Amount Field
            Text(
              'Amount',
              style: AppTypography.callout.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '0',
                prefixText: '₹ ',
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Notes Field
            Text(
              'Notes (Optional)',
              style: AppTypography.callout.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Additional details...',
              ),
              maxLines: 2,
              onChanged: (value) => setState(() {}),
            ),

            // AI Category Suggestions
            if (_descriptionController.text.isNotEmpty)
              AiCategorySuggestions(
                description: _descriptionController.text,
                notes: _notesController.text.isEmpty
                    ? null
                    : _notesController.text,
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: (categoryId) {
                  setState(() {
                    _selectedCategoryId = categoryId;
                  });
                },
              ),

            const SizedBox(height: AppSpacing.xl),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _addExpense,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Add Expense'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addExpense() async {
    // Validate inputs
    if (_descriptionController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter a description');
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showErrorSnackBar('Please enter a valid amount');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        _showErrorSnackBar('User not found');
        return;
      }

      // Use AI to categorize if no category selected
      String categoryId = _selectedCategoryId ??
          AiCategorizationService.categorizeExpense(
            _descriptionController.text,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
          );

      // Create expense
      final expense = Expense(
        id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
        description: _descriptionController.text.trim(),
        amount: amount,
        currency: 'INR',
        categoryId: categoryId,
        paidById: currentUser.id,
        splits: [
          ExpenseSplit(
            userId: currentUser.id,
            amount: amount,
          ),
        ],
        splitType: SplitType.equal,
        date: DateTime.now(),
        notes:
            _notesController.text.isEmpty ? null : _notesController.text.trim(),
        createdAt: DateTime.now(),
      );

      // Add to expenses
      final addExpense = ref.read(addExpenseProvider);
      addExpense(expense);

      // Show success and close
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Expense added: ₹${NumberFormat('#,##0').format(amount)}'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Failed to add expense: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
