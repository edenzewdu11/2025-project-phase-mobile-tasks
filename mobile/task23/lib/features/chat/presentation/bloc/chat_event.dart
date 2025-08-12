part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadMessages extends ChatEvent {
  final String userId;
  
  const LoadMessages(this.userId);
  
  @override
  List<Object> get props => [userId];
}

class SendMessage extends ChatEvent {
  final ChatMessage message;
  
  const SendMessage(this.message);
  
  @override
  List<Object> get props => [message];
}

class ReceiveMessage extends ChatEvent {
  final ChatMessage message;
  
  const ReceiveMessage(this.message);
  
  @override
  List<Object> get props => [message];
}

class ClearChat extends ChatEvent {}
