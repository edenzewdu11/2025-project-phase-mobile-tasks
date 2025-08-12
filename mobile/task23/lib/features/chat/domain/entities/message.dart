import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';

class Message extends Equatable {
  final String id;
  final User sender;
  final String chatId;
  final String content;
  final String type; // could be "text", "image", etc.
  final DateTime createdAt;
  final DateTime updatedAt;

  const Message({
    required this.id,
    required this.sender,
    required this.chatId,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    sender,
    chatId,
    content,
    type,
    createdAt,
    updatedAt,
  ];
}
