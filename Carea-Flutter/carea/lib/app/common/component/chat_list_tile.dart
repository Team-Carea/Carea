import 'package:carea/app/common/util/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:carea/app/data/models/chat_room_list_model.dart';
import 'package:carea/app/modules/chat/view/chat_room_screen.dart';

class ChatRoomTile extends StatefulWidget {
  final ChatRoom chatRoomInfo;

  const ChatRoomTile({Key? key, required this.chatRoomInfo}) : super(key: key);

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  late String latestMessage;
  late Opponent opponent;
  late DateTime updatedAt;

  @override
  void initState() {
    super.initState();
    latestMessage = widget.chatRoomInfo.latestMessage;
    opponent = widget.chatRoomInfo.opponent;
    updatedAt = widget.chatRoomInfo.updatedAt;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () async {
            // 변경된 chatRoomInfo값을 받기 위해 결과를 기다림
            final updatedLatestMessage = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoomScreen(
                  id: widget.chatRoomInfo.id,
                  opponent: opponent,
                ),
              ),
            );
            // latestMessage가 변경되었을 경우 반영
            if (updatedLatestMessage != null) {
              setState(() {
                latestMessage = updatedLatestMessage.message;
                updatedAt = updatedLatestMessage.createdAt;
              });
            }
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundImage:
                NetworkImage(widget.chatRoomInfo.opponent.profileUrl),
          ),
          title: Text(
            widget.chatRoomInfo.opponent.nickname,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                latestMessage,
                style: const TextStyle(fontSize: 13),
              )
            ],
          ),
          trailing: Text(DataUtils.getTimeFromDateTime(dateTime: updatedAt)),
        ),
        const Divider(
          thickness: 1,
          indent: 14,
          endIndent: 14,
        ),
      ],
    );
  }
}
