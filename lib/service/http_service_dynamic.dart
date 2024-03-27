import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import '../core/utils/log_util.dart';
import '../core/utils/storage_util.dart';

class HttpServiceDynamic {
  static final HttpServiceDynamic _instance = HttpServiceDynamic._internal();

  HttpServiceDynamic._internal();

  static dio.Dio _dio = dio.Dio();

  HttpServiceDynamic.initialize(String baseUrl) {
    _dio = dio.Dio(_baseOptions(baseUrl));
  }

  dio.BaseOptions _baseOptions(baseUrl) =>
      dio.BaseOptions(baseUrl: baseUrl, headers: {
        'Content-Type': 'application/json',
        'Apitoken':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYWRtaW4iLCJleHAiOjE3MDcxMTM4MDd9.81c8uR-Vl_kZkCCPZBKT5uJ_lQe8L0zoad_WVsAES2M'
      });

  static Future<Map<String, dynamic>> get(
      String path, Map<String, dynamic> params,
      {bool token = false}) async {
    Map<String, dynamic> result = {};
    try {
      (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient dioClient) {
        dioClient.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        return dioClient;
      };
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
      (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient dioClient) {
        dioClient.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        return dioClient;
      };
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
      (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient dioClient) {
        dioClient.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        return dioClient;
      };
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
