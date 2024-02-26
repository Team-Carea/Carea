import 'package:carea/app/common/const/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String> onChanged;

  const CustomTextFormField({
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const baseBorder = UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.lightGray,
        width: 1.0,
      ),
    );

    return TextFormField(
      cursorColor: AppColors.darkGreenPrimaryColor,
      obscureText: obscureText,
      obscuringCharacter: '●',
      autofocus: autofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12),
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: AppColors.middleGray,
          fontSize: 14.0,
        ),
        fillColor: AppColors.inputBgColor,
        filled: false,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: AppColors.darkGreenPrimaryColor,
          ),
        ),
      ),
    );
  }
}
