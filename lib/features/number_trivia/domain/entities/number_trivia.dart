import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable{
  final String text;
  final int number;

  const NumberTrivia({required this.text, required this.number});

  @override
  // to facilitate Equatable == operator and hashCode
  List<Object?> get props => [text,number];
}