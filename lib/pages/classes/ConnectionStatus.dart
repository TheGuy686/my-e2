import 'dart:async';
import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

import 'globals.dart';

class ConnectionStatus {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool isConnected = true;

  Map<String, Function> events = {};

  ConnectionStatus() {
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (ConnectivityResult.none == result) {
      isConnected = false;
    } else {
      isConnected = true;
    }

    // here we need to emit all the events that are waiting for this.
    events.forEach((e, f) async {
      f();
    });

    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        _connectionStatus = result.toString();

        break;
      default:
        _connectionStatus = 'Failed to get connectivity.';
        break;
    }
  }

  void onChange(String evtId, dynamic callback) {
    events[evtId] = callback;
  }
}
