import 'package:equatable/equatable.dart';

import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/message.dart';

class MessageModel extends Equatable {
  final String id;
  final UserModel sender;
  final String chatId;
  final String content;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MessageModel({
    required this.id,
    required this.sender,
    required this.chatId,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String,
      sender: UserModel.fromJson(json['sender'] as Map<String, dynamic>),
      chatId: json['chat'] is Map<String, dynamic>
          ? json['chat']['_id'] as String
          : json['chatId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      type: json['type'] as String? ?? '',
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
      'sender': sender.toJson(),
      'chatId': chatId,
      'content': content,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Message toEntity() {
    return Message(
      id: id,
      sender: sender.toEntity(),
      chatId: chatId,
      content: content,
      type: type,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, sender, chatId, content, type];
}
