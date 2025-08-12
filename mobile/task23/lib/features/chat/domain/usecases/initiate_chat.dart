import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class InitiateChatUseCase {
  final ChatRepository repository;

  InitiateChatUseCase(this.repository);

  Future<Either<Failure, Chat>> call(String userId) {
    return repository.initiateChat(userId);
  }
}
