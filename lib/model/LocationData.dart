
import 'dart:convert';
class LocationData {
  String currentLocation;
  var latLng;
  LocationData(this.currentLocation,this.latLng);

  static LocationData deserialize(String json) {
   
   // return new LocationData(currentLocation.toString(), condition);
  }

}

