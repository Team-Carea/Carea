import 'package:carea/app/common/component/chat_list_tile.dart';
import 'package:carea/app/common/const/app_colors.dart';
import 'package:carea/app/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class ChatRoomListScreen extends StatefulWidget {
  const ChatRoomListScreen({super.key});

  @override
  State<ChatRoomListScreen> createState() => _ChatRoomListScreenState();
}

class _ChatRoomListScreenState extends State<ChatRoomListScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppBar(
        title: const Text('채팅'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Card(
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
                    Image.asset(
                      'asset/img/jinyrobot.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: const [ChatRoomTile()],
            ),
          ),
        ],
      ),
    );
  }
}
