import 'dart:convert';

import 'package:clean_architecture_flutter/core/error/exception.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../core/fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  late MockClient mockHttp;
  late NumberTriviaRemoteDataSourceImplementation dataSourceImplementation;

  setUp(() {
    mockHttp = MockClient();
    dataSourceImplementation =
        NumberTriviaRemoteDataSourceImplementation(networkManager: mockHttp);
  });

  void setUpMockHttpClientSuccess200(){
    when(mockHttp.get(any, headers: anyNamed("headers"))).thenAnswer(
            (realInvocation) async => http.Response(fixture("trivia.json"), 200));
  }

  void setUpMockHttpClientFailure404(){
    when(mockHttp.get(any, headers: anyNamed("headers"))).thenAnswer(
            (realInvocation) async => http.Response("Something went wrong", 404));
  }

  group("getConcreteNumberTrivia tests", () {
    final testNumber = 1;
    final testNumberTriviaModel = NumberTriviaModel.fromJson(
      jsonDecode(
        fixture("trivia.json"),
      ),
    );

    test(
        "should perform a GET request on a URL with number being the endpoint and with application/json header",
        () {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      dataSourceImplementation.getConcreteNumberTrivia(testNumber);
      //assert
      final uri = Uri.tryParse(concreteNumberBaseURL + testNumber.toString());
      final header = {"Content-Type": "application/json"};
      verify(mockHttp.get(uri, headers: header));
    });

    test("should return NumberTrivia when the response code is 200 (success)",
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result =
          await dataSourceImplementation.getConcreteNumberTrivia(testNumber);
      //assert
      expect(result, equals(testNumberTriviaModel));
    });

    test("should throw a server exception when the response code is other than 200 (eg: 404)", () {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final calledFunction = dataSourceImplementation.getConcreteNumberTrivia;
      //assert
      expect(()=>calledFunction(testNumber), throwsA(const TypeMatcher<ServerException>()));
    });

  });



  group("getRandomNumberTrivia tests", () {
    final testNumberTriviaModel = NumberTriviaModel.fromJson(
      jsonDecode(
        fixture("trivia.json"),
      ),
    );

    test(
        "should perform a GET request on a URL with number being the endpoint and with application/json header",
            () {
          //arrange
          setUpMockHttpClientSuccess200();
          //act
          dataSourceImplementation.getRandomNumberTrivia();
          //assert
          final uri = Uri.tryParse("${concreteNumberBaseURL}random");
          final header = {"Content-Type": "application/json"};
          verify(mockHttp.get(uri, headers: header));
        });

    test("should return NumberTrivia when the response code is 200 (success)",
            () async {
          //arrange
          setUpMockHttpClientSuccess200();
          //act
          final result =
          await dataSourceImplementation.getRandomNumberTrivia();
          //assert
          expect(result, equals(testNumberTriviaModel));
        });

    test("should throw a server exception when the response code is other than 200 (eg: 404)", () {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final calledFunction = dataSourceImplementation.getRandomNumberTrivia;
      //assert
      expect(()=>calledFunction(), throwsA(const TypeMatcher<ServerException>()));
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
