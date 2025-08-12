import 'package:uuid/uuid.dart';

abstract class IdGenerator {
  String generate();
}

class UuidGenerator implements IdGenerator {
  final _uuid = const Uuid();

  @override
  String generate() => _uuid.v4(); // e.g., 'b1c70854-71ff-4e2e-9a3c-5bd3ed1c7ed1'
}
