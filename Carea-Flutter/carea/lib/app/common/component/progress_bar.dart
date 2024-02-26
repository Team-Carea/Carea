import 'package:carea/app/common/const/app_colors.dart';
import 'package:carea/app/common/util/layout_utils.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ExpBar extends StatefulWidget {
  final double exp;
  const ExpBar({Key? key, required this.exp}) : super(key: key);

  @override
  State<ExpBar> createState() => _ExpBarState();
}

class _ExpBarState extends State<ExpBar> {
  String userID = '';
  late String percentText;

  @override
  void initState() {
    super.initState();
    percentText = '${(widget.exp * 100).toStringAsFixed(0)}%';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          LinearPercentIndicator(
            alignment: MainAxisAlignment.center,
            width: getScreenWidth(context) * 0.7,
            animation: true,
            lineHeight: 20,
            animationDuration: 1000,
            percent: widget.exp,
            barRadius: const Radius.circular(20),
            center: Text(percentText),
            linearGradient: const LinearGradient(
              colors: <Color>[
                AppColors.greenPrimaryColor,
                AppColors.yellowPrimaryColor
              ],
            ),
          ),
        ],
      ),
    );
  }
}
