import 'package:equatable/equatable.dart';

import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/chat.dart';

class ChatModel extends Equatable {
  final String id;
  final UserModel user1;
  final UserModel user2;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatModel({
    required this.id,
    required this.user1,
    required this.user2,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] as String,
      user1: UserModel.fromJson(json['user1'] as Map<String, dynamic>),
      user2: UserModel.fromJson(json['user2'] as Map<String, dynamic>),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user1': user1.toJson(),
      'user2': user2.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Chat toEntity() {
    return Chat(
      id: id,
      user1: user1.toEntity(),
      user2: user2.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, user1, user2, createdAt, updatedAt];
}
