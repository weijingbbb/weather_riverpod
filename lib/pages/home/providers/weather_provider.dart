import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:weather_riverpod/models/current_weather/current_weather.dart';
import 'package:weather_riverpod/models/custom_error/custom_error.dart';
import 'package:weather_riverpod/repositories/providers/weather_repository_provider.dart';

import 'weather_state.dart';

part 'weather_provider.g.dart';

@riverpod
class Weather extends _$Weather {
  // @override
  // FutureOr<CurrentWeather?> build() {
  //   return Future<CurrentWeather?>.value(null);
  // }

  // Future<void> fetchWeather(String city) async {
  //   state = const AsyncLoading();
  //   state = await AsyncValue.guard(() async {
  //     final currentWeather =
  //         await ref.read(weatherRepositoryProvider).fetchWeather(city);
  //     return currentWeather;
  //   });
  // }
  // ----------------使用密封类进行处理数据------------------
  // @override
  // WeatherState build() {
  //   return const WeatherStateInitial();
  // }

  // Future<void> fetchWeather(String city) async {
  //   state = const WeatherStateLoading();

  //   try {
  //     final CurrentWeather currentWeather =
  //         await ref.read(weatherRepositoryProvider).fetchWeather(city);

  //     state = WeatherStateSuccess(currentWeather: currentWeather);
  //   } on CustomError catch (error) {
  //     state = WeatherStateFailure(error: error);
  //   }
  // }
  // 枚举---------------------------
  @override
  WeatherState build() {
    return WeatherState.initial();
  }

  Future<void> fetchWeather(String city) async {
    state = state.copyWith(status: WeatherStatus.loading);

    try {
      final CurrentWeather currentWeather =
          await ref.read(weatherRepositoryProvider).fetchWeather(city);

      state = state.copyWith(
        status: WeatherStatus.success,
        currentWeather: currentWeather,
      );
    } on CustomError catch (error) {
      state = state.copyWith(
        status: WeatherStatus.failure,
        error: error,
      );
    }
  }
}
