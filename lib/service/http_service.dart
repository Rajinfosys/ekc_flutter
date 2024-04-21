import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:ekc_scan/presentation/auth/controller/auth_controller.dart';

import '../core/utils/log_util.dart';
import '../core/utils/storage_util.dart';
import 'package:dio/io.dart';

Dio createDio({required String baseUrl, bool trustSelfSigned = false}) {
  // initialize dio
  final dio = Dio()..options.baseUrl = baseUrl;

  // allow self-signed certificate
  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => trustSelfSigned;
    return client;
  };

  return dio;
}

class HttpService {
  static final HttpService instance = HttpService._internal();

  HttpService._internal();

  // static var _baseUrl = 'http://rajwin.dyndns.org:8092/scriptcase/app/ekc_qc';
  static var _baseUrl = 'https://192.168.0.78:8091';
  // static var _baseUrl = AuthController.instance.apiBase.value.text;

  // static dio.Dio _dio = dio.Dio();
  static dio.Dio _dio = createDio(baseUrl: _baseUrl, trustSelfSigned: true);

  final dio.BaseOptions _baseOptions =
      dio.BaseOptions(baseUrl: _baseUrl, headers: {
    'Content-Type': 'application/json',
    'Apitoken':
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYWRtaW4iLCJleHAiOjE3MDcxMTM4MDd9.81c8uR-Vl_kZkCCPZBKT5uJ_lQe8L0zoad_WVsAES2M'
  });

  HttpService.initialize() {
    _dio = dio.Dio(_baseOptions);
  }

  static Future<Map<String, dynamic>> get(
      String path, Map<String, dynamic> params,
      {bool token = false}) async {
    Map<String, dynamic> result = {};
    try {
      final dio.Response response = await _dio.get(path,
          queryParameters: params,
          options: token
              ? dio.Options(headers: {'Apitoken': StorageUtil.getToken()})
              : null);
      if (response.statusCode == 200) {
        result = response.data as Map<String, dynamic>;
      } else {
        LogUtil.error(response.data['message']);
      }
    } catch (e) {
      LogUtil.error(e);
    }
    return result;
  }

  static Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> data,
      {bool token = true}) async {
    Map<String, dynamic> result = {};
    try {
      final dio.Response response = await _dio.post(path,
          data: data,
          options: token
              ? dio.Options(headers: {'Apitoken': StorageUtil.getToken()})
              : null);
      if (response.statusCode == 200) {
        result = response.data as Map<String, dynamic>;
      } else {
        LogUtil.error(response.data['message']);
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
    return result;
  }

  static Future<Map<String, dynamic>> picPost(String path, FormData data,
      {bool token = true}) async {
    Map<String, dynamic> result = {};
    try {
      final dio.Response response = await _dio.post(path,
          data: data,
          options: token
              ? dio.Options(headers: {
                  'Apitoken': StorageUtil.getToken(),
                  'Content-Type': 'multipart/form-data',
                })
              : null);
      if (response.statusCode == 200) {
        result = response.data as Map<String, dynamic>;
      } else {
        LogUtil.error(response.data['message']);
      }
    } catch (e) {
      LogUtil.error(e);
      rethrow;
    }
    return result;
  }
}
