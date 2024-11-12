import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_riverpod/constants/constants.dart';
import 'package:weather_riverpod/models/current_weather/app_weather.dart';
import 'package:weather_riverpod/pages/home/providers/theme_provider.dart';
import 'package:weather_riverpod/pages/home/providers/theme_state.dart';
import 'package:weather_riverpod/pages/home/providers/weather_provider.dart';
import 'package:weather_riverpod/pages/home/widgets/error_dialog.dart';
import 'package:weather_riverpod/pages/home/widgets/show_weather.dart';
import 'package:weather_riverpod/pages/search/search_page.dart';
import 'package:weather_riverpod/pages/temp_settings/temp_settings_page.dart';

import 'providers/weather_state.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? city;

  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(const Duration(seconds: 1), () {
  //     ref.read(weatherProvider.notifier).fetchWeather('London');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // Async Value------------------------
    // ref.listen<AsyncValue<CurrentWeather?>>(
    //   weatherProvider,
    //   (previous, next) {
    //     next.whenOrNull(
    //       data: (CurrentWeather? currentWeather) {
    //         if (currentWeather == null) {
    //           return;
    //         }
    //         final weather = AppWeather.fromCurrentWeather(currentWeather);
    //         if (weather.temp < kWarmOrNot) {
    //           ref.read(themeProvider.notifier).changeTheme(const DarkTheme());
    //         } else {
    //           ref.read(themeProvider.notifier).changeTheme(const LightTheme());
    //         }
    //       },
    //       error: (error, stackTrace) {
    //         errorDialog(context, (error as CustomError).errMsg);
    //       },
    //     );
    //   },
    // );
    // 密封类----------------------------
    // ref.listen<WeatherState>(
    //   weatherProvider,
    //   (previous, next) {
    //     switch (next) {
    //       case WeatherStateFailure(error: CustomError error):
    //         errorDialog(context, error.errMsg);
    //       case WeatherStateSuccess(
    //           currentWeather: CurrentWeather currentWeather
    //         ):
    //         final weather = AppWeather.fromCurrentWeather(currentWeather);

    //         if (weather.temp < kWarmOrNot) {
    //           ref.read(themeProvider.notifier).changeTheme(const DarkTheme());
    //         } else {
    //           ref.read(themeProvider.notifier).changeTheme(const LightTheme());
    //         }
    //       case _:
    //     }
    //   },
    // );
    // 枚举-----------------------------
    ref.listen<WeatherState>(
      weatherProvider,
      (previous, next) {
        switch (next.status) {
          case WeatherStatus.failure:
            errorDialog(context, next.error.errMsg);
          case WeatherStatus.success:
            final weather = AppWeather.fromCurrentWeather(next.currentWeather!);

            if (weather.temp < kWarmOrNot) {
              ref.read(themeProvider.notifier).changeTheme(const DarkTheme());
            } else {
              ref.read(themeProvider.notifier).changeTheme(const LightTheme());
            }
          case _:
        }
      },
    );

    final weatherState = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('小魏天气'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TempSettingsPage(),
                ),
              );
            },
          ),
          IconButton(
            onPressed: () async {
              city = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
              print('searchpage传递过来的城市名---: $city');
              if (city != null) {
                ref.read(weatherProvider.notifier).fetchWeather(city!);
              }
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ShowWeather(weatherState: weatherState),
      floatingActionButton: FloatingActionButton(
        onPressed: city == null
            ? null
            : () {
                ref.read(weatherProvider.notifier).fetchWeather(city!);
              },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
