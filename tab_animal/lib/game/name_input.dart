import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_animal/game/animal_select.dart';
import 'package:tab_animal/game/main_game.dart';
import 'package:tab_animal/provider/animal_provider.dart';
import 'package:tab_animal/provider/bgm_provider.dart';

class NameInput extends StatefulWidget {
  const NameInput({Key? key}) : super(key: key);

  @override
  _NameInputState createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> {
  TextEditingController nameController = TextEditingController();
  double inputBoxWidth = 200; // 기본 가로 길이
  String displayedName = "";
  bool isNameConfirmed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<BgmProvider>(context, listen: false).playBgm();
    });
  }

  void updateName() {
    final animalProvider = Provider.of<AnimalProvider>(context, listen: false);
    animalProvider.setName(nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    final animalProvider = Provider.of<AnimalProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              "assets/images/select_background.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0, // 위치를 명확히 지정
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/name_inputbox.png",
              fit: BoxFit.fitWidth, // 이미지를 꽉 채우지 않고, 지정한 크기에 맞게 조절
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 50),
                Image.asset(
                  animalProvider.selectedAnimalImage,
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 10),
                if (!isNameConfirmed)
                  SizedBox(
                    width: inputBoxWidth,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: '이름',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            setState(() {
                              isNameConfirmed = true;
                            });
                            updateName();
                          },
                        ),
                      ),
                    ),
                  )
                else
                  Text(
                    "이름: ${animalProvider.name ?? '알 수 없음'}",
                    style: const TextStyle(
                        fontSize: 30, color: Color.fromRGBO(255, 90, 90, 1.0)),
                  ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isNameConfirmed)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainGame()),
                          );
                        },
                        child: const Text('게임 시작'),
                      ),
                    const SizedBox(width: 10),
                    if (isNameConfirmed)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isNameConfirmed = false;
                          });
                        },
                        child: const Text('이름변경'),
                      ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AnimalSelect(),
                        ),
                      );
                    },
                    child: const Text("이전")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
