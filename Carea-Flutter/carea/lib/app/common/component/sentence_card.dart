import 'package:carea/app/common/const/app_colors.dart';
import 'package:flutter/material.dart';

class SentenceCard extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color bgcolor;

  const SentenceCard({
    super.key,
    required this.text,
    required this.bgcolor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: bgcolor,
      shadowColor: AppColors.middleGray,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36),
        child: Text(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
