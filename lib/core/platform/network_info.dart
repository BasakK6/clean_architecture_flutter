import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo{
  Future<bool> get isConnected;
}

class NetworkInfoImplementation extends NetworkInfo{
  @override
  Future<bool> get isConnected async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    switch(result){
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.mobile:
        return true;
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.none:
      default:
        return false;
    }
  }
}
