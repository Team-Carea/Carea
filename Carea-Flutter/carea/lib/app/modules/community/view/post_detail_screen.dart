import 'package:carea/app/common/const/app_colors.dart';
import "package:carea/app/common/layout/default_layout.dart";
import 'package:carea/app/data/models/post_model.dart';
import 'package:carea/app/modules/community/controller/community_controller.dart';
import 'package:carea/app/data/models/comment_model.dart';
import 'package:carea/app/modules/community/controller/community_comments_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostDetail extends StatefulWidget {
  const PostDetail({
    Key? key,
    required this.pageTitle,
    required this.id,
  }) : super(key: key);

  final String pageTitle;
  final int id;

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  final Posts _posts = Posts();
  final Comments _comments = Comments();

  Future<Post> _fetchPost() async {
    try {
      final post = await _posts.getPostDetail(widget.id);
      return post;
    } catch (error) {
      throw Exception();
    }
  }

  Future<List<Comment>> _fetchComments() async {
    try {
      return await _comments.fetchComments(widget.id.toString());
    } catch (error) {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
        ),
        title: Text(
          widget.pageTitle,
          style: const TextStyle(color: AppColors.black),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_outlined, color: AppColors.black),
          )
        ],
      ),
      body: DefaultLayout(
        child: FutureBuilder<Post>(
          future: _fetchPost(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading post'));
            } else if (snapshot.data == null) {
              return const Center(child: Text('해당 포스트에 대한 정보가 없습니다.'));
            } else {
              final Post post = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: DefaultLayout(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              SingleChildScrollView(
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(post.profileUrl),
                                    radius: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.nickname,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    post.created_at,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    post.title,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    post.content,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const PostReactions(),
                          const Divider(indent: 10, endIndent: 10),
                          const SizedBox(height: 10),
                          FutureBuilder<List<Comment>>(
                            future: _fetchComments(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Error loading comments');
                              } else {
                                final List<Comment> comments =
                                    snapshot.data ?? [];
                                return CommentWidget(comments: comments);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const CommentMaker(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class PostReactions extends StatelessWidget {
  const PostReactions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 15,
        ),
        OutlinedButton.icon(
          icon: const Icon(CupertinoIcons.ellipses_bubble,
              color: AppColors.greenPrimaryColor, size: 20),
          label: const Text('0'),
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.greenPrimaryColor,
            side: const BorderSide(color: AppColors.greenPrimaryColor),
          ),
        ),
        const SizedBox(width: 20),
        OutlinedButton.icon(
          icon: const Icon(CupertinoIcons.heart,
              color: AppColors.redAccentColor, size: 20),
          label: const Text('2'),
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.redAccentColor,
            side: const BorderSide(color: AppColors.redAccentColor),
          ),
        ),
        const SizedBox(width: 20),
        OutlinedButton.icon(
          icon: const Icon(CupertinoIcons.star,
              color: AppColors.yellowPrimaryColor, size: 20),
          label: const Text('1'),
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.yellowPrimaryColor,
            side: const BorderSide(color: AppColors.yellowPrimaryColor),
          ),
        ),
      ],
    );
  }
}

class CommentWidget extends StatelessWidget {
  final List<Comment> comments;

  const CommentWidget({
    Key? key,
    required this.comments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20),
            Text(
              '댓글',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (BuildContext context, int index) {
            final comment = comments[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(comment.profileUrl),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    // Flexible 위젯 대신 Expanded 사용하여 남은 공간을 모두 채움
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.nickname,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          comment.content,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          comment.created_at,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class CommentMaker extends StatefulWidget {
  const CommentMaker({
    super.key,
  });

  @override
  State<CommentMaker> createState() => _CommentMakerState();
}

class _CommentMakerState extends State<CommentMaker> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() async {
    final String content = _controller.text.trim();
    if (content.isNotEmpty) {
      try {
        // await postComment(postId, content, nickname);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('댓글이 등록되었습니다.')),
        );
        _controller.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('댓글 등록에 실패했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: AppColors.middleGray,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: '댓글을 입력해주세요',
                  border: InputBorder.none,
                ),
                maxLines: 1,
              ),
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: Ink(
              width: 40,
              decoration: const ShapeDecoration(
                color: AppColors.greenPrimaryColor,
                shape: CircleBorder(),
              ),
              child: IconButton(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                icon: const Icon(
                  Icons.send,
                  color: AppColors.white,
                ),
                onPressed: _handleSend,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
