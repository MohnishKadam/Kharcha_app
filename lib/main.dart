import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'screens/home/home_screen.dart';
import 'screens/expenses/expenses_screen.dart';
import 'screens/friends/friends_screen.dart';
import 'screens/insights/insights_screen.dart';
import 'screens/add_expense/add_expense_screen.dart';
import 'screens/chat/ai_chat_screen.dart';
import 'screens/ai_demo_screen.dart';
import 'screens/budget/suggested_budget_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: KharchaApp(),
    ),
  );
}

class KharchaApp extends StatelessWidget {
  const KharchaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kharcha - Smart Expense Tracker',
      theme: AppTheme.light,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainNavigationWrapper(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/expenses',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ExpensesScreen(),
          ),
        ),
        GoRoute(
          path: '/friends',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FriendsScreen(),
          ),
        ),
        GoRoute(
          path: '/insights',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: InsightsScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/add-expense',
      builder: (context, state) => const AddExpenseScreen(),
    ),
    GoRoute(
      path: '/ai-chat',
      builder: (context, state) => const AiChatScreen(),
    ),
    GoRoute(
      path: '/ai-demo',
      builder: (context, state) => const SmartInsightsScreen(),
    ),
    GoRoute(
      path: '/budget-recommendations',
      builder: (context, state) => const SuggestedBudgetScreen(),
    ),
  ],
);

class MainNavigationWrapper extends StatelessWidget {
  final Widget child;

  const MainNavigationWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const MainBottomNavigation(),
    );
  }
}

class MainBottomNavigation extends ConsumerWidget {
  const MainBottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    switch (currentLocation) {
      case '/':
        currentIndex = 0;
        break;
      case '/expenses':
        currentIndex = 1;
        break;
      case '/friends':
        currentIndex = 2;
        break;
      case '/insights':
        currentIndex = 3;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.divider,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/expenses');
                break;
              case 2:
                context.go('/friends');
                break;
              case 3:
                context.go('/insights');
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.secondaryText,
          selectedLabelStyle: AppTypography.caption2.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTypography.caption2,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Expenses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Friends',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_outlined),
              activeIcon: Icon(Icons.insights),
              label: 'Insights',
            ),
          ],
        ),
      ),
    );
  }
}
