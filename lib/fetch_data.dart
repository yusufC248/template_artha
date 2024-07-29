import 'package:dio/dio.dart';

class FetchData {
  Future<Result> apiCall(
    String url,
    String? token,
    Map<String, String>? images,
    Map<String, String>? body,
  ) async {
    Dio dio = Dio();

    try {
      Map<String, dynamic> formDataMap = {};

      Map<String, String> header = {};

      if (token != null) {
        header.addAll({
          'Authorization': 'Bearer $token',
        });
      }

      if (images != null) {
        header.addAll({
          'Content-Type': 'multipart/form-data',
        });
        for (var entry in images.entries) {
          formDataMap[entry.key] = await MultipartFile.fromFile(
            entry.value,
            // filename: entry.value.split('/').last
          );
        }
      }

      if (body != null) {
        formDataMap.addAll(body);
      }

      FormData formData = FormData.fromMap(formDataMap);

      Response response = await dio.post(
        url,
        data: formData,
        options: Options(headers: header),
      );

      if (response.statusCode == 200) {
        // return response.data as Map<String, dynamic>;
        return Result(success: true, data: response.data);
      } else {
        return Result(success: false, error: '${response.statusCode}');
      }
    } catch (e) {
      return Result(success: false, error: '$e');
    }
  }
}

class Result {
  final bool success;
  final Map<String, dynamic>? data;
  final String? error;

  Result({required this.success, this.data, this.error});
}
