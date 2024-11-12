import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/temp_settings_provider.dart';
import 'providers/temp_settings_state.dart';

class TempSettingsPage extends ConsumerStatefulWidget {
  const TempSettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TempSettingsPageState();
}

class _TempSettingsPageState extends ConsumerState<TempSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('单位设置'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          title: const Text('温度单位'),
          subtitle: const Text('摄氏温度/华氏温度 (Default: 摄氏温度)'),
          trailing: Consumer(
            builder: (context, ref, child) {
              final tempUnit = ref.watch(tempSettingsProvider);
              print(tempUnit);

              return Switch(
                value: switch (tempUnit) {
                  Celsius() => true,
                  Fahrenheit() => false,
                },
                onChanged: (_) {
                  ref.read(tempSettingsProvider.notifier).toggleTempUnit();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
