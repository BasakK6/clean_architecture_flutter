import 'package:clean_architecture_flutter/core/error/exception.dart';
import 'package:clean_architecture_flutter/core/error/failures.dart';
import 'package:clean_architecture_flutter/core/platform/network_info.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:clean_architecture_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'number_trivia_repository_implementation_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRemoteDataSource>()])
@GenerateNiceMocks([MockSpec<NumberTriviaLocalDataSource>()])
@GenerateNiceMocks([MockSpec<NetworkInfo>()])
void main() {
  late NumberTriviaRepositoryImplementation repository;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late final int testNumber;
  late final NumberTriviaModel testNumberTriviaModel;
  late final NumberTrivia testNumberTriviaEntity;

  setUp(() {
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImplementation(
      remoteDataSource: mockNumberTriviaRemoteDataSource,
      localDataSource: mockNumberTriviaLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  testNumber = 1;
  testNumberTriviaModel = NumberTriviaModel(
    text: "Test text",
    number: testNumber,
  );
  testNumberTriviaEntity = testNumberTriviaModel;

  group("get concrete number trivia tests", () {
    test("should check if the device is online", () {
      //arrange
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      //act
      repository.getConcreteNumberTrivia(testNumber);
      //assert
      verify(mockNetworkInfo.isConnected); //verify that network info.isconnected has been called
    });

    group("sub group -> device is online", () {
      setUp(() {
        //always return true for this group
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });

      test("should return remote data when the call to remote data source is successful", () async {
        //arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((realInvocation) async => testNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(testNumber);
        //assert
        verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(testNumber));
        expect(result, equals(Right(testNumberTriviaEntity)));//repository should cast to return entity, data source returns model
      });

      test("should cache the data locally when the call to remote data source is successful", () async {
        //arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((realInvocation) async => testNumberTriviaModel);
        //act
        final result =await repository.getConcreteNumberTrivia(testNumber);
        //assert
        verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(testNumber));
        verify(mockNumberTriviaLocalDataSource.cacheNumberTrivia(testNumberTriviaModel));
      });

      test("should return server failure when the call to remote data source is unsuccessful", () async {
        //arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any)).thenThrow(ServerException());
        //act
        final result =await repository.getConcreteNumberTrivia(testNumber);
        //assert
        verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(testNumber));
        verifyZeroInteractions(mockNumberTriviaLocalDataSource);
        expect(result,equals(Left(ServerFailure())));
      });

    });

    group("sub group -> device is offline", () {
      setUp(() {
        //always return true for this group
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });

      test("should return last locally cached data when the cached data is present", () async {
        //arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia()).thenAnswer((realInvocation) async => testNumberTriviaModel);
        //act
        final result =await repository.getConcreteNumberTrivia(testNumber);
        //assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result,equals(Right(testNumberTriviaEntity)));
      });

      test("should return cache failure when there is no cached data", () async {
        //arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        //act
        final result = await repository.getConcreteNumberTrivia(testNumber);
        //assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result,equals(Left(CacheFailure())));
      });
    });
  });
  //-------
  group("get random number trivia tests", () {
    test("should check if the device is online", () {
      //arrange
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      //act
      repository.getRandomNumberTrivia();
      //assert
      verify(mockNetworkInfo.isConnected); //verify that network info.isconnected has been called
    });

    group("sub group -> device is online", () {
      setUp(() {
        //always return true for this group
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });

      test("should return remote data when the call to remote data source is successful", () async {
        //arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia()).thenAnswer((realInvocation) async => testNumberTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(testNumberTriviaEntity)));//repository should cast to return entity, data source returns model
      });

      test("should cache the data locally when the call to remote data source is successful", () async {
        //arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia()).thenAnswer((realInvocation) async => testNumberTriviaModel);
        //act
        final result =await repository.getRandomNumberTrivia();
        //assert
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        verify(mockNumberTriviaLocalDataSource.cacheNumberTrivia(testNumberTriviaModel));
      });

      test("should return server failure when the call to remote data source is unsuccessful", () async {
        //arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());
        //act
        final result =await repository.getRandomNumberTrivia();
        //assert
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaLocalDataSource);
        expect(result,equals(Left(ServerFailure())));
      });

    });

    group("sub group -> device is offline", () {
      setUp(() {
        //always return true for this group
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });

      test("should return last locally cached data when the cached data is present", () async {
        //arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia()).thenAnswer((realInvocation) async => testNumberTriviaModel);
        //act
        final result =await repository.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result,equals(Right(testNumberTriviaEntity)));
      });

      test("should return cache failure when there is no cached data", () async {
        //arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result,equals(Left(CacheFailure())));
      });
    });
  });
}

/*
test("should", (){
    //arrange

    //act

    //assert
  });
 */
