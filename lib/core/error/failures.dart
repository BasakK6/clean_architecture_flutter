import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final List? properties;
  const Failure([this.properties]); //optional failure details such as messages

  @override
  // to facilitate Equatable == operator and hashCode
  List<Object?> get props {
    return properties != null ? [properties] : [];
  }
}

// concrete failure classes map 1 to 1 exceptions
class ServerFailure extends Failure{

}

class CacheFailure extends Failure{

}