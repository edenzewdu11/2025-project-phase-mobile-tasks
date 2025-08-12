import 'package:equatable/equatable.dart';

class IncomingSocketMessage extends Equatable {
  final String chatId;
  final String content;
  final String type;

  const IncomingSocketMessage({
    required this.chatId,
    required this.content,
    required this.type,
  });

  @override
  List<Object> get props => [chatId, content, type];
}
