import 'package:logger/logger.dart';

abstract class LogUtil {
  static final Logger _logger = Logger();

  static error(dynamic message) {
    _logger.e(message.toString());
  }static warning(dynamic message) {
    _logger.w(message.toString());
  }static debug(dynamic message) {
    _logger.d(message.toString());
  }
}
