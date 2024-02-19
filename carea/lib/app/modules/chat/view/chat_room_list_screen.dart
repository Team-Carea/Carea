import 'package:carea/app/common/component/chat_list_tile.dart';
import 'package:carea/app/common/const/app_colors.dart';
import 'package:carea/app/common/layout/default_layout.dart';
import 'package:carea/app/data/models/chat_room_list_model.dart';
import 'package:flutter/material.dart';

class ChatRoomListScreen extends StatefulWidget {
  const ChatRoomListScreen({super.key});

  @override
  State<ChatRoomListScreen> createState() => _ChatRoomListScreenState();
}

class _ChatRoomListScreenState extends State<ChatRoomListScreen> {
  @override
  Widget build(BuildContext context) {
    // 테스트 더미데이터
    List<ChatRoom> chatRooms = [
      ChatRoom(
        id: 1,
        help: 1,
        latestMessage: '정현아 자니?',
        opponent: Opponent(
          id: 1,
          nickname: '녕지',
          profileUrl:
              'https://storage.googleapis.com/carea/profile-imgs/kinopio.png',
        ),
      ),
      ChatRoom(
        id: 2,
        help: 1,
        latestMessage: '진영아 나 너무 배가 고파',
        opponent: Opponent(
          id: 1,
          nickname: '임지',
          profileUrl:
              'https://storage.googleapis.com/carea/profile-imgs/kinopio.png',
        ),
      ),
    ];

    return DefaultLayout(
      appbar: AppBar(
        title: const Text('채팅'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: _buildJinyChatBotCard(),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: chatRooms.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(chatRoomInfo: chatRooms[index]);
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildJinyChatBotCard() {
    return Card(
      color: AppColors.faintGray,
      shadowColor: AppColors.bluePrimaryColor,
      surfaceTintColor: AppColors.bluePrimaryColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '고민 상담이나, 편안한 대화가 필요할 때,',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  'Jiny와 대화를 나눠 보세요!',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_circle_right_outlined,
              size: 30,
            ),
            Image.asset(
              'asset/img/jinyrobot.png',
              width: 50,
              height: 50,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
