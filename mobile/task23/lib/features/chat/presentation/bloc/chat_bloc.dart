import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final List<ChatMessage> _messages = [];
  
  ChatBloc() : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<ClearChat>(_onClearChat);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // In a real app, you would load messages from a repository
      // For now, we'll just use the current messages
      emit(ChatLoaded(messages: List.from(_messages)));
    } catch (e) {
      emit(ChatError(message: 'Failed to load messages: $e'));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _messages.add(event.message);
      emit(ChatLoaded(messages: List.from(_messages)));
    } catch (e) {
      emit(ChatError(message: 'Failed to send message: $e'));
    }
  }

  Future<void> _onReceiveMessage(
    ReceiveMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _messages.add(event.message);
      emit(ChatLoaded(messages: List.from(_messages)));
    } catch (e) {
      emit(ChatError(message: 'Failed to receive message: $e'));
    }
  }

  Future<void> _onClearChat(
    ClearChat event,
    Emitter<ChatState> emit,
  ) async {
    try {
      _messages.clear();
      emit(ChatLoaded(messages: List.from(_messages)));
    } catch (e) {
      emit(ChatError(message: 'Failed to clear chat: $e'));
    }
  }
}
