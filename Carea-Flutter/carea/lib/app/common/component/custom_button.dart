import 'package:carea/app/common/const/app_colors.dart';
import 'package:carea/app/common/const/styles/app_text_style.dart';
import 'package:carea/app/modules/help_confirm/view/helper_confirm_screen.dart';
import 'package:carea/app/modules/help_confirm/view/seeker_confirm_screen.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final dynamic screenRoute;
  final IconData? icon;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.screenRoute,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: AppColors.greenPrimaryColor,
        foregroundColor: AppColors.darkGreenPrimaryColor,
      ),
      onPressed: screenRoute,
      child: icon == null
          ? Text(
              text,
              style: elevatedBtnTextStyle,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  text,
                  style: elevatedBtnTextStyle,
                ),
                const Spacer(),
                Icon(icon!),
              ],
            ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String text;
  final dynamic screenRoute;

  const CustomTextButton(
      {super.key, required this.text, required this.screenRoute});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        foregroundColor: AppColors.darkGray,
      ),
      onPressed: screenRoute,
      child: Text(
        text,
        style: textBtnTextStyle,
      ),
    );
  }
}

class helpComfirmButton extends StatelessWidget {
  const helpComfirmButton({
    super.key,
    required this.currentUserType,
    required this.roomId,
  });

  final String currentUserType;
  final String roomId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => currentUserType == 'helper'
                ? HelperConfirmScreen(roomId: roomId)
                : SeekerConfirmScreen(roomId: roomId),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.black,
        backgroundColor: AppColors.yellowPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.zero,
      ).copyWith(
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 8)),
      ),
      child: const Text('도움 인증'),
    );
  }
}

class VoiceRecordButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isRecognizing;

  const VoiceRecordButton({
    super.key,
    required this.onPressed,
    required this.isRecognizing,
  });

  @override
  State<VoiceRecordButton> createState() => _VoiceRecordButtonState();
}

class _VoiceRecordButtonState extends State<VoiceRecordButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppColors.redAccentColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(widget.isRecognizing ? Icons.mic : Icons.mic_none,
            color: Colors.white),
        iconSize: 50,
        onPressed: () {
          widget.onPressed(); // 부모 위젯에서 전달받은 onPressed 콜백 실행
        },
      ),
    );
  }
}
