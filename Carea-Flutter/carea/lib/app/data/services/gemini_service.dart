import 'package:carea/app/data/models/gemini_data_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<GeminiResponseModel> generateRandomSentence() async {
  var dio = Dio();

  String geminiApiKey = dotenv.get("GEMINI_API_KEY");
  final url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro:generateContent?key=$geminiApiKey';
  final data = GeminiRequestModel().toJson();

  try {
    final response = await dio.post(url, data: data);

    if (response.statusCode == 200) {
      // JSON 응답에서 'text'를 추출하여 ResponseModel 객체를 생성
      return GeminiResponseModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load data: $e');
  }
}
