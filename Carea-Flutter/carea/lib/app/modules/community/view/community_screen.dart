import 'package:carea/app/common/component/board_button.dart';
import 'package:carea/app/common/layout/default_layout.dart';
import 'package:carea/app/modules/community/view/post_list_screen.dart';
import 'package:carea/app/modules/user/view/mypage_screen.dart';
import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<String> categories = ['전체 게시판', '자유 게시판', '생활', '경제/금융', '진로'];
  final List<String> subtitles = ['📝', '❤️', '😊', '💵', '🐣'];
  final Map<String, String> categoryMapping = {
    '전체 게시판': 'latest',
    '자유 게시판': 'free',
    '생활': 'life',
    '경제/금융': 'economic',
    '진로': 'future',
  };

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppBar(
        title: const Text(
          '커뮤니티',
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_outlined)),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MypageScreen()),
                );
              },
              icon: const Icon(Icons.person_2_outlined))
        ],
        elevation: 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Spacer(),
          Expanded(
            flex: 5,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return BoardButton(
                    subtitle: subtitles[index],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PostListScreen(pageTitle: categories[index]),
                        ),
                      );
                    },
                    text: categories[index]);
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
