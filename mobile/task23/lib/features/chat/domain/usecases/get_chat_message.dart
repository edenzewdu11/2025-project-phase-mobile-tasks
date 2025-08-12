import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetChatMessages {
  final ChatRepository repository;

  GetChatMessages(this.repository);

  Future<Either<Failure, List<Message>>> call(String chatId) {
    return repository.getChatMessages(chatId);
  }
}
