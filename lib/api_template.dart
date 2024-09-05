import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  ApiResponse({required this.success, this.data, this.error});
}

Future<ApiResponse<T>> fetchDataAndHandleError<T>(
  http.Client client,
  String baseUrl,
  String endpoint,
  String? token, {
  Map<String, dynamic>? body,
  required T Function(Map<String, dynamic>) fromJson,
  Duration timeout = const Duration(seconds: 45),
}) async {
  try {
    var url = baseUrl;
    if (endpoint != 'null' && endpoint != '') {
      url = '$baseUrl/$endpoint';
      log(url);
    }
    final response = await client
        .post(
          Uri.parse(url),
          body: body,
          headers: token == null
              ? null
              : {
                  'Authorization': 'Bearer $token',
                },
        )
        .timeout(timeout); // Apply timeout

    if (response.statusCode == 200) {
      try {
        if (kIsWeb) {
          final jsonData = jsonDecode(response.body);
          final data = fromJson(jsonData);
          return ApiResponse<T>(success: true, data: data);
        } else {
          final data = await Isolate.run(() {
            final jsonData = jsonDecode(response.body);
            return fromJson(jsonData);
          });
          return ApiResponse<T>(success: true, data: data);
        }
      } catch (r) {
        return ApiResponse<T>(success: false, error: '$r');
      }
    } else {
      return ApiResponse<T>(
          success: false,
          error: 'Terjadi kesalahan pada server ${response.statusCode}');
    }
  } on TimeoutException {
    return ApiResponse<T>(
        success: false, error: 'Koneksi internet tidak stabil');
  } on SocketException {
    return ApiResponse<T>(
        success: false, error: 'Koneksi internet tidak tersambung');
  } catch (e) {
    return ApiResponse<T>(success: false, error: '$e');
  }
}

Future<ApiResponse<T>> fetchDataAndHandleErrorGet<T>(
  http.Client client,
  String baseUrl,
  String endpoint,
  String? token, {
  required T Function(Map<String, dynamic>) fromJson,
  Duration timeout = const Duration(seconds: 45),
}) async {
  try {
    log('$baseUrl/$endpoint');
    final response = await client
        .get(
          Uri.parse('$baseUrl/$endpoint'),
          headers: token == null
              ? null
              : {
                  'Authorization': 'Bearer $token',
                },
        )
        .timeout(timeout); // Apply timeout

    if (response.statusCode == 200) {
      try {
        if (kIsWeb) {
          final jsonData = jsonDecode(response.body);
          final data = fromJson(jsonData);
          return ApiResponse<T>(success: true, data: data);
        } else {
          final data = await Isolate.run(() {
            final jsonData = jsonDecode(response.body);
            return fromJson(jsonData);
          });
          return ApiResponse<T>(success: true, data: data);
        }
      } catch (r) {
        return ApiResponse<T>(success: false, error: '$r');
      }
    } else {
      return ApiResponse<T>(
          success: false,
          error: 'Terjadi kesalahan pada server ${response.statusCode}');
    }
  } on TimeoutException {
    return ApiResponse<T>(
        success: false, error: 'Koneksi internet tidak stabil');
  } on SocketException {
    return ApiResponse<T>(
        success: false, error: 'Koneksi internet tidak tersambung');
  } catch (e) {
    return ApiResponse<T>(success: false, error: '$e');
  }
}

Future<ApiResponse<T>> fetchDataAndHandleErrorGambar<T>(
  http.Client client,
  String baseUrl,
  String endpoint,
  String? token, {
  Map<String, String>? body,
  Map<String, dynamic>? gambar,
  required T Function(Map<String, dynamic>) fromJson,
  Duration timeout = const Duration(seconds: 45),
}) async {
  try {
    log('$baseUrl/$endpoint');
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/$endpoint'));

    if (body != null) {
      request.fields.addAll(body);
    }

    if (gambar != null) {
      gambar.forEach((key, value) async {
        if ((value != '') && (value != 'null') && (value != null)) {
          request.files.add(await http.MultipartFile.fromPath(key, value));
        }
      });
    }

    if (token != null) {
      var headers = {
        'Authorization': 'Bearer $token',
      };

      request.headers.addAll(headers);
    }

    http.StreamedResponse response = await request.send().timeout(timeout);

    if (response.statusCode == 200) {
      String hasiljson = await response.stream.bytesToString();
      try {
        final jsonData = jsonDecode(hasiljson);
        final data = fromJson(jsonData);
        return ApiResponse<T>(success: true, data: data);
      } catch (r) {
        return ApiResponse<T>(success: false, error: '$r');
      }
    } else {
      return ApiResponse<T>(
          success: false,
          error: 'Terjadi kesalahan pada server ${response.statusCode}');
    }
  } on TimeoutException {
    return ApiResponse<T>(
        success: false, error: 'Koneksi internet tidak stabil');
  } on SocketException {
    return ApiResponse<T>(
        success: false, error: 'Koneksi internet tidak tersambung');
  } catch (e) {
    return ApiResponse<T>(success: false, error: '$e');
  }
}
