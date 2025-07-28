import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

// Mock current user - in real app this would come from authentication
final currentUserProvider = StateProvider<User?>((ref) {
  return const User(
    id: 'user_1',
    name: 'You',
    email: 'you@example.com',
    createdAt: null,
    updatedAt: null,
  );
});

// All users provider - in real app this would come from backend
final usersProvider = StateProvider<List<User>>((ref) {
  return [
    const User(
      id: 'user_1',
      name: 'You',
      email: 'mohnish2k2@example.com',
    ),
    const User(
      id: 'user_2',
      name: 'dilip kumar',
      email: 'dilip@example.com',
    ),
    const User(
      id: 'user_3',
      name: 'Ande wala bur',
      email: 'ande@example.com',
    ),
    const User(
      id: 'user_4',
      name: 'Charlie chaplin',
      email: 'charlie@example.com',
    ),
    const User(
      id: 'user_5',
      name: 'Diana Prince',
      email: 'diana@example.com',
    ),
  ];
});

// Get user by ID
final userByIdProvider = Provider.family<User?, String>((ref, userId) {
  final users = ref.watch(usersProvider);
  try {
    return users.firstWhere((user) => user.id == userId);
  } catch (e) {
    return null;
  }
});

// Friends provider
final friendsProvider = Provider<List<User>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final allUsers = ref.watch(usersProvider);

  if (currentUser == null) return [];

  return allUsers
      .where((user) =>
          user.id != currentUser.id && currentUser.friendIds.contains(user.id))
      .toList();
});
