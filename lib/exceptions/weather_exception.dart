class WeatherException implements Exception {
  String message;
  WeatherException([this.message = '出了点问题...']) {
    message = '天气异常: $message';
  }

  @override
  String toString() {
    return message;
  }
}
