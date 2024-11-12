import 'package:dio/dio.dart';

String dioErrorHandler(Response response) {
  final statusCode = response.statusCode;
  final statusMessage = response.statusMessage;

  final String errorMessage = '请求失败 \n\n状态码: $statusCode\n原因: $statusMessage';
  return errorMessage;
}
