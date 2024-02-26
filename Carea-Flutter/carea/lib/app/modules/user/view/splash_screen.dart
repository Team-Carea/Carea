import 'package:carea/app/common/layout/default_layout.dart';
import 'package:carea/app/common/layout/root_tab.dart';
import 'package:carea/app/common/util/auth_storage.dart';
import 'package:carea/app/modules/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void checkToken() async {
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    // AuthStorage.delAccessToken(); // 회원가입 api 연결을 위한 임시 토큰 삭제 코드

    if (accessToken == null || refreshToken == null) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } else {
      // 두가지 토큰이 전부 존재할 경우
      // TODO: 실제로는 일치 여부 확인까지 필요함
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const RootTab()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset('asset/svg/carea_logo.svg'),
          ),
        ],
      ),
    );
  }
}
