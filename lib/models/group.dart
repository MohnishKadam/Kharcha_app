import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

@freezed
class Group with _$Group {
  const factory Group({
    required String id,
    required String name,
    required String description,
    required List<String> memberIds,
    required String createdById,
    String? imageUrl,
    @Default('INR') String defaultCurrency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
