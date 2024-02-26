class GeminiRequestModel {
  Map<String, dynamic> toJson() {
    return {
      "contents": [
        {
          "parts": [
            {"text": "감사하다는 의미를 담은 짧은 문장을 딱 하나만 만들어줘. 이 문장은 높임말을 사용해야돼."}
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.6,
        "topK": 1,
        "topP": 1,
        "maxOutputTokens": 2048,
        "stopSequences": []
      },
      "safetySettings": [
        {
          "category": "HARM_CATEGORY_HARASSMENT",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
          "category": "HARM_CATEGORY_HATE_SPEECH",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
          "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
          "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
          "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        }
      ]
    };
  }
}

class GeminiResponseModel {
  final String text;

  GeminiResponseModel({required this.text});

  factory GeminiResponseModel.fromJson(Map<String, dynamic> json) {
    return GeminiResponseModel(
      text: json['candidates'][0]['content']['parts'][0]['text'],
    );
  }
  factory GeminiResponseModel.fromWebSocketJson(Map<String, dynamic> json) {
    return GeminiResponseModel(
      text: json['message'],
    );
  }
}
