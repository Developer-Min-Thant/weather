import 'dart:convert' as convert;
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../models/weather_forecast.dart';
import '../utils/constants.dart';
import '../utils/location.dart';

class WeatherApi {
  static const _host = Constants.WEATHER_BASE_SCHEME + Constants.WEATHER_BASE_URL_DOMAIN;

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  Future<WeatherModel> fetchWeatherForecast({String? cityName}) async {
    Map<String, String> parameters;
    
    if (cityName!=null && cityName.isNotEmpty) {
      parameters = {
        'key': Constants.WEATHER_APP_ID,
        'q': cityName,
        'days': '4',
      };
    } else {
      // Not need this.
      UserLocation location = UserLocation();
      await location.determinePosition();
      String fullLocation = '${location.latitude},${location.longitude}';
      parameters = {
        'key': Constants.WEATHER_APP_ID,
        'q': fullLocation,
        'days': '4',
      };
    }

    final url = _makeUri(Constants.WEATHER_FORECAST_PATH, parameters);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      return WeatherModel.fromJson(jsonResponse);
    } else {
      log('Request failed with status: ${response.statusCode}.');
      throw Exception('Request failed with status: ${response.statusCode}');
    }

  }
}
