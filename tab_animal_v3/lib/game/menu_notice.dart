import 'package:flutter/material.dart';

class Notice {
  final String title;
  final String content;

  Notice({required this.title, required this.content});
}

class NoticeListScreen extends StatelessWidget {
  final List<Notice> notices = [
    Notice(title: "서버 점검 안내", content: "업데이트를 진행하기 위해 서버 점검 예정"),
    Notice(title: "서버 점검 보상 안내", content: "서버 점검 보상 지급"),
    // ... (더 많은 공지사항)
  ];

  NoticeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
        backgroundColor: const Color.fromRGBO(60, 58, 82, 1.0),
      ),
      body: ListView.builder(
        itemCount: notices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              notices[index].title,
              style: const TextStyle(fontSize: 25),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NoticeDetailScreen(notice: notices[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NoticeDetailScreen extends StatelessWidget {
  final Notice notice;

  const NoticeDetailScreen({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          notice.title,
        ),
        backgroundColor: const Color.fromRGBO(60, 58, 82, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          notice.content,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
