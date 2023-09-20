import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_animal/provider/animal_provider.dart';

class InventoryWidget extends StatefulWidget {
  final Sprite? inventorySprite;
  final List<Map<String, dynamic>> inventory; // 아이템 목록

  const InventoryWidget(
      {Key? key, this.inventorySprite, required this.inventory})
      : super(key: key);

  @override
  _InventoryWidgetState createState() => _InventoryWidgetState();
}

class _InventoryWidgetState extends State<InventoryWidget> {
  int currentPage = 0; // 현재 페이지
  int? selectedItemIndex; // 선택된 아이템의 인덱스

  @override
  Widget build(BuildContext context) {
    int maxPage = (widget.inventory.length - 1) ~/ 16; // 최대 페이지 계산
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned(
          left: (screenWidth - 160) / 4 - 15, // 화면 중앙에 위치
          top: (screenHeight - 160) / 4, // 화면 중앙에 위치
          child: Container(
            width: 320,
            height: 320,
            color: Colors.red.withOpacity(0.5), // 반투명한 빨간색으로 영역 표시
            child: GestureDetector(
              onTapUp: (TapUpDetails details) {
                // 사용자가 탭한 위치를 가져옵니다.
                final Offset localPosition = details.localPosition;
                print("You tapped at: ${details.localPosition}");

                // 탭한 위치를 사용하여 선택된 아이템의 인덱스를 계산합니다.
                // 이 부분은 인벤토리의 레이아웃에 따라 다를 수 있습니다.
                int row = (localPosition.dy ~/ 80).toInt();
                int col = (localPosition.dx ~/ 80).toInt();
                int index = currentPage * 16 + row * 4 + col;

                if (index < widget.inventory.length) {
                  // 조건 추가
                  setState(() {
                    selectedItemIndex = index;
                  });

                  showDialog(
                    context: context,
                    builder: (context) {
                      // AnimalProvider에서 현재 장착 중인 아이템의 ID를 가져옵니다.
                      int? equippedItemId =
                          Provider.of<AnimalProvider>(context, listen: false)
                              .getEquippedItemId();
                      // 선택한 아이템의 ID를 가져옵니다.
                      int? selectedItemId =
                          widget.inventory[selectedItemIndex!]['id'] as int?;
                      return AlertDialog(
                        title: const Text('아이템 정보'),
                        content: Text(
                          '${widget.inventory[index]['name']}\n공격력: ${widget.inventory[index]['attackPower']}',
                          style: const TextStyle(fontSize: 30),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                selectedItemIndex = null; // 선택 해제
                              });
                            },
                            child: const Text(
                              '확인',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(60, 58, 82, 1.0),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (equippedItemId == selectedItemId) {
                                // 이미 장착 중인 아이템을 선택한 경우
                                Provider.of<AnimalProvider>(context,
                                        listen: false)
                                    .unequipItem();
                              } else {
                                // 새로운 아이템을 선택한 경우
                                Provider.of<AnimalProvider>(context,
                                        listen: false)
                                    .equipItem(
                                        widget.inventory[selectedItemIndex!]);
                              }
                              Navigator.pop(context);
                            },
                            child: Text(
                              equippedItemId == selectedItemId ? '해제' : '장착',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(60, 58, 82, 1.0),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // 아이템 삭제 로직
                              Provider.of<AnimalProvider>(context,
                                      listen: false)
                                  .removeItem(
                                      widget.inventory[selectedItemIndex!]);
                              Navigator.pop(context);
                              setState(() {
                                selectedItemIndex = null; // 선택 해제
                              });
                            },
                            child: const Text(
                              '삭제',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(60, 58, 82, 1.0),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  print("아이템이 없는 칸을 선택했습니다.");
                }
              },
              child: CustomPaint(
                size: const Size(160, 160),
                painter: SpritePainter(
                    widget.inventorySprite!,
                    widget.inventory,
                    currentPage,
                    selectedItemIndex // 선택된 아이템의 인덱스를 전달
                    ),
              ),
            ),
          ),
        ),
        if (currentPage > 0) // 첫 페이지가 아니면 이전 버튼을 보여줍니다.
          Positioned(
            left: screenWidth / 2 - 100, // 화면 중앙을 기준으로 왼쪽에 위치
            top: screenHeight / 2 + 100, // 인벤토리 아래에 위치
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  currentPage--; // 이전 페이지로 이동
                });
              },
              child: const Text("이전 페이지"),
            ),
          ),
        if (currentPage < maxPage) // 마지막 페이지가 아니면 다음 버튼을 보여줍니다.
          Positioned(
            left: screenWidth / 2, // 화면 중앙을 기준으로 오른쪽에 위치
            top: screenHeight / 2 + 100, // 인벤토리 아래에 위치
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  currentPage++; // 다음 페이지로 이동
                });
              },
              child: const Text("다음 페이지"),
            ),
          ),
      ],
    );
  }
}

class SpritePainter extends CustomPainter {
  final Sprite sprite;
  final List<Map<String, dynamic>> inventory;
  final int currentPage;
  final int? selectedItemIndex; // 선택된 아이템의 인덱스

  SpritePainter(
      this.sprite, this.inventory, this.currentPage, this.selectedItemIndex);

  @override
  void paint(Canvas canvas, Size size) {
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        sprite.render(
          canvas,
          position: Vector2(col * 80.0, row * 80.0), // 위치를 조절합니다.
          size: Vector2(80.0, 80.0), // 각 칸의 크기를 조절합니다.
        );
      }
    }

    // 아이템 그리기 (새로운 코드)
    for (int i = currentPage * 16;
        i < (currentPage + 1) * 16 && i < inventory.length;
        i++) {
      Map<String, dynamic> item = inventory[i];
      int? itemIndex = item['index']; //
      if (itemIndex != null) {
        // null check 추가
        int spriteRow = itemIndex ~/ 5;
        int spriteCol = itemIndex % 5;
        print("spriteRow: $spriteRow, spriteCol: $spriteCol");
        print("itemIndex: $itemIndex");

        final itemSprite = Sprite(
          sprite.image,
          srcPosition: Vector2(32.0 * spriteCol.toDouble(),
              160.0 + 32.0 * spriteRow.toDouble()), // 위치를 (0, 160)에서 시작하도록 수정
          srcSize: Vector2(32.0, 32.0),
        );

        print(
            "itemSprite created with srcPosition: ${itemSprite.srcPosition}, srcSize: ${itemSprite.srcSize}");

        // 인벤토리가 4열이므로, 행과 열을 계산합니다.
        int row = (i % 16) ~/ 4; // 페이지 내에서의 행
        int col = (i % 16) % 4; // 페이지 내에서의 열

        // 인벤토리 한 칸의 크기를 80x80으로 설정했다면,
        // 아이템을 중앙에 위치시키기 위해 시작 위치를 조정합니다.
        double startX = col * 80.0 + (80 - 64) / 2; // 중앙에 배치하기 위한 오프셋입니다.
        double startY =
            row * 80.0 + (80 - 64) / 2; // 아이템의 세로 위치도 중앙에 오도록 조정합니다.

        itemSprite.render(
          canvas,
          position: Vector2(startX, startY), // 위치를 중앙으로 조절합니다.
          size: Vector2(64.0, 64.0), // 아이템의 크기를 조절합니다.
        );

        // print("itemSprite rendered at position: ($startX, $startY)");
        // final Paint paint = Paint()
        //   ..color = Colors.red
        //   ..style = PaintingStyle.stroke;
        // canvas.drawRect(
        //     Rect.fromPoints(
        //         Offset(startX, startY), Offset(startX + 64, startY + 64)),
        //     paint);
        // print(
        //     "Drawing item at index $i, row $row, col $col, position ($startX, $startY)");

        if (i == selectedItemIndex) {
          // 선택된 아이템이면 칸의 색을 변경
          final Paint selectedPaint = Paint()
            ..color = Colors.blue.withOpacity(0.5)
            ..style = PaintingStyle.fill;

          double startX = col * 80.0 + (80 - 64) / 2;
          double startY = row * 80.0 + (80 - 64) / 2;

          canvas.drawRect(
            Rect.fromPoints(
              Offset(startX, startY),
              Offset(startX + 64, startY + 64),
            ),
            selectedPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 인벤토리가 변경될 때마다 다시 그립니다.
  }
}
