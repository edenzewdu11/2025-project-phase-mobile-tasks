import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../core/error/failure.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/incoming_socket_message.dart';
import '../../domain/entities/message.dart';
import '../models/message_model.dart';
import '../models/incoming_socket_message_model.dart';

abstract class ChatSocketDataSource {
  Future<void> connect();
  void disconnect();
  Future<void> sendMessage({required IncomingSocketMessage outgoingMessage});

  /// New message from another user (full Message entity)
  Stream<Either<Failure, Message>> get messageReceivedStream;

  /// Confirmation that one of our sent messages was delivered (full Message entity)
  Stream<Either<Failure, Message>> get messageDeliveredStream;
}

class ChatSocketDataSourceImpl implements ChatSocketDataSource {
  final String baseUrl = 'wss://g5-flutter-learning-path-be-tvum.onrender.com';
  final SharedPreferences sharedPreferences;
  late IO.Socket _socket;

  final _receivedController =
      StreamController<Either<Failure, MessageModel>>.broadcast();
  final _deliveredController =
      StreamController<Either<Failure, MessageModel>>.broadcast();

  bool _isConnected = false;
  Completer<void>? _connectionCompleter;

  ChatSocketDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> connect() async {
    if (_isConnected) {
      print('⚠️ Socket already connected');
      return;
    }

    final authToken = sharedPreferences.getString('CACHED_AUTH_TOKEN') ?? '';
    print("🔑 Auth token: $authToken");

    _connectionCompleter = Completer<void>();

    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .enableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $authToken'})
          .build(),
    );

    _socket.onConnect((_) {
      _isConnected = true;
      print('✅ Socket connected to $baseUrl');
      _connectionCompleter?.complete();
    });

    _socket.onDisconnect((_) {
      _isConnected = false;
      print('❌ Socket disconnected');
    });

    _socket.onReconnect((_) => print('🔄 Socket reconnected'));
    _socket.onReconnectAttempt((_) => print('⏳ Attempting to reconnect...'));
    _socket.onConnectError((err) {
      print('🚨 Socket connection error: $err');
      if (!(_connectionCompleter?.isCompleted ?? true)) {
        _connectionCompleter?.completeError(ServerFailure());
      }
    });

    // Listen for incoming messages
    _socket.on('message:received', (data) {
      print('📩 Raw received message: $data');
      try {
        final message = MessageModel.fromJson(Map<String, dynamic>.from(data));
        _receivedController.add(Right(message));
      } catch (e) {
        print('⚠️ Error parsing received message: $e');
        _receivedController.add(Left(ServerFailure()));
      }
    });

    // Listen for delivery confirmations
    _socket.on('message:delivered', (data) {
      print('📬 Raw delivery confirmation: $data');
      try {
        final message = MessageModel.fromJson(Map<String, dynamic>.from(data));
        _deliveredController.add(Right(message));
      } catch (e) {
        // print('⚠️ Error parsing delivered message: $e');
        _deliveredController.add(Left(ServerFailure()));
      }
    });
    _socket.on('message:error', (data) {
      final error = data['error'] ?? 'Unknown error';
      print('Message error: $error');
      // onMessageError?.call(error); // Notify UI: "Something went wrong!"
    });

    // Wait until connected or failed
    return _connectionCompleter!.future;
  }

  @override
  void disconnect() {
    if (!_isConnected) {
      print('⚠️ Socket is not connected');
      return;
    }

    _socket.dispose();
    _socket.disconnect();
    _socket.close();
    _isConnected = false;

    _receivedController.close();
    _deliveredController.close();

    print('🔌 Socket manually disconnected');
  }

  @override
  Future<void> sendMessage({
    required IncomingSocketMessage outgoingMessage,
  }) async {
    if (!_isConnected) {
      print('⏳ Waiting for socket connection before sending...');
      try {
        await _connectionCompleter?.future.timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            throw TimeoutException('Socket connection timeout');
          },
        );
      } catch (e) {
        print('❌ Cannot send message — connection failed: $e');
        return;
      }
    }

    final msgModel = IncomingSocketMessageModel(
      chatId: outgoingMessage.chatId,
      content: outgoingMessage.content,
      type: outgoingMessage.type,
    );

    final payload = msgModel.toJson();
    _socket.emit('message:send', payload);
    print('📤 Sent message: $payload');
  }

  @override
  Stream<Either<Failure, Message>> get messageReceivedStream =>
      _receivedController.stream.map(
        (eitherModel) => eitherModel.map((model) => model.toEntity()),
      );

  @override
  Stream<Either<Failure, Message>> get messageDeliveredStream =>
      _deliveredController.stream.map(
        (eitherModel) => eitherModel.map((model) => model.toEntity()),
      );
}
