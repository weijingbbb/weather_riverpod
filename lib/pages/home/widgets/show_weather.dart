import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_riverpod/models/current_weather/app_weather.dart';
import 'package:weather_riverpod/models/current_weather/current_weather.dart';
import 'package:weather_riverpod/models/custom_error/custom_error.dart';

import 'format_text.dart';
import 'select_city.dart';
import 'show_icon.dart';
import 'show_temperature.dart';

class ShowWeather extends ConsumerWidget {
  final AsyncValue<CurrentWeather?> weatherState;
  const ShowWeather({
    super.key,
    required this.weatherState,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return weatherState.when(
      skipError: true,
      data: (CurrentWeather? weather) {
        print('***** in data callback');
        if (weather == null) {
          return const SelectCity();
        }
        final appWeather = AppWeather.fromCurrentWeather(weather);
        return ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Text(
              appWeather.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(DateTime.now()).format(context),
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(width: 10.0),
                Text(
                  '(${appWeather.country})',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            const SizedBox(height: 60.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowTemperature(
                  temperature: appWeather.temp,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(width: 20.0),
                Column(
                  children: [
                    ShowTemperature(
                      temperature: appWeather.tempMax,
                      fontSize: 16.0,
                    ),
                    const SizedBox(height: 10),
                    ShowTemperature(
                      temperature: appWeather.tempMin,
                      fontSize: 16.0,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Spacer(),
                ShowIcon(icon: appWeather.icon),
                Expanded(
                  flex: 3,
                  child: FormatText(description: appWeather.description),
                ),
                const Spacer(),
              ],
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        print('***** in error callback');
        if (weatherState.value == null) {
          return const SelectCity();
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              (error as CustomError).errMsg,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
