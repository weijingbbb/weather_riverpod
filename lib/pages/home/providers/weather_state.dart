import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_riverpod/models/current_weather/current_weather.dart';
import 'package:weather_riverpod/models/custom_error/custom_error.dart';

// 密封类-------------------------
// sealed class WeatherState {
//   const WeatherState();
// }

// final class WeatherStateInitial extends WeatherState {
//   const WeatherStateInitial();

//   @override
//   String toString() => 'WeatherStateInitial()';
// }

// final class WeatherStateLoading extends WeatherState {
//   const WeatherStateLoading();

//   @override
//   String toString() => 'WeatherStateLoading()';
// }

// final class WeatherStateSuccess extends WeatherState {
//   final CurrentWeather currentWeather;
//   const WeatherStateSuccess({
//     required this.currentWeather,
//   });

//   @override
//   String toString() => 'WeatherStateSuccess(currentWeather: $currentWeather)';
// }

// final class WeatherStateFailure extends WeatherState {
//   final CustomError error;
//   const WeatherStateFailure({
//     required this.error,
//   });

//   @override
//   String toString() => 'WeatherStateFailure(error: $error)';
// }

// 枚举---------------------------
part 'weather_state.freezed.dart';

enum WeatherStatus {
  initial,
  loading,
  success,
  failure,
}

@freezed
class WeatherState with _$WeatherState {
  const factory WeatherState({
    required WeatherStatus status,
    required CurrentWeather? currentWeather,
    required CustomError error,
  }) = _WeatherState;

  factory WeatherState.initial() {
    return const WeatherState(
      status: WeatherStatus.initial,
      currentWeather: null,
      error: CustomError(),
    );
  }
}
