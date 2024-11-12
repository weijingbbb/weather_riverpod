import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_riverpod/extensions/async_value_xx.dart';
import 'package:weather_riverpod/models/current_weather/current_weather.dart';
import 'package:weather_riverpod/models/custom_error/custom_error.dart';
import 'package:weather_riverpod/pages/home/providers/weather_provider.dart';
import 'package:weather_riverpod/pages/home/widgets/show_weather.dart';
import 'package:weather_riverpod/pages/search/search_page.dart';

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
    ref.listen<AsyncValue<CurrentWeather?>>(
      weatherProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stackTrace) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text((error as CustomError).errMsg),
                );
              },
            );
          },
        );
      },
    );

    final weatherState = ref.watch(weatherProvider);
    print('homepage----${weatherState.toStr}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('小魏天气'),
        actions: [
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
