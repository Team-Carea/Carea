import 'package:carea/app/common/component/toast_popup.dart';
import 'package:carea/app/common/const/app_colors.dart';
import 'package:carea/app/common/layout/default_layout.dart';
import 'package:carea/app/modules/community/controller/community_controller.dart';
import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  final String pageTitle;
  const CreatePostScreen({Key? key, this.pageTitle = '전체 게시글'})
      : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String? _selectedCategory;
  bool _isCategoryFixed = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.pageTitle != '전체 게시글') {
      _selectedCategory = widget.pageTitle;
      _isCategoryFixed = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitPost() async {
    try {
      await createPost(
        _titleController.text,
        _contentController.text,
        _selectedCategory!,
      );
      careaToast(toastMsg: '게시글이 성공적으로 등록되었습니다.');
      Navigator.pop(context, true);
    } catch (e) {
      careaToast(toastMsg: '게시글 등록에 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.clear, color: AppColors.black),
        ),
        title: const Text(
          '새 게시글 작성',
          style: TextStyle(color: AppColors.black),
        ),
        actions: [
          IconButton(
            onPressed: _submitPost,
            icon: const Icon(Icons.check, color: AppColors.black),
          )
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: DefaultLayout(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 30),
                      DropdownButton<String>(
                        underline:
                            Container(height: 0.5, color: AppColors.lightGray),
                        value: _selectedCategory,
                        items: const [
                          DropdownMenuItem<String>(
                              value: 'economic', child: Text('경제/금융')),
                          DropdownMenuItem<String>(
                              value: 'future', child: Text('진로')),
                          DropdownMenuItem<String>(
                              value: 'life', child: Text('생활')),
                          DropdownMenuItem<String>(
                              value: 'free', child: Text('자유 게시판')),
                        ],
                        onChanged: _isCategoryFixed
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                        hint: const Text('카테고리'),
                      ),
                    ],
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 350,
                          child: TextField(
                            controller: _titleController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              hintText: '제목',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                color: AppColors.extraLightGray,
                                fontWeight: FontWeight.bold,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.greenPrimaryColor,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.lightGray,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 350,
                          height: 550,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.faintGray,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.middleGray, width: 1.0),
                            ),
                            child: TextField(
                              controller: _contentController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                hintText: '내용을 작성해주세요.',
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.extraLightGray,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            IconButton(
                              onPressed: () async {},
                              icon: const Icon(
                                Icons.add_a_photo_outlined,
                                color: AppColors.lightGray,
                              ),
                            ),
                          ],
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
