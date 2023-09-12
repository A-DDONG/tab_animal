// import 'package:flutter/material.dart';
// import 'package:tab_animal/game/walking_game.dart';
// import 'package:tab_animal/sprite/constants/all_constants.dart';
// import 'package:tab_animal/sprite/overlays/widgets/direction_button.dart';

// class ButtonOverlay extends StatelessWidget {
//   final WalkingGame game;
//   const ButtonOverlay({Key? key, required this.game}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height - 150,
//       width: MediaQuery.of(context).size.width,
//       child: Column(
//         children: [
//           Expanded(child: Container()),
//           Row(
//             children: [
//               Expanded(child: Container()),
//               DirectionButton(
//                 iconData: Icons.arrow_drop_up,
//                 onPressed: () {
//                   game.direction = WalkingDirection.up;
//                 },
//               ),
//               const SizedBox(height: 50, width: 50)
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(child: Container()),
//               DirectionButton(
//                 iconData: Icons.arrow_left,
//                 onPressed: () {
//                   game.direction = WalkingDirection.left;
//                 },
//               ),
//               DirectionButton(
//                 iconData: Icons.pause,
//                 onPressed: () {
//                   game.direction = WalkingDirection.idle;
//                 },
//               ),
//               DirectionButton(
//                 iconData: Icons.arrow_right,
//                 onPressed: () {
//                   game.direction = WalkingDirection.right;
//                 },
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(child: Container()),
//               DirectionButton(
//                 iconData: Icons.arrow_drop_down,
//                 onPressed: () {
//                   game.direction = WalkingDirection.down;
//                 },
//               ),
//               const SizedBox(height: 50, width: 50),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
