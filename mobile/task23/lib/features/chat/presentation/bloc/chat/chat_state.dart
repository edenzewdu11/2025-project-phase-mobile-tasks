part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class MessagesLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<Chat> chats;
  const ChatsLoaded({required this.chats});
}

class MessagesLoaded extends ChatState {
  final List<Message> messages;
  final Set<String> deliveredKeys;

  const MessagesLoaded({required this.messages, this.deliveredKeys = const {}});

  @override
  List<Object?> get props => [messages, deliveredKeys];
}

class ChatInitiated extends ChatState {
  final Chat chat;
  const ChatInitiated({required this.chat});
}

class ChatError extends ChatState {
  final String message;
  const ChatError({required this.message});
}
