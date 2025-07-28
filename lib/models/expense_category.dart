import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_category.freezed.dart';
part 'expense_category.g.dart';

@freezed
class ExpenseCategory with _$ExpenseCategory {
  const factory ExpenseCategory({
    required String id,
    required String name,
    required String iconName,
    required int colorIndex,
    @Default(false) bool isCustom,
    DateTime? createdAt,
  }) = _ExpenseCategory;

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoryFromJson(json);
}

// Extension to get icon and color
extension ExpenseCategoryExtension on ExpenseCategory {
  IconData get icon {
    switch (iconName) {
      case 'bowl':
        return Icons.restaurant;
      case 'house':
        return Icons.home;
      case 'shoppingBag':
        return Icons.shopping_bag;
      case 'car':
        return Icons.directions_car;
      case 'gameController':
        return Icons.videogame_asset;
      case 'heartbeat':
        return Icons.favorite;
      case 'graduationCap':
        return Icons.school;
      case 'airplane':
        return Icons.flight;
      case 'coffee':
        return Icons.local_cafe;
      case 'gift':
        return Icons.card_giftcard;
      case 'wrench':
        return Icons.build;
      case 'chartLine':
        return Icons.trending_up;
      default:
        return Icons.category;
    }
  }

  Color get color {
    final colors = [
      const Color(0xFF007AFF), // Blue
      const Color(0xFF5856D6), // Purple
      const Color(0xFFAF52DE), // Purple Light
      const Color(0xFFFF2D92), // Pink
      const Color(0xFFFF3B30), // Red
      const Color(0xFFFF9F0A), // Orange
      const Color(0xFFFFCC02), // Yellow
      const Color(0xFF30D158), // Green
      const Color(0xFF00C7BE), // Teal
      const Color(0xFF34C759), // Green Light
    ];

    return colors[colorIndex % colors.length];
  }
}

class DefaultCategories {
  static List<ExpenseCategory> get categories => [
        const ExpenseCategory(
          id: 'food',
          name: 'Food & Drinks',
          iconName: 'bowl',
          colorIndex: 0,
        ),
        const ExpenseCategory(
          id: 'housing',
          name: 'Housing',
          iconName: 'house',
          colorIndex: 1,
        ),
        const ExpenseCategory(
          id: 'shopping',
          name: 'Shopping',
          iconName: 'shoppingBag',
          colorIndex: 2,
        ),
        const ExpenseCategory(
          id: 'transportation',
          name: 'Transportation',
          iconName: 'car',
          colorIndex: 3,
        ),
        const ExpenseCategory(
          id: 'entertainment',
          name: 'Entertainment',
          iconName: 'gameController',
          colorIndex: 4,
        ),
        const ExpenseCategory(
          id: 'healthcare',
          name: 'Healthcare',
          iconName: 'heartbeat',
          colorIndex: 5,
        ),
        const ExpenseCategory(
          id: 'education',
          name: 'Education',
          iconName: 'graduationCap',
          colorIndex: 6,
        ),
        const ExpenseCategory(
          id: 'travel',
          name: 'Travel',
          iconName: 'airplane',
          colorIndex: 7,
        ),
        const ExpenseCategory(
          id: 'coffee',
          name: 'Coffee & Tea',
          iconName: 'coffee',
          colorIndex: 8,
        ),
        const ExpenseCategory(
          id: 'gifts',
          name: 'Gifts',
          iconName: 'gift',
          colorIndex: 9,
        ),
        const ExpenseCategory(
          id: 'utilities',
          name: 'Utilities',
          iconName: 'wrench',
          colorIndex: 1,
        ),
        const ExpenseCategory(
          id: 'investment',
          name: 'Investment',
          iconName: 'chartLine',
          colorIndex: 0,
        ),
      ];
}
