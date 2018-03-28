import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sunshine/model/ForecastData.dart';
import 'package:sunshine/ui/forecast_detail/ForecastDetail.dart';
import 'package:sunshine/res/Res.dart';
final monthFormat = new DateFormat('MMMM');

class ForecastDetailPage extends StatelessWidget {
  ForecastWeather weather;

  ForecastDetailPage(this.weather);

  static MaterialPageRoute getRoute(ForecastWeather forecastWeather) {
    return new MaterialPageRoute(builder: (BuildContext context) {
      return new ForecastDetailPage(forecastWeather);
    });
  }

  @override
  Widget build(BuildContext context) {
    var title = weather.dateTime.hour.toString() + "h";
    var month = monthFormat.format(weather.dateTime);
    title += " • " + weather.dateTime.day.toString() + " " + month;

    return new Scaffold(
      appBar: new AppBar(title: new Text(title),backgroundColor: Colors.lightBlueAccent,),
      body: new Container(
          decoration: new BoxDecoration(
             image: new DecorationImage(
          image: new AssetImage($Asset.backgroundDetails),
          fit: BoxFit.cover,
        )),
          child: new Center(
            child: new ForecastDetail(weather),
          )),
    );
  }
}
