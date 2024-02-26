import 'package:carea/app/common/component/progress_bar.dart';
import 'package:carea/app/common/const/app_colors.dart';
import 'package:carea/app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class MypageScreen extends StatelessWidget {
  const MypageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
        centerTitle: true,
        elevation: 0,
      ),
      body: const DefaultLayout(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '젤리',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '안녕하세요 반가워요~',
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 50),
                  ExpBar(
                    exp: 0.5,
                  ),
                  SizedBox(height: 50),
                  Text(
                    '설정',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 20),
                  SettingButton(
                    text: 'Carea 이용 가이드',
                    iconData: Icons.keyboard_arrow_right_rounded,
                  ),
                  SizedBox(height: 20),
                  SettingButton(
                    text: '프로필 변경',
                    iconData: Icons.keyboard_arrow_right_rounded,
                  ),
                  SizedBox(height: 20),
                  SettingButton(
                    text: '커뮤니티 이용규칙',
                    iconData: Icons.keyboard_arrow_right_rounded,
                  ),
                  SizedBox(height: 20),
                  SettingButton(
                    text: '알림 설정',
                    iconData: Icons.keyboard_arrow_right_rounded,
                  ),
                  SizedBox(height: 20),
                  SettingButton(
                    text: '로그아웃',
                  ),
                  SizedBox(height: 20),
                  SettingButton(
                    text: '회원 탈퇴',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingButton extends StatelessWidget {
  final String text;
  final IconData? iconData;

  const SettingButton({
    super.key,
    required this.text,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
            fixedSize: const Size(350, 50),
            side:
                const BorderSide(color: AppColors.yellowPrimaryColor, width: 1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )),
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ));
  }
}
