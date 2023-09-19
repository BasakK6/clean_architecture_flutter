import 'dart:convert';

import 'package:clean_architecture_flutter/core/error/exception.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImplementation dataSourceImplementation;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImplementation = NumberTriviaLocalDataSourceImplementation(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group("getLastNumberTriviaTests", () {
    final testNumberTriviaModel = NumberTriviaModel.fromJson(
      jsonDecode(fixture("trivia_cached.json")),
    );

    test(
        "should return NumberTrivia from SharedPreferences when there is one in the cache",
        () async {
      //arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture("trivia_cached.json"));
      //act
      final result = await dataSourceImplementation.getLastNumberTrivia();
      //assert
      verify(mockSharedPreferences
          .getString(cacheKeyName)); //"CACHED_NUMBER_TRIVIA"
      expect(result, equals(testNumberTriviaModel));
    });

    test("should throw CacheException when there is not a cached value",
        () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final calledFunction = dataSourceImplementation.getLastNumberTrivia;
      //assert
      //we could also use it as () => dataSourceImplementation.getLastNumberTrivia(). We only put it inside a variable
      expect(
          () => calledFunction(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group("cacheNumberTrivia tests", () {
    const testNumberTriviaModel =
        NumberTriviaModel(number: 1, text: "Test text");

    test("should call shared preferences to cache the data", () {
      //arrange

      //act
      dataSourceImplementation.cacheNumberTrivia(testNumberTriviaModel);
      //assert
      final expectedJsonString = jsonEncode(testNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(cacheKeyName, expectedJsonString));
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
