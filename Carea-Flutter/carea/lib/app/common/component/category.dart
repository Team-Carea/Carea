// 서버 연결 전 임시 카테고리 목록

const category = [
  {'text': "전체 게시판"},
  {"text": "자유 게시판"},
  {"text": "경제/금융"},
  {"text": "생활"},
  {"text": "진로"}
];

// comment 댓글

class Comment {
  final String profileImageUrl;
  final String authorName;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.profileImageUrl,
    required this.authorName,
    required this.content,
    required this.timestamp,
  });
}

List<Comment> generateDummyComments() {
  List<Comment> comments = [
    Comment(
      profileImageUrl: 'https://example.com/profile1.jpg',
      authorName: 'User1',
      content: '첫 번째 댓글입니다.',
      timestamp: DateTime.now(),
    ),
    Comment(
      profileImageUrl: 'https://example.com/profile2.jpg',
      authorName: 'User2',
      content: '두 번째 댓글입니다.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Comment(
      profileImageUrl: 'https://example.com/profile3.jpg',
      authorName: 'User3',
      content: '세 번째 댓글입니다.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Comment(
      profileImageUrl: 'https://example.com/profile4.jpg',
      authorName: 'User4',
      content: '네 번째 댓글입니다.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  return comments;
}
