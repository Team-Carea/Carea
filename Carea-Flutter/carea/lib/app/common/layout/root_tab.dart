import 'package:carea/app/common/const/app_colors.dart';
import 'package:carea/app/modules/chat/view/chat_room_list_screen.dart';
import 'package:carea/app/modules/community/view/community_screen.dart';
import 'package:carea/app/modules/nearhelp/view/nearhelp_screen.dart';
import 'package:flutter/material.dart';

enum TabItem { community, chat, nearHelp }

class RootTab extends StatefulWidget {
  final TabItem initialTab;

  static String get routeName => '/community';

  const RootTab({
    Key? key,
    this.initialTab = TabItem.community,
  }) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      initialIndex: widget.initialTab.index,
      vsync: this,
    );
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          CommunityScreen(),
          NearhelpScreen(),
          ChatRoomListScreen(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(
          selectedItemColor: AppColors.darkGreenPrimaryColor,
          unselectedItemColor: AppColors.lightGray,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          currentIndex: _tabController.index,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.pending_outlined),
              label: '커뮤니티',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              label: '도움 찾기',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              label: '채팅',
            ),
          ],
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    _tabController.animateTo(index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
