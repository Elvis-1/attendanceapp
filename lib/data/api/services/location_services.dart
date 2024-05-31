import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class LocationServices {
  Location location = Location();

  late LocationData _locationData;

  Future<void> initialize() async {
    bool _serviceEnabled;
    PermissionStatus _permission;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permission = await location.hasPermission();
    if (_permission == PermissionStatus.denied) {
      _permission = await location.requestPermission();

      if (_permission != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<double?> getLatitude() async {
    _locationData = await location.getLocation();

    print('---- printing latitute ----- ${_locationData.latitude}');
    return _locationData.latitude;
  }

  Future<double?> getLongitude() async {
    _locationData = await location.getLocation();
    print('---- printing longitude ----- ${_locationData.longitude}');
    return _locationData.longitude;
  }
}
