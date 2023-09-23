import 'dart:math';

import 'package:clean_architecture_flutter/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

void main(){
    late InputConverter inputConverter;

    setUp(() {
      inputConverter = InputConverter();
    });
    
    group("stringToUnsignedInt tests", () {
      test("should return an integer when the string represents an unsigned integer", (){
        //arrange
        const str ="123";
        //act
        final result = inputConverter.stringToUnsignedInteger(str);
        //assert
        expect(result, equals(const Right(123)));
      });

      test("should return a Failure when the string is not an integer", (){
        //arrange
        const str ="1.1";//or "abc"
        //act
        final result = inputConverter.stringToUnsignedInteger(str);
        //assert
        expect(result, equals(Left(InvalidInputFailure())));
      });

      test("should return a Failure when the string is a negative integer", (){
        const str ="-1";//or "abc"
        //act
        final result = inputConverter.stringToUnsignedInteger(str);
        //assert
        expect(result, equals(Left(InvalidInputFailure())));
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