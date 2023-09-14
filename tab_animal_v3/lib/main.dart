import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_animal/firebase_options.dart';
import 'package:tab_animal/game/title_splash.dart';
import 'package:tab_animal/provider/animal_provider.dart';
import 'package:tab_animal/provider/bgm_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Flame.device.fullScreen();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AnimalProvider()),
        ChangeNotifierProvider(create: (context) => BgmProvider()),
      ],
      child: const TabAnimalApp(),
    ),
  );
}

class TabAnimalApp extends StatelessWidget {
  const TabAnimalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "터치해서 동물 키우기",
      theme: ThemeData(fontFamily: 'Mabinogi'),
      home: const TitleSplash(),
    );
  }
}
