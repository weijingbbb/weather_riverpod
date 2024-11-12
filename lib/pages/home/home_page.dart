import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_riverpod/constants/constants.dart';
import 'package:weather_riverpod/extensions/async_value_xx.dart';
import 'package:weather_riverpod/models/current_weather/app_weather.dart';
import 'package:weather_riverpod/models/current_weather/current_weather.dart';
import 'package:weather_riverpod/models/custom_error/custom_error.dart';
import 'package:weather_riverpod/pages/home/providers/theme_provider.dart';
import 'package:weather_riverpod/pages/home/providers/theme_state.dart';
import 'package:weather_riverpod/pages/home/providers/weather_provider.dart';
import 'package:weather_riverpod/pages/home/widgets/error_dialog.dart';
import 'package:weather_riverpod/pages/home/widgets/show_weather.dart';
import 'package:weather_riverpod/pages/search/search_page.dart';
import 'package:weather_riverpod/pages/temp_settings/temp_settings_page.dart';
import 'package:weather_riverpod/services/providers/weather_api_services_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? city;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getInitialLocation();
  }

  void showGeolocationError(String errorMessage) {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$errorMessage using $kDefaultLocation'),
          ),
        );
      }
    });
  }

  Future<bool> getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      showGeolocationError('位置服务被禁用');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        showGeolocationError('位置权限被拒绝');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      showGeolocationError('无法请求权限，因为位置权限被永久拒绝。');
      return false;
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
  }

  void getInitialLocation() async {
    final bool permitted = await getLocationPermission();
    print('getInitialLocation----$permitted');
    if (permitted) {
      try {
        setState(() => loading = true);
        final pos = await Geolocator.getCurrentPosition();
        city = await ref
            .read(weatherApiServicesProvider)
            .getReverseGeocoding(pos.latitude, pos.longitude);
      } catch (e) {
        city = kDefaultLocation;
      } finally {
        setState(() => loading = false);
      }
    } else {
      city = kDefaultLocation;
    }
    ref.read(weatherProvider.notifier).fetchWeather(city!);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<CurrentWeather?>>(
      weatherProvider,
      (previous, next) {
        next.whenOrNull(
          data: (CurrentWeather? currentWeather) {
            if (currentWeather == null) {
              return;
            }
            final weather = AppWeather.fromCurrentWeather(currentWeather);
            if (weather.temp < kWarmOrNot) {
              ref.read(themeProvider.notifier).changeTheme(const DarkTheme());
            } else {
              ref.read(themeProvider.notifier).changeTheme(const LightTheme());
            }
          },
          error: (error, stackTrace) {
            errorDialog(context, (error as CustomError).errMsg);
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
