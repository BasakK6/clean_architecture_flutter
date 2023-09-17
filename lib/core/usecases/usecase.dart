import 'package:clean_architecture_flutter/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params>{
  Future<Either<Failure,Type>> call(Params? params); //you can have an implementation such as {log/print(params);}
}

class NoParams extends Equatable{
  @override
  List<Object?> get props => [];
}