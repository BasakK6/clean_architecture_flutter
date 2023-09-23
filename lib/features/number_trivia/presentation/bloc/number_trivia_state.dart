import 'package:clean_architecture_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class NumberTriviaState extends Equatable{
  final List? properties;
  const NumberTriviaState([this.properties]);

  @override
  // to facilitate Equatable == operator and hashCode
  List<Object?> get props {
    return properties != null ? [properties] : [];
  }
}

class Empty extends NumberTriviaState{}
class Loading extends NumberTriviaState{}
class Loaded extends NumberTriviaState{
  final NumberTrivia trivia;

  const Loaded({required this.trivia});

  @override
  // to facilitate Equatable == operator and hashCode
  List<Object?> get props {
    return [trivia];
  }
}

class Error extends NumberTriviaState{
  final String errorMessage;

  const Error({required this.errorMessage});

  @override
  // to facilitate Equatable == operator and hashCode
  List<Object?> get props {
    return [errorMessage];
  }
}