import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'temp_settings_state.dart';

part 'temp_settings_provider.g.dart';

@Riverpod(keepAlive: true)
class TempSettings extends _$TempSettings {
  @override
  TempSettingsState build() {
    print('[tempSettingsProvider] 初始化');
    ref.onDispose(() {
      print('[tempSettingsProvider] 销毁');
    });
    return const Celsius();
  }

  void toggleTempUnit() {
    state = switch (state) {
      Celsius() => const Fahrenheit(),
      Fahrenheit() => const Celsius(),
    };
  }
}
