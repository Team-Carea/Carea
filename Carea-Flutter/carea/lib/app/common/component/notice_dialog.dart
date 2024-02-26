import 'package:carea/app/common/component/progress_bar.dart';
import 'package:carea/app/common/const/app_colors.dart';
import 'package:carea/app/common/util/data_utils.dart';
import 'package:carea/app/common/util/layout_utils.dart';
import 'package:flutter/material.dart';

void showSuccessConfirmDialog(
    BuildContext context, int userPoints, int increasedPoints) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(20),
          height: getScreenHeight(context) * 0.28,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 16),
              const Text('✅ 인증되었습니다!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              const Text('도움 인증 경험치',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              Text('+${increasedPoints}xp ✨',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400)),
              const SizedBox(height: 18),
              ExpBar(
                exp: (userPoints > 100)
                    ? (userPoints - 100) * 0.01
                    : userPoints * 0.01,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('확인'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showFailureConfirmDialog(
    BuildContext context, String baseSentence, String comparingSentence) {
  List<TextSpan> highlightedText =
      DataUtils.markDifferentWord(baseSentence, comparingSentence);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 16),
                const Text('💥 다시 시도해보세요!',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Text('인증 문장과 녹음된 문장의 비교 결과:',
                    style: TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 14),
                RichText(
                  text: TextSpan(children: highlightedText),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void showLevelUpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(20),
          height: getScreenHeight(context) * 0.28,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 16),
              const Text('🎉 LEVEL UP 🎉',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
              const Text('✨2✨',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              const ExpBar(exp: 0.0),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('확인'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
