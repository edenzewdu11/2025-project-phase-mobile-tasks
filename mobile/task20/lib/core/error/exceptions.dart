import 'package:equatable/equatable.dart';

abstract class CacheException extends Equatable {
  final String message;

  const CacheException(this.message);

  @override
  List<Object> get props => [message];
}

class CacheExceptionImpl extends CacheException {
  const CacheExceptionImpl(String message) : super(message);
}

abstract class ServerException extends Equatable {
  final String message;

  const ServerException(this.message);

  @override
  List<Object> get props => [message];
}

class ServerExceptionImpl extends ServerException {
  const ServerExceptionImpl(String message) : super(message);
}
