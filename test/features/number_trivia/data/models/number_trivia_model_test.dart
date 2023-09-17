import 'dart:convert';

import 'package:clean_architecture_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  const testNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test text");

  test("should be a subclass of NumberTrivia entity", () {
    //arrange

    //act

    //assert
    expect(testNumberTriviaModel, isA<NumberTrivia>());
  });

  group("fromJson tests", () {
    test("should return a valid model when the JSON number is an integer", () {
      //arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture("trivia.json"));

      //act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, equals(testNumberTriviaModel)); //
    });

    test("should return a valid model when the JSON number is an double", () {
      //arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture("trivia_double.json"));

      //act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, equals(testNumberTriviaModel)); //
    });
  });

  group("toJson tests", () {
    test("should return a JSON map containing the proper data", (){
      //arrange
      final expectedMap = {
        "text": "Test text",
        "number": 1
      };
      //act
      final result = testNumberTriviaModel.toJson();
      //assert
      expect(result,expectedMap);
    });

    test("should", (){
      //arrange

      //act

      //assert

    });
  });
}
