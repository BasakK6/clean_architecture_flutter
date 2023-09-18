import 'dart:async';
import 'dart:ui';

import 'package:clean_architecture_flutter/core/error/exception.dart';
import 'package:clean_architecture_flutter/core/error/failures.dart';
import 'package:clean_architecture_flutter/core/platform/network_info.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_flutter/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class NumberTriviaRepositoryImplementation implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImplementation({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int? number) async {
    return _getTrivia((){
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getTrivia(remoteDataSource.getRandomNumberTrivia);
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(Future<NumberTriviaModel> Function() getConcreteOrRandom) async{
    try{
      if(await networkInfo.isConnected){
        final NumberTriviaModel remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Future.value(Right(remoteTrivia));
      }
      else{
        final cachedNumberTriviaModel = await localDataSource.getLastNumberTrivia();
        return Future.value(Right(cachedNumberTriviaModel));
      }
    }
    on ServerException catch(e){
      return Future.value(Left(ServerFailure()));
    }
    on CacheException catch(e){
      return Future.value(Left(CacheFailure()));
    }
  }

}
