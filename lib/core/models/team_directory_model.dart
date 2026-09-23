import 'package:flutter/foundation.dart';
import 'user_model.dart';

@immutable
class TeamDirectoryNode {
  final UserModel supervisor;
  final List<UserModel> reps;

  const TeamDirectoryNode({
    required this.supervisor,
    required this.reps,
  });

  factory TeamDirectoryNode.fromJson(Map<String, dynamic> json) {
    return TeamDirectoryNode(
      supervisor: UserModel.fromJson(json['supervisor'] as Map<String, dynamic>),
      reps: (json['reps'] as List)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
