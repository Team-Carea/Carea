import 'package:carea/app/common/const/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

void careaToast({required String toastMsg}) {
  Fluttertoast.showToast(
    msg: toastMsg,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: AppColors.greenPrimaryColor,
    fontSize: 20,
    textColor: AppColors.white,
    toastLength: Toast.LENGTH_SHORT,
  );
}
