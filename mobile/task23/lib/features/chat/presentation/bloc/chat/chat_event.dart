part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class LoadChatsEvent extends ChatEvent {}

class LoadMessagesEvent extends ChatEvent {
  final String chatId;
  const LoadMessagesEvent({required this.chatId});
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String content;
  final String type;
  const SendMessageEvent({
    required this.chatId,
    required this.content,
    required this.type,
  });
}

class StartListeningMessagesEvent extends ChatEvent {}

class IncomingMessageEvent extends ChatEvent {
  final Message message;
  const IncomingMessageEvent({required this.message});
}

class MessageDeliveredEvent extends ChatEvent {
  final Message message;
  const MessageDeliveredEvent({required this.message});
}

class InitiateChatEvent extends ChatEvent {
  final String userId;
  const InitiateChatEvent({required this.userId});
}
