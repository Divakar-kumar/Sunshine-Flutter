import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:sunshine/model/WeatherData.dart';
import 'package:sunshine/model/ForecastData.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';



class ApiClient {
  static ApiClient _instance;

  static ApiClient getInstance() {
    if (_instance == null) {
      _instance = new ApiClient();
    }
    return _instance;
  }

  Future<WeatherData> getWeather() async {
     var currentCoordinates=await getCoordinates();
    var lat=currentCoordinates[0];
    var lng=currentCoordinates[1];
    http.Response response = await http.get(
      Uri.encodeFull(Endpoints._ENDPOINT + "/weather?lat="+lat.toString()+"&lon="+lng.toString()+"&APPID=af29567e139fe06b6c2d050515cdff0c&units=metric"),
      headers: {
        "Accept": "application/json"
      }
    );

    return WeatherData.deserialize(response.body);
  }
Future<List<double>> getCoordinates() async {
  Map<String, double> location = await new Location().getLocation;
  double lat = location["latitude"];
  double lon = location["longitude"];

  return [lat, lon];
}
  Future<ForecastData> getForecast() async {
    var currentCoordinates=await getCoordinates();
    var lat=currentCoordinates[0];
    var lng=currentCoordinates[1];
    http.Response response = await http.get(
      Uri.encodeFull(Endpoints._ENDPOINT + "/forecast?lat="+lat.toString()+"&lon="+lng.toString()+"&APPID=af29567e139fe06b6c2d050515cdff0c&units=metric"),
      headers: {
        "Accept": "application/json"
      }
    );

    return ForecastData.deserialize(response.body);
  }

}
Future<List<double>> getCoordinates() async {
  Map<String, double> location = await new Location().getLocation;
  double lat = location["latitude"];
  double lon = location["longitude"];

  return [lat, lon];
}

Future<Map<String, dynamic>> makeHttpsRequest(Uri uri) async {
  var httpClient = new HttpClient();
  var request = await httpClient.getUrl(uri);
  var response = await request.close();
  var responseBody = await response.transform(UTF8.decoder).join();
  Map<String, dynamic> responseMap = JSON.decode(responseBody);

  return responseMap;
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
class  Endpoints {
  static const _ENDPOINT = "http://api.openweathermap.org/data/2.5";
  static const WEATHER = _ENDPOINT + "/weather?lat=43.509645&lon=16.445783&APPID=af29567e139fe06b6c2d050515cdff0c&units=metric";
  static const FORECAST = _ENDPOINT + "/forecast?lat=43.509645&lon=16.445783&APPID=af29567e139fe06b6c2d050515cdff0c&units=metric";
}