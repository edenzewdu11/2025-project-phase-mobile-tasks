import 'package:dartz/dartz.dart';

import '../error/failure.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw const FormatException();
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }

  // Add method for handling decimal prices
  Either<Failure, double> stringToPositiveDouble(String str) {
    try {
      final doubleValue = double.parse(str);
      if (doubleValue < 0) throw const FormatException();
      return Right(doubleValue);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
