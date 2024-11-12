import 'package:flutter_riverpod/flutter_riverpod.dart';

// 扩展AsyncValue
extension AsyncValueXX on AsyncValue {
  String get toStr {
    final content = [
      if (isLoading && this is! AsyncLoading) 'isLoading: $isLoading',
      if (hasValue) 'value: $value',
      if (hasError) ...[
        'error: $error',
      ]
    ].join(', ');
    return '$runtimeType($content)';
  }

  String get props {
    return '是否loading: $isLoading, 是否刷新: $isRefreshing, 是否重载: $isReloading\n有值: $hasValue, 有错: $hasError';
  }
}
