import 'package:clean_architecture_flutter/core/platform/network_info.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'number_trivia_repository_implementation_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRemoteDataSource>()])
@GenerateNiceMocks([MockSpec<NumberTriviaLocalDataSource>()])
@GenerateNiceMocks([MockSpec<NetworkInfo>()])

void main(){
  late NumberTriviaRepositoryImplementation repository;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp((){
      mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
      mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();
      repository = NumberTriviaRepositoryImplementation(
        remoteDataSource: mockNumberTriviaRemoteDataSource,
        localDataSource: mockNumberTriviaLocalDataSource,
        networkInfo: mockNetworkInfo,
      );
  });


  test("should", (){
    //arrange

    //act

    //assert
  });
}

/*
test("should", (){
    //arrange

    //act

    //assert
  });
 */