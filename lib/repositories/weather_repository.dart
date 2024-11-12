import 'package:weather_riverpod/exceptions/weather_exception.dart';
import 'package:weather_riverpod/models/current_weather/current_weather.dart';
import 'package:weather_riverpod/models/custom_error/custom_error.dart';
import 'package:weather_riverpod/models/direct_geocoding/direct_geocoding.dart';
import 'package:weather_riverpod/services/weather_api_services.dart';

class WeatherRepository {
  final WeatherApiServices weatherApiServices;

  WeatherRepository({required this.weatherApiServices});

  Future<CurrentWeather> getDirectGeocoding(String city) async {
    try {
      final DirectGeocoding directGeocoding =
          await weatherApiServices.getDirectGeocoding(city);
      final CurrentWeather tempWeather =
          await weatherApiServices.getWeather(directGeocoding);
      final CurrentWeather currentWeather = tempWeather.copyWith(
        name: directGeocoding.name,
        sys: tempWeather.sys.copyWith(country: directGeocoding.country),
      );
      return currentWeather;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
