import 'package:get_storage/get_storage.dart';

abstract class StorageUtil {
  static const String _tokenKey = 'token';
  static const String _attendanceIdKey = 'attendance';
  static const String _userDataKey = 'userData';
  static GetStorage storage = GetStorage();

  static String? getToken() {
    if (storage.hasData(_tokenKey)) {
      return storage.read(_tokenKey);
    }
    return null;
  }

  static String? getAttendanceId() {
    if (storage.hasData(_attendanceIdKey)) {
      return storage.read(_attendanceIdKey);
    }
    return null;
  }

  static String? getUserData() {
    if (storage.hasData(_userDataKey)) {
      return storage.read(_userDataKey);
    }
    return null;
  }

  static writeToken(String value) {
    storage.write(_tokenKey, value);
  }

  static writeAttendanceId(String value) {
    storage.write(_attendanceIdKey, value);
  }

  static writeUserData(String value) {
    storage.write(_userDataKey, value);
  }

  static deleteAttendanceId() {
    storage.remove(_attendanceIdKey);
  }

  static deleteToken() {
    storage.remove(_tokenKey);
  }

  static deleteUserData() {
    storage.remove(_userDataKey);
  }
}
