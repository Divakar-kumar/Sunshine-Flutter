import 'dart:async';

import 'package:flutter_flux/flutter_flux.dart';
import 'package:sunshine/model/LocationData.dart';
import 'package:sunshine/network/ApiClient.dart';
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:location/location.dart';

class LocationStore extends Store {


LocationData locationData;
  LocationStore() {
    this.locationData=new LocationData("", null);

    triggerOnAction(updateLocation, (dynamic) {
      _updateLocation();
    });
  }

  _updateLocation() async {
    var currentCoord = await getCoordinates();
    var lat = currentCoord[0];
    var lon = currentCoord[1];
    var currentLocation = await getLocation(lat, lon);
   // this.currentLocation = currentLocation;
    this.locationData.currentLocation=currentLocation;
    this.locationData.latLng=currentCoord;
    trigger();
  }
Future<Map<String, dynamic>> makeHttpsRequest(Uri uri) async {
  var httpClient = new HttpClient();
  var request = await httpClient.getUrl(uri);
  var response = await request.close();
  var responseBody = await response.transform(UTF8.decoder).join();
  Map<String, dynamic> responseMap = JSON.decode(responseBody);

  return responseMap;
}

Future<List<double>> getCoordinates() async {
  Map<String, double> location = await new Location().getLocation;
  double lat = location["latitude"];
  double lon = location["longitude"];

  return [lat, lon];
}

Future<String> getLocation(double lat, double lon) async {
  var key = 'AIzaSyDXfRKOQt21POVoCe5bXu6BqorqqPwqyWg';
  var url = '/maps/api/geocode/json';
  var uri = new Uri.https(
    'maps.googleapis.com',
    url,
    {'latlng': ('$lat, $lon'), 'key': key},
  );

  Map<String, dynamic> responseMap = await makeHttpsRequest(uri);
  var city = responseMap['results'][0]['address_components'][2]['long_name'];

  return city;
}

}

final Action updateLocation = new Action();
final StoreToken locationStoreToken = new StoreToken(new LocationStore());