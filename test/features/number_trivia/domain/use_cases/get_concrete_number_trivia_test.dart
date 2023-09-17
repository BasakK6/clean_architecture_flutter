import 'package:clean_architecture_flutter/features/number_trivia/domain/entitites/number_trivia.dart';
import 'package:clean_architecture_flutter/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_flutter/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

/*class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}*/
// to remove null type is not a subtype of Future<Either.. error use the code below instead of the class above
@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])

void main() {
  late final GetConcreteNumberTrivia usecase;
  late final MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  test("should get trivia for the number from the repository", () async {
    //arrange
    const testNumber = 1;
    final testNumberTrivia = NumberTrivia(
      text: "trivia text",
      number: testNumber,
    );
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber))
        .thenAnswer((realInvocation) async => Right(testNumberTrivia));

    //act
    final result = await usecase.execute(number: testNumber);

    //assert
    expect(result, Right(testNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(
        testNumber)); //verify that the getConcreteNumber Trivia gets called with testNumber
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
