import 'package:equatable/equatable.dart';

import '../../domain/entities/incoming_socket_message.dart';

class IncomingSocketMessageModel extends Equatable {
  final String chatId;
  final String content;
  final String type;

  const IncomingSocketMessageModel({
    required this.chatId,
    required this.content,
    required this.type,
  });

  factory IncomingSocketMessageModel.fromJson(Map<String, dynamic> json) {
    return IncomingSocketMessageModel(
      chatId: json['chatId'] as String,
      content: json['message'] as String,
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'chatId': chatId, 'content': content, type: 'type'};
  }

  IncomingSocketMessage toEntity() {
    return IncomingSocketMessage(chatId: chatId, content: content, type: type);
  }

  @override
  List<Object> get props => [chatId, content, type];
}
