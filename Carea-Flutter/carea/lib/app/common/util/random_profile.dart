import 'dart:math';

String getRandomProfileUrl() {
  List<String> urls = [
    'https://storage.googleapis.com/carea/imgs/profile1.png',
    'https://storage.googleapis.com/carea/imgs/profile2.png',
    'https://storage.googleapis.com/carea/imgs/profile3.png',
    'https://storage.googleapis.com/carea/imgs/profile4.png',
  ];

  Random random = Random();
  int index = random.nextInt(urls.length);

  return urls[index];
}
