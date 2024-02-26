import 'package:carea/app/common/const/app_colors.dart';
import 'package:flutter/material.dart';

class DataUtils {
  static String getTimeFromDateTime({required DateTime dateTime}) {
    return '${getTimeFormat(dateTime.hour)}:${getTimeFormat(dateTime.minute)}';
  }

  static String getTimeFormat(int number) {
    return number.toString().padLeft(2, '0');
  }

  static String getFormattedText(String text) {
    if (text.length > 20) {
      List<String> splitText = [];
      for (int i = 0; i < text.length; i += 20) {
        int end = (i + 20 < text.length) ? i + 20 : text.length;
        splitText.add(text.substring(i, end));
      }
      // 분할된 문자열을 줄바꿈 문자로 연결
      text = splitText.join('\n');
    }
    return text;
  }

  static bool compareTwoSentences(String s1, String s2) {
    // 정규 표현식을 사용하여 구두점과 공백 제거
    String normalize(String sentence) {
      return sentence.replaceAll(RegExp(r'[^\w]'), '').toLowerCase();
    }

    // 정규화된 문자열 비교
    return normalize(s1) == normalize(s2);
  }

  static bool compareTwoKoreanSentences(String s1, String s2) {
    String clean(String input) {
      return input.replaceAll(RegExp('[^가-힣0-9]'), '');
    }

    String cleanedS1 = clean(s1);
    String cleanedS2 = clean(s2);

    // 두 문장 중 짧은 쪽의 길이가 기준
    int minLength = cleanedS1.length < cleanedS2.length
        ? cleanedS1.length
        : cleanedS2.length;
    int matchingCharCount = 0;

    // 두 문장의 글자를 순서대로 비교하여 일치하는 글자 수 세기
    for (int i = 0; i < minLength; i++) {
      if (cleanedS1[i] == cleanedS2[i]) {
        matchingCharCount++;
      }
    }

    // 전체 글자 중 일치하는 글자의 비율을 계산
    double matchingRate = matchingCharCount / minLength;
    // 일치 비율이 80% 이상인지 판단함
    return matchingRate >= 0.8;
  }

  static List<TextSpan> markDifferentWord(String s1, String s2) {
    List<String> words1 = s1.split(' ');
    List<String> words2 = s2.split(' ');
    List<TextSpan> spans = [];

    int maxLength =
        words1.length > words2.length ? words1.length : words2.length;

    for (int i = 0; i < maxLength; i++) {
      if (i < words1.length && (i >= words2.length || words1[i] != words2[i])) {
        spans.add(TextSpan(
            text: '${words1[i]} ',
            style: const TextStyle(
                color: AppColors.redAccentColor,
                fontSize: 17,
                fontWeight: FontWeight.w600)));
      } else if (i < words1.length) {
        spans.add(TextSpan(
            text: '${words1[i]} ',
            style: const TextStyle(
                color: AppColors.black,
                fontSize: 17,
                fontWeight: FontWeight.w500)));
      }
    }

    return spans;
  }
}
