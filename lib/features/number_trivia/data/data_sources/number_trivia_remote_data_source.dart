import 'dart:convert';

import 'package:clean_architecture_flutter/core/error/exception.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource{
  ///Calls the http://numbersapi.com/{number} endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number);
  ///Calls the http://numbersapi.com/random endpoint
  ///
  /// Throws a [ServerException] for all error codes
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

const String concreteNumberBaseURL = "http://numbersapi.com/";


class NumberTriviaRemoteDataSourceImplementation implements NumberTriviaRemoteDataSource{
  final http.Client networkManager;

  NumberTriviaRemoteDataSourceImplementation({required this.networkManager});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int? number) async {
    return _getTriviaFromURL(concreteNumberBaseURL+ number.toString());
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return _getTriviaFromURL("${concreteNumberBaseURL}random");
  }

  Future<NumberTriviaModel> _getTriviaFromURL(String url) async {
    final uri =Uri.tryParse(url);
    final header = {
      "Content-Type":"application/json"
    };
    final response = await networkManager.get(uri!,headers:header);
    if(response.statusCode == 200){
      return NumberTriviaModel.fromJson(jsonDecode(response.body));
    }
    throw ServerException();
  }


}