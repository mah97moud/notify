import 'package:dio/dio.dart';

class DioHelper {
  static Dio dio;
  DioHelper() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://fcm.googleapis.com',
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAoCRYtaY:APA91bEoaPUQUQJ6VUN8ajjCWoExUKsXCoqr39yyjPTriuVLwuzXFjdZ688vH7OLXsh8rGyYKBcAZlaRnJfwRV4crLIVyl4D6EajcLMQqUPabpPyZSJXzvxhGcxioln4X4YaU6zjO3Bj',
        },
      ),
    );
  }

  static Future<Response> postData({
    path,
    data,
    token,
    query,
  }) async {
    // if (token != null) {
    //   dio.options.headers = {
    //     'Authorization': 'Bearer $token',
    //   };
    // }
    return await dio.post(
      path,
      data: data ?? null,
      queryParameters: query ?? null,
    );
  }
}
