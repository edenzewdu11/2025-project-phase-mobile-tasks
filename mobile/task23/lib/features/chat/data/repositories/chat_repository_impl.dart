import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/incoming_socket_message.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../datasources/chat_socket_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatSocketDataSource socketService;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.socketService,
  });

  @override
  Future<Either<Failure, List<Chat>>> getAllChats() async {
    try {
      final chatModels = await remoteDataSource.getAllChats();
      final chats = chatModels.map((model) => model.toEntity()).toList();
      return Right(chats);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId) async {
    try {
      final messageModels = await remoteDataSource.getChatMessages(chatId);
      final messages = messageModels.map((model) => model.toEntity()).toList();
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  // RepositoryImpl
  @override
  Future<Either<Failure, Chat>> initiateChat(String userId) async {
    try {
      final chatModel = await remoteDataSource.initiateChat(userId);
      return Right(chatModel.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required IncomingSocketMessage outgoingMessage,
  }) async {
    try {
      // Ensure connection first
      await socketService.connect();

      // Send the message (waits internally until connected)
      await socketService.sendMessage(outgoingMessage: outgoingMessage);

      return const Right(null); // success
    } catch (e) {
      print('❌ Error sending message: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    try {
      final models = await remoteDataSource.getAllUsers();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<Either<Failure, Message>> get messageReceivedStream =>
      socketService.messageReceivedStream;

  @override
  Stream<Either<Failure, Message>> get messageDeliveredStream =>
      socketService.messageDeliveredStream;
}
