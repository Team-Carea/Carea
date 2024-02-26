import 'package:carea/app/common/layout/default_layout.dart';
import 'package:carea/app/modules/chat/view/chat_room_list_screen.dart';
import 'package:carea/app/modules/user/view/login_screen.dart';
import 'package:carea/app/modules/user/view/onboarding_screen.dart';
import 'package:carea/app/modules/help_confirm/view/helper_confirm_screen.dart';
import 'package:carea/app/modules/user/view/splash_screen.dart';
import 'package:carea/app/modules/user/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    const _App(),
  );
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: const SplashScreen(),
    );
  }
}
