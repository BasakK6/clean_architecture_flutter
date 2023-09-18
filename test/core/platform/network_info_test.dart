import 'dart:ui';

import 'package:clean_architecture_flutter/core/platform/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Connectivity>()])
void main(){
  DartPluginRegistrant.ensureInitialized();
  TestWidgetsFlutterBinding.ensureInitialized(); // for the connectivity package
  late NetworkInfoImplementation networkInfoImplementation;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfoImplementation = NetworkInfoImplementation();
  });

  group("isConnected", () {
    /*test("should forward the call to Connectivity().checkConnectivity()", () async {
      //arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((realInvocation) async => ConnectivityResult.wifi);
      //act
      final result = await networkInfoImplementation.isConnected;
      //assert
      verify(mockConnectivity.checkConnectivity);
      //expect(result, true);
    });*/
  });

}