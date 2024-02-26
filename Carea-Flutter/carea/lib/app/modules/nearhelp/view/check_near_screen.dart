import 'package:carea/app/common/component/progress_bar.dart';
import 'package:carea/app/common/const/app_colors.dart';
import 'package:flutter/material.dart';

class NearHelpCheck extends StatelessWidget {
  final Map<String, dynamic> data;

  const NearHelpCheck({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                color: AppColors.darkGray,
              ),
            ),
            CircleAvatar(
              backgroundColor: AppColors.lightGray,
              radius: 48,
              backgroundImage: NetworkImage(data['profileImageUrl']),
            ),
            const SizedBox(height: 12),
            Text(
              '${data['nickname']}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            const ExpBar(exp: 0.5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                '${data['title']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              '${data['content']}',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.black,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16),
            Text(
              '🏠 ${data['location']}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '⏰ ${data['createdAt']}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text(
                '채팅하기',
                style: TextStyle(fontSize: 16, color: AppColors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
