import 'package:carea/app/common/layout/root_tab.dart';
import 'package:carea/app/common/component/custom_button.dart';
import 'package:carea/app/common/component/custom_text_form_field.dart';
import 'package:carea/app/common/const/app_colors.dart';
import 'package:carea/app/common/const/styles/app_text_style.dart';
import 'package:carea/app/common/layout/default_layout.dart';
import 'package:carea/app/common/util/auth_storage.dart';
import 'package:carea/app/common/util/layout_utils.dart';
import 'package:carea/app/common/util/random_profile.dart';
import 'package:carea/app/data/models/user_model.dart';
import 'package:carea/app/data/services/user_service.dart';
import 'package:carea/app/modules/user/view/onboarding_screen.dart';
import 'package:flutter/material.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  String nickname = '';
  String introduction = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    UserService userService = UserService();

    return DefaultLayout(
      appbar: AppBar(
        centerTitle: true,
        title: const Text('회원 가입'),
      ),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: getScreenWidth(context) * 0.01),
                _Title(),
                SizedBox(height: getScreenWidth(context) * 0.18),
                const Text(
                  '닉네임',
                  style: inputTitleTextStyle,
                ),
                CustomTextFormField(
                  hintText: '닉네임을 입력해주세요',
                  onChanged: (String value) {
                    nickname = value;
                  },
                ),
                SizedBox(height: getScreenWidth(context) * 0.04),
                const Text(
                  '자기소개',
                  style: inputTitleTextStyle,
                ),
                CustomTextFormField(
                  hintText: '자기소개를 입력해주세요',
                  onChanged: (String value) {
                    introduction = value;
                  },
                ),
                SizedBox(height: getScreenWidth(context) * 0.04),
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
                  text: '회원 가입하기',
                  screenRoute: () async {
                    User user = User(
                      email: email,
                      password1: password,
                      password2: password,
                      nickname: nickname,
                      profileUrl: getRandomProfileUrl(),
                      introduction: introduction,
                    );

                    final response = await userService.signUp(user);

                    final accessToken = response.accessToken;
                    final refreshToken = response.refreshToken;

                    AuthStorage.saveAccessToken(accessToken);
                    AuthStorage.saveRefreshToken(refreshToken);

                    // 정상 회원가입 -> RootTab 이동
                    if (!mounted) return;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const OnboardingScreen()));
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.01),
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(
          color: AppColors.greenPrimaryColor,
          thickness: 8,
        ),
        SizedBox(height: 6),
        Text(
          '당신을 소개할 수 있는 프로필을 만들어주세요',
          style: descriptionTextStyle,
        )
      ],
    );
  }
}
