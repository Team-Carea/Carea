import 'package:carea/app/common/const/app_colors.dart';
import 'package:carea/app/common/layout/root_tab.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Widget> _onboardingPages = [
    const OnboardingPage(
      image: "asset/img/first.png",
    ),
    const OnboardingPage(
      image: "asset/img/second.png",
    ),
    const OnboardingPage(
      image: "asset/img/third.png",
    ),
    const OnboardingPage(
      image: "asset/img/fourth.png",
    ),
    const OnboardingPage(
      image: "asset/img/fifth.png",
    ),
    const OnboardingPage(
      image: "asset/img/sixth.png",
    ),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _onboardingPages,
      ),
      bottomSheet: _currentPage == _onboardingPages.length - 1
          ? Container(
              height: 60,
              width: double.infinity,
              color: AppColors.white,
              child: TextButton(
                child: const Text(
                  "Start Carea!",
                  style: TextStyle(
                      color: AppColors.darkGreenPrimaryColor, fontSize: 24),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const RootTab()),
                  );
                },
              ),
            )
          : SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      _pageController.animateToPage(
                        _onboardingPages.length - 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.linear,
                      );
                    },
                    child: const Text(
                      "SKIP",
                      style: TextStyle(color: AppColors.darkGreenPrimaryColor),
                    ),
                  ),
                  Row(
                    children: List<Widget>.generate(_onboardingPages.length,
                        (int index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 10,
                        width: (index == _currentPage) ? 30 : 10,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: (index == _currentPage)
                              ? AppColors.yellowPrimaryColor
                              : AppColors.middleGray,
                        ),
                      );
                    }),
                  ),
                  TextButton(
                    onPressed: () {
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.linear);
                    },
                    child: const Text(
                      "NEXT",
                      style: TextStyle(color: AppColors.darkGreenPrimaryColor),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;

  const OnboardingPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
