import 'package:flutter/services.dart';

class Gyroscope {
  static const EventChannel _gyroscopeEventChannel =
      EventChannel('gyroscope_event');

  Stream<List<double>> get gyroscopeStream {
    return _gyroscopeEventChannel.receiveBroadcastStream().map((dynamic event) {
      return List<double>.from(event);
    });
  }
}
