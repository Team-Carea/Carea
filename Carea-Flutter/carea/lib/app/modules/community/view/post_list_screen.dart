import 'package:carea/app/common/const/app_colors.dart';
import 'package:carea/app/common/layout/default_layout.dart';
import 'package:carea/app/modules/community/view/create_post_screen.dart';
import 'package:carea/app/modules/community/view/post_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:carea/app/modules/community/controller/community_controller.dart';

class PostListScreen extends StatefulWidget {
  final String pageTitle;

  const PostListScreen({Key? key, required this.pageTitle}) : super(key: key);

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final Posts _posts = Posts();

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  String _mapCategoryToServerFormat(String categoryName) {
    switch (widget.pageTitle) {
      case '경제/금융':
        return 'economic';
      case '진로':
        return 'future';
      case '생활':
        return 'life';
      case '자유 게시판':
        return 'free';
      default:
        '전체 게시판';
        return 'latest';
    }
  }

  Future<void> _fetchPosts() async {
    String serverCategory = _mapCategoryToServerFormat(widget.pageTitle);
    await _posts.fetchAndSetPosts(serverCategory);
    if (mounted) {
      setState(() {
        _posts;
      });
    }
  }

  void _navigateAndCreatePost() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const CreatePostScreen(pageTitle: '전체 게시글')),
    );

    if (result == true) {
      _fetchPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: Center(
          child: Text(widget.pageTitle),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
        elevation: 0,
      ),
      body: DefaultLayout(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          itemCount: _posts.items.length,
          itemBuilder: (BuildContext context, int index) {
            final post = _posts.items[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetail(
                      pageTitle: widget.pageTitle,
                      id: post.id,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      post.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          post.content,
                          style: const TextStyle(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              post.created_at,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.black,
                              ),
                            ),
                            Text(
                              post.nickname,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: AppColors.middleGray,
                    thickness: 1,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateAndCreatePost();
        },
        backgroundColor: AppColors.greenPrimaryColor,
        child: const Icon(
          Icons.add,
          color: AppColors.white,
        ),
      ),
    );
  }
}
