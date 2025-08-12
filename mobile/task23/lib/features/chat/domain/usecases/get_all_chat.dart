import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class GetAllChats {
  final ChatRepository repository;

  GetAllChats(this.repository);

  Future<Either<Failure, List<Chat>>> call() {
    return repository.getAllChats();
  }
}
