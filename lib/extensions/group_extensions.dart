import '../models/group.dart';

extension GroupExtension on Group {
  bool isMember(String userId) => memberIds.contains(userId);
  bool isCreator(String userId) => createdById == userId;
  int get memberCount => memberIds.length;
}
