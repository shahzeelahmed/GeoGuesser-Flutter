import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geo_guessr/controllers/navigate.dart';
import 'package:geo_guessr/views/game_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final userName = TextEditingController();
  final createName = TextEditingController();

  final joinName = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference rooms = FirebaseFirestore.instance.collection('rooms');



  Future<void> createRoom(
    String name,
  ) {
    Map<String, dynamic> initial = {};
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(name)
        .set({'room_name': name, 'isActive': true, 'scores': initial},
            SetOptions(merge: true))
        .then((value) => print("Room Created"))
        .catchError((error) => print("Failed to create room: $error"));
  }

  final String someText = 'Create a room \n'
      'and compete with people around the world';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(30, 41, 59, 100),
        body: Column(
          children: [
         
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'EXPLORE ',
                    style:
                        GoogleFonts.oswald(color: Colors.white, fontSize: 30),
                  ),
                  Text(
                    'THE WORLD',
                    style:
                        GoogleFonts.oswald(color: Colors.white, fontSize: 30),
                  ),
                ],
              ),
              Lottie.asset('assets/Animation - 1713213766077.json',
                  height: 200, width: 200),
            ]),
            CustomPaint(
              foregroundPainter: BorderPainter(),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (ctx) => WebViewPage()));
                },
                child: Container(
                  width: 200,
                  height: 50,
                  child: const Center(
                      child: Text(
                    'Play Now',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  children: [
                    Text(
                      'An Interactive Way',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'To Learn And Compete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                LottieBuilder.asset(
                    height: 200,
                    width: 150,
                    'assets/Animation - 1713215749293.json')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => Dialog(
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text('Room Name'),
                                        
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: createName,
                                            decoration: const InputDecoration(
                                              focusedBorder:
                                                  OutlineInputBorder(),
                                              enabledBorder:
                                                  OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                        
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  await createRoom(
                                                    createName.text,
                                                  ).then((value) =>
                                                      Navigator.pop(context));
                                                },
                                                child: const Text('Submit')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Exit'))
                                          ],
                                        )
                                      ],
                                    )),
                              ));
                    },
                    child: const Text('Create Room')),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => Dialog(
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text('Enter Room Name'),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: joinName,
                                            decoration: const InputDecoration(
                                              focusedBorder:
                                                  OutlineInputBorder(),
                                              enabledBorder:
                                                  OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                        const Text('Enter You Name'),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: userName,
                                            decoration: const InputDecoration(
                                              focusedBorder:
                                                  OutlineInputBorder(),
                                              enabledBorder:
                                                  OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  // await addUser(crea.text).then((value) => Navigator.pop(context));
                                                  await navigateToGamePage(
                                                      context,
                                                      joinName.text,
                                                      userName.text);
                                                },
                                                child: const Text('Submit')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Exit'))
                                          ],
                                        )
                                      ],
                                    )),
                              ));
                    },
                    child: const Text('Join Room')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; 
    double sw = size.width; 
    double th = sh * 0.1; 
    double side = sw * 0.12;

    Paint outerPaint = Paint()
      ..color = const Color(0xFF9600FC)
      ..strokeWidth = th
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint lightTopPaint = Paint()
      ..color = const Color(0XFFD197F9)
      ..style = PaintingStyle.fill;

    Paint lightSmallPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = th * 0.06
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Paint arcPaint = Paint()
      ..color = const Color(0xFF3D0066)
      ..style = PaintingStyle.fill;

    Paint minilinePaint = Paint()
      ..color = const Color(0xFF180029)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = th * 0.06;

    Path outerPath = Path()
      ..moveTo(side, 0)
      ..lineTo(sw - side, 0)
      ..quadraticBezierTo(sw, 0, sw, sh / 2)
      ..quadraticBezierTo(sw, sh, sw - side, sh)
      ..lineTo(side, sh)
      ..quadraticBezierTo(0, sh, 0, sh / 2)
      ..quadraticBezierTo(0, 0, side, 0);

    Path lightTop = Path()
      ..moveTo(-th, sh / 2)
      ..quadraticBezierTo(0, 0, side, -th / 3)
      ..lineTo(sw - side, -th / 3)
      ..quadraticBezierTo(sw, 0, sw + th, sh / 2)
      ..quadraticBezierTo(sw, 0, sw - side, th / 20)
      ..lineTo(side, th / 20)
      ..quadraticBezierTo(0, 0, -th, sh / 2);

    Path lightBottom = Path()
      ..moveTo(-th, sh / 2)
      ..quadraticBezierTo(0, sh, side, sh + th / 3)
      ..lineTo(sw - side, sh + th / 3)
      ..quadraticBezierTo(sw, sh, sw + th, sh / 2)
      ..quadraticBezierTo(sw, sh, sw - side, sh - th / 20)
      ..lineTo(side, sh - th / 20)
      ..quadraticBezierTo(0, sh, -th, sh / 2);

    Path lightSmallTop = Path()
      ..moveTo(side * 0.8, th * 0.3)
      ..lineTo(sw - side * 0.8, th * 0.3);

    Path miniLineTop = Path()
      ..moveTo(side * 0.8, th / 3)
      ..lineTo(sw - side * 0.8, th / 3);

    Path miniLineBottom = Path()
      ..moveTo(side * 0.8, sh + th / 3)
      ..lineTo(sw - side * 0.8, sh + th / 3);

    Path lightSmallBottom = Path()
      ..moveTo(side * 0.8, sh - th * 0.3)
      ..lineTo(sw - side * 0.8, sh - th * 0.3);

    Path leftArc = Path()
      ..moveTo(side, -th / 2)
      ..quadraticBezierTo(0, 0, -th / 2, sh / 2)
      ..quadraticBezierTo(0, sh, side, sh)
      ..quadraticBezierTo(0, sh, 0, sh / 2)
      ..quadraticBezierTo(0, 0, side, -th / 2);

    Path rightArc = Path()
      ..moveTo(sw - side, th / 2)
      ..quadraticBezierTo(sw, 0, sw + th / 2, sh / 2)
      ..quadraticBezierTo(sw, sh, sw - side, sh)
      ..quadraticBezierTo(sw, sh, sw, sh / 2)
      ..quadraticBezierTo(sw, 0, sw - side, th / 2);

    Float64List matrix4 = Float64List.fromList([
      1,
      0,
      0,
      0,
      0,
      0.3,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
    ]);

    canvas.drawShadow(outerPath.transform(matrix4).shift(Offset(0, -sh)),
        const Color(0xFF9600FC), sh, true);
    canvas.drawShadow(outerPath.transform(matrix4).shift(const Offset(0, 0)),
        const Color(0xFF9600FC), sh, true);

    canvas.drawPath(outerPath, outerPaint);
    canvas.drawPath(lightTop, lightTopPaint);
    canvas.drawPath(miniLineTop, minilinePaint);
    canvas.drawPath(miniLineBottom, minilinePaint);
    canvas.drawPath(lightBottom, lightTopPaint);
    canvas.drawPath(lightSmallTop, lightSmallPaint);
    canvas.drawPath(lightSmallBottom, lightSmallPaint);
    canvas.drawPath(leftArc, arcPaint);
    canvas.drawPath(rightArc, arcPaint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
