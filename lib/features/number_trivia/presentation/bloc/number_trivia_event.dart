import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable{
  final List? properties;
  const NumberTriviaEvent([this.properties]);

  @override
  // to facilitate Equatable == operator and hashCode
  List<Object?> get props {
    return properties != null ? [properties] : [];
  }
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent{
  final String numberString;

  const GetTriviaForConcreteNumber(this.numberString);
}

class GetTriviaForRandomNumber extends NumberTriviaEvent{}