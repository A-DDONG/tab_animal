import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tab_animal/game/animal_select.dart';
import 'package:tab_animal/game/login/login_set.dart';

Future<void> showLoginPopup(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('로그인 방식을 선택해주세요.'),
        actions: [
          TextButton(
            onPressed: () async {
              UserCredential? user = await guestSignIn();
              if (user != null) {
                Navigator.of(context).pop(); // 팝업 닫기
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AnimalSelect()));
              }
            },
            child: const Text('게스트 로그인'),
          ),
          TextButton(
            onPressed: () {
              // 구글 로그인 로직 (나중에 구현)
            },
            child: const Text('구글 로그인'),
          ),
        ],
      );
    },
  );
}
