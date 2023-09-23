import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clean_architecture_flutter/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:clean_architecture_flutter/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import './bloc.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState>{
  NumberTriviaBloc(super.initialState);

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
      NumberTriviaEvent event,
      ) async* {
    //TODO: Add logic
  }
}