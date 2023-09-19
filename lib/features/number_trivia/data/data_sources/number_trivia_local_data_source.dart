import 'dart:convert';

import 'package:clean_architecture_flutter/core/error/exception.dart';
import 'package:clean_architecture_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource{
  ///Gets the cached [NumberTriviaModel] which was gotten the last time
  ///the user had an internet connection
  ///
  /// Throws [CacheDataException] if no cached data is present
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModelToCache);
}

const String cacheKeyName ="CACHED_NUMBER_TRIVIA";
class NumberTriviaLocalDataSourceImplementation implements NumberTriviaLocalDataSource{
  final SharedPreferences sharedPreferences;
  NumberTriviaLocalDataSourceImplementation({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    String? cachedNumberTrivia = sharedPreferences.getString(cacheKeyName);
    if(cachedNumberTrivia != null){
      return Future.value(NumberTriviaModel.fromJson(jsonDecode(cachedNumberTrivia)));
    }
    else{
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModelToCache) async{
    final String jsonString = jsonEncode(triviaModelToCache.toJson());
    sharedPreferences.setString(cacheKeyName, jsonString);
  }
}