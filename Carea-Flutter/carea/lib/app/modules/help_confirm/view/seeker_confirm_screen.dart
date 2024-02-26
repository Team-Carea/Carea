import 'package:carea/app/common/component/custom_button.dart';
import 'package:carea/app/common/component/notice_dialog.dart';
import 'package:carea/app/common/component/sentence_card.dart';
import 'package:carea/app/common/component/toast_popup.dart';
import 'package:carea/app/common/const/app_colors.dart';
import 'package:carea/app/common/const/styles/app_text_style.dart';
import 'package:carea/app/common/layout/default_layout.dart';
import 'package:carea/app/common/util/data_utils.dart';
import 'package:carea/app/common/util/layout_utils.dart';
import 'package:carea/app/data/services/help_confirm_service.dart';
import 'package:carea/app/data/services/stt_service.dart';

import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class SeekerConfirmScreen extends StatefulWidget {
  final String roomId;
  const SeekerConfirmScreen({super.key, required this.roomId});

  @override
  State<SeekerConfirmScreen> createState() => _SeekerConfirmScreenState();
}

class _SeekerConfirmScreenState extends State<SeekerConfirmScreen> {
  late HelpConfirmWebSocketService helpConfirmWebSocketService;
  String receivedSentence = '아직 인증 문장이 없습니다.';
  final SttService _sttService = SttService();
  String recognizedSentence = '아직 녹음한 문장이 없습니다.';
  String? confirmSentence;
  Color recognizedSentenceCardColor = AppColors.faintGray;
  Color receivedSentenceCardColor = AppColors.faintGray;
  bool isRecognizing = false;
  bool isRecognizeFinished = false;
  bool isConfirmed = false;

  @override
  void initState() {
    super.initState();
    helpConfirmWebSocketService = HelpConfirmWebSocketService();
    helpConfirmWebSocketService.initializeWebsocket(widget.roomId);

    // 인증문장 수신 콜백 설정
    helpConfirmWebSocketService.onSentenceResponse = (String sentence) {
      careaToast(toastMsg: '문장 수신이 완료되었습니다.');
      setState(() {
        receivedSentence = DataUtils.getFormattedText(sentence);
        receivedSentenceCardColor = AppColors.lightBlueGray;
      });
    };

    // STT 기능
    _sttService.onRecognizingStarted = () {
      setState(() {
        recognizedSentence = '녹음 중이에요...';
        recognizedSentenceCardColor = AppColors.faintGray;
        isRecognizing = true;
      });
    };
    _sttService.onResultReceived = (resultText) {
      setState(() {
        resultText = DataUtils.getFormattedText(resultText);
        recognizedSentence = resultText;
        isRecognizeFinished = true;
      });
    };
    _sttService.onRecognizingStopped = () {
      setState(() {
        isRecognizing = false;
        isRecognizeFinished = true;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            helpConfirmWebSocketService.dispose();
            Navigator.pop(context);
          },
        ),
        title: const Text('도움 인증'),
        centerTitle: true,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: getScreenHeight(context) * 0.02),
                const Text(
                  '인증 문장',
                  style: screenContentTitleTextStyle,
                ),
                const SizedBox(height: 12),
                // 인증 문장용 카드
                SentenceCard(
                  text: receivedSentence,
                  bgcolor: receivedSentenceCardColor,
                  textStyle: sentenceTextStyle,
                ),
                SizedBox(height: getScreenHeight(context) * 0.05),
                const Text(
                  '인증 문장을 녹음해주세요 💬',
                  style: screenContentTitleTextStyle,
                ),
                const SizedBox(height: 12),
                // 녹음 문장용 카드
                SentenceCard(
                  text: recognizedSentence,
                  bgcolor: recognizedSentenceCardColor,
                  textStyle: sentenceTextStyle,
                ),
                SizedBox(height: getScreenHeight(context) * 0.02),
                CustomElevatedButton(
                  text: '인증하기',
                  screenRoute: isConfirmed ? null : confirmHelp,
                  icon: Icons.check_circle,
                )
              ],
            ),
          ),
          Positioned(
            bottom: getScreenHeight(context) * 0.20,
            left: 0,
            right: 0,
            child: Center(
              child: recordingIndicator(),
            ),
          ),
          Positioned(
            bottom: getScreenHeight(context) * 0.10,
            left: 0,
            right: 0,
            child: Center(
              child: VoiceRecordButton(
                onPressed: toggleRecording,
                isRecognizing: isRecognizing,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void confirmHelp() async {
    HelpConfirmDioService helpConfirmDioService = HelpConfirmDioService();

    setState(() {
      confirmSentence = recognizedSentence;
      recognizedSentenceCardColor = AppColors.faintGray;
      recognizedSentence = '인증 여부 확인 중이에요..👀';
    });

    isConfirmed = DataUtils.compareTwoKoreanSentences(
      receivedSentence,
      confirmSentence!.replaceAll(RegExp(r'\s'), ''),
    );
    if (!isConfirmed) {
      await Future.delayed(const Duration(seconds: 2));
      // 인증 실패
      setState(() {
        recognizedSentence = confirmSentence!;
        recognizedSentenceCardColor = AppColors.yellowPrimaryColor;
      });
      if (!mounted) return;
      showFailureConfirmDialog(context, receivedSentence, recognizedSentence);
    } else {
      // 인증 성공
      // 도움제공자에게 인증완료 메시지 전송
      helpConfirmWebSocketService.sendConfirmation();
      // 경험치 증가 api 호출
      final pointInfo = await helpConfirmDioService.getPoints(widget.roomId);
      if (!mounted) return;

      showSuccessConfirmDialog(
          context, pointInfo.userPoints, pointInfo.increasedPoints);

      setState(() {
        recognizedSentence = confirmSentence!;
        recognizedSentenceCardColor = AppColors.lightBlueGray;
      });
    }
  }

  Future<void> toggleRecording() async {
    if (isRecognizing) {
      // 녹음 중지
      _sttService.stopRecording();
    } else {
      // 녹음 시작
      _sttService.streamingRecognize();
    }
  }

  Widget recordingIndicator() {
    return isRecognizing
        ? Lottie.asset(
            'asset/lottie/recording.json',
            width: 100,
            height: 100,
          )
        : const SizedBox(
            width: 100,
            height: 100,
          );
  }
}
