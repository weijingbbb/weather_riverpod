import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_riverpod/constants/constants.dart';
import 'package:weather_riverpod/exceptions/weather_exception.dart';
import 'package:weather_riverpod/models/current_weather/current_weather.dart';
import 'package:weather_riverpod/models/direct_geocoding/direct_geocoding.dart';
import 'package:weather_riverpod/services/dio_error_handler.dart';

class WeatherApiServices {
  final Dio dio;

  WeatherApiServices({required this.dio});

  // 获取位置信息
  Future<DirectGeocoding> getDirectGeocoding(String city) async {
    try {
      final Response response =
          await dio.get('/geo/1.0/direct', queryParameters: {
        'q': city,
        'limit': kLimit,
        'appid': dotenv.env['APPID'],
      });
      if (response.statusCode != 200) {
        throw dioErrorHandler(response);
      }
      if (response.data.isEmpty) {
        throw WeatherException('无法获得$city的位置信息');
      }

      final directGeocoding = DirectGeocoding.fromJson(response.data[0]);

      return directGeocoding;
    } catch (e) {
      rethrow;
    }
  }

  Future<CurrentWeather> getWeather(DirectGeocoding directGeocoding) async {
    try {
      final Response response = await dio.get(
        '/data/2.5/weather',
        queryParameters: {
          'lat': '${directGeocoding.lat}',
          'lon': '${directGeocoding.lon}',
          'units': kUnit,
          'appid': dotenv.env['APPID'],
        },
      );
      if (response.statusCode != 200) {
        throw dioErrorHandler(response);
      }
      final CurrentWeather currentWeather =
          CurrentWeather.fromJson(response.data);
      return currentWeather;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getReverseGeocoding(double lat, double lon) async {
    try {
      final Response response = await dio.get(
        '/geo/1.0/reverse',
        queryParameters: {
          'lat': '$lat',
          'lon': '$lon',
          'units': kUnit,
          'appid': dotenv.env['APPID'],
        },
      );
      if (response.statusCode != 200) {
        throw dioErrorHandler(response);
      }
      final List result = response.data;
      if (result.isEmpty) {
        throw WeatherException('无法获取位置的名称($lat, $lon)');
      }
      final city = result[0]['name'];
      return city;
    } catch (e) {
      rethrow;
    }
  }

}
