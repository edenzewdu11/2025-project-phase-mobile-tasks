import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../auth/domain/entities/user.dart';
import '../entities/chat.dart';
import '../entities/incoming_socket_message.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  /// Fetch all active chats for the current user.
  Future<Either<Failure, List<Chat>>> getAllChats();

  /// Fetch all messages inside a chat by its ID.
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId);

  // To Initate the chat
  Future<Either<Failure, Chat>> initiateChat(String userId);

  /// Send a new message via socket.
  Future<Either<Failure, void>> sendMessage({
    required IncomingSocketMessage outgoingMessage,
  });

  /// Listen for new incoming messages
  Stream<Either<Failure, Message>> get messageReceivedStream;

  /// Listen for delivery confirmation of sent messages
  Stream<Either<Failure, Message>> get messageDeliveredStream;

  Future<Either<Failure, List<User>>> getAllUsers();
}
