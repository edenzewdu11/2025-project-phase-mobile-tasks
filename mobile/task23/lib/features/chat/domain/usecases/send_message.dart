import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/incoming_socket_message.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<Either<Failure, void>> call({
    required IncomingSocketMessage outgoingMessage,
  }) async {
    return await repository.sendMessage(outgoingMessage: outgoingMessage);
  }
}
