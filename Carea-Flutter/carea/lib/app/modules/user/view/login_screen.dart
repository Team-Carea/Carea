import 'package:carea/app/common/component/custom_button.dart';
import 'package:carea/app/common/component/custom_text_form_field.dart';
import 'package:carea/app/common/const/styles/app_text_style.dart';
import 'package:carea/app/common/layout/default_layout.dart';
import 'package:carea/app/common/layout/root_tab.dart';
import 'package:carea/app/common/util/layout_utils.dart';
import 'package:carea/app/data/services/user_service.dart';
import 'package:carea/app/modules/user/view/join_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    UserService userService = UserService();

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: getScreenWidth(context) * 0.06),
                _Title(),
                SizedBox(height: getScreenWidth(context) * 0.08),
                const Text(
                  '이메일',
                  style: inputTitleTextStyle,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요',
                  onChanged: (String value) {
                    email = value;
                  },
                ),
                SizedBox(height: getScreenWidth(context) * 0.04),
                const Text(
                  '비밀번호',
                  style: inputTitleTextStyle,
                ),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                SizedBox(height: getScreenWidth(context) * 0.08),
                CustomElevatedButton(
                  text: '로그인',
                  screenRoute: () async {
                    final isLoggedIn = await userService.logIn(email, password);
                    // 정상 로그인 -> RootTab 이동
                    if (isLoggedIn) {
                      if (!mounted) return;
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RootTab()));
                    }
                  },
                ),
                SizedBox(height: getScreenWidth(context) * 0.01),
                CustomTextButton(
                  text: '아직 회원이 아니신가요? 회원가입',
                  screenRoute: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const JoinScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SvgPicture.asset(
          'asset/svg/carea_logo.svg',
          width: getScreenWidth(context) / 5 * 2,
        ),
        SizedBox(height: getScreenWidth(context) * 0.04),
        const Text(
          "Hello!\nThis is",
          style: titleTextStyle,
        ),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Care a",
              style: careaTitleTextStyle,
            ),
            Text(
              "rea",
              style: titleTextStyle,
            ),
          ],
        ),
        const Text(
          "for you",
          style: titleTextStyle,
        ),
      ],
    );
  }
}
