import 'package:clean_architecture_flutter/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final parsedValue = int.parse(str);
      return parsedValue >= 0
          ? Right(parsedValue)
          : throw const FormatException();
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
