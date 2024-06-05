import 'dart:async';
import 'dart:convert';

import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geo_guessr/models/rooms.dart';
import 'package:geo_guessr/views/home_page.dart';
import 'package:geo_guessr/views/result_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geo_guessr/controllers/calculate.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({
    super.key,
    required this.userName,
    required this.roomId,
  });

  @override
  State<StatefulWidget> createState() => _WebViewPageState();
  final String userName;
  final String roomId;
}

class _WebViewPageState extends State<WebViewPage> {
  Map<LatLng, String> locations = {
    const LatLng(29.976480, 31.131302):
        '<iframe src="https://www.google.com/maps/embed?pb=!4v1713780515206!6m8!1m7!1s7BlPz9qCVDZAq5DuSt6cww!2m2!1d29.97737594710751!2d31.13243064776177!3f49.41358688027938!4f0.10852126443516852!5f0.7820865974627469" width="1000" height="900" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>',
    const LatLng(48.858093, 2.294694):
        '<iframe src="https://www.google.com/maps/embed?pb=!4v1713780798521!6m8!1m7!1s_foGuoy9LgqNN_o4kHTYCw!2m2!1d48.85635257055421!2d2.297596831554245!3f305.6856827836907!4f12.163422230793316!5f0.7820865974627469" width="1000" height="900" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>',
    const LatLng(21.149865842655913, 79.0804846957326):
        '<iframe src="https://www.google.com/maps/embed?pb=!4v1713849275226!6m8!1m7!1sM_zmjGXNNuayxTEDp5szAw!2m2!1d21.14966272145746!2d79.08064656528612!3f3.57809146515325!4f-8.06492312636614!5f0.7820865974627469" width="1000" height="900" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>',
    const LatLng(28.656473, 77.242943):
        '<iframe src="https://www.google.com/maps/embed?pb=!4v1713971034040!6m8!1m7!1sSsXsw7NiyKo_QWdPNal3og!2m2!1d28.65601509158748!2d77.23737594087481!3f109.00633198110953!4f-10.468445829918807!5f0.7820865974627469" width="1000" height="900" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>'
  };

  @override
  void initState() {
    super.initState();
  }

  GoogleMapController? mapController;

  List<Marker> mymarker = [];
  String hint = '';
  int Hints = 1;
  LatLng maplocation = const LatLng(18.922064, 72.834641);
  List<String> places = [
    '<iframe src="https://www.google.com/maps/embed?pb=!4v1713205483817!6m8!1m7!1sCAoSLEFGMVFpcE1oYWVaQ0JndS1pZi1lRDZnbnphcWhtTWRvbHZkNkZ4TlBDdEdZ!2m2!1d21.3376406!2d79.31564379999999!3f184.93757427134977!4f2.475636499051916!5f0.7820865974627469" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>',
    '<iframe src="https://www.google.com/maps/embed?pb=!4v1713207288214!6m8!1m7!1sPzmi2YRzv8qQqdI-CpXNBg!2m2!1d18.92243705462986!2d72.83420818810114!3f143.418246654365!4f7.200695733637076!5f0.7820865974627469" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>'
  ];

  late double _progress;
  LatLng? guessLocation = const LatLng(1, 1);

  _ontapMarker(LatLng point) {
    setState(() {
      print(point);

      mymarker = [];

      mymarker
          .add(Marker(markerId: MarkerId(point.toString()), position: point));

      guessLocation = point;
    });
  }

  int round = 1;
  int locationInd = 0;
  int score = 0;
  void updateScore() {
    setState(() {
      if (locations.length - 1 > locationInd) {
        locationInd++;
        round++;
      }
    });
  }

  int calculateScore(double distance) {
    int Tempscore = 0;
    if (distance < 10) {
      setState(() {
        Tempscore = 100;
      });
    }
    if (distance > 10 && distance < 50) {
      setState(() {
        Tempscore = 80;
      });
    }
    if (distance > 50 && distance < 100) {
      setState(() {
        Tempscore = 60;
      });
    }
    if (distance > 100 && distance < 150) {
      setState(() {
        Tempscore = 40;
      });
    }
    if (distance > 150 && distance < 200) {
      setState(() {
        Tempscore = 20;
      });
    }
    if (distance > 200 && distance < 300) {
      setState(() {
        Tempscore = 10;
      });
    }
    return score += Tempscore;
  }

  bool guessed = false;

  void printFamousPlaces() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Locations')
          .doc('famous places')
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()
            as Map<String, dynamic>; // Casting to Map<String, dynamic>
        data.forEach((key, value) {
          print('$key: $value');
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching document: $e');
    }
  }

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(30, 41, 59, 100),
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              Text(
                'Round: $round',
                style: TextStyle(fontSize: 12, color: Colors.blue.shade400),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: const Text('Get Hint'),
                    onPressed: () async {
                      await getHint(
                          'prompt', '', locations.keys.elementAt(locationInd));
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                backgroundColor: Colors.black,
                                title: const Text(
                                  "Hint",
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: Text(
                                  hint,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green.shade900,
                                          borderRadius:
                                              BorderRadius.circular(9)),
                                      padding: const EdgeInsets.all(14),
                                      child: const Text(
                                        "okay",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ));
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    child: const Text('Guess'),
                    onPressed: guessed == false
                        ? () async {
                            print(score);
                            print(guessed);

                            double lat1 = guessLocation!.latitude;
                            double lon1 = guessLocation!.longitude;
                            double lat2 =
                                locations.keys.elementAt(locationInd).latitude;
                            double lon2 =
                                locations.keys.elementAt(locationInd).longitude;
                            double distance =
                                calculateDistance(lat1, lon1, lat2, lon2);
                            print(
                                'Distance between the two points: ${distance.toStringAsFixed(2)} km');
                            calculateScore(distance);
                            setState(() {
                              score = calculateScore(distance);
                              print(score);
                            });
                            await updatePlayerScoreInRoom(
                                widget.roomId, widget.userName, score);
                            setState(() {
                              guessed = true;
                            });
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      backgroundColor: Colors.black,
                                      title: Text(
                                        "Distance",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      content: Text(
                                        "you were $distance km far from the correct location",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.green.shade900,
                                                borderRadius:
                                                    BorderRadius.circular(9)),
                                            padding: const EdgeInsets.all(14),
                                            child: const Text(
                                              "okay",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                          }
                        : () {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      backgroundColor: Colors.black,
                                      title: Text(
                                        "Error",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      content: Text(
                                        "You Have Already Guessed",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.green.shade900,
                                                borderRadius:
                                                    BorderRadius.circular(9)),
                                            padding: const EdgeInsets.all(14),
                                            child: const Text(
                                              "Exit",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                            ;
                          },
                  ),
                  Text(
                    score.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          guessed = false;
                        });
                        if (locations.length - 1 > locationInd) {
                          updateScore();

                          await webViewController!.loadUrl(
                              urlRequest: URLRequest(
                                  url: WebUri.uri(Uri.dataFromString(
                                      locations.values.elementAt(locationInd),
                                      mimeType: ('text/html')))));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ScoreListView(roomId: widget.roomId),
                              ));
                        }
                      },
                      child: Text(locations.length - 1 > locationInd
                          ? 'Next'
                          : 'Finish'))
                ],
              ),
            ],
          ),
        ),
        body: Column(children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.2,
                width: MediaQuery.of(context).size.width,
                child: Stack(children: [
                  InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(
                        url: WebUri.uri(Uri.dataFromString(
                            locations.values.elementAt(locationInd),
                            mimeType: ('text/html')))),
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                  ),
                  // WebViewWidget(controller: controller),
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 90,
                        color: Colors.black,
                      )
                    ],
                  ),
                ]),
              ),
              Container(
                  height: MediaQuery.of(context).size.height / 2.6,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    markers: Set.from(mymarker),
                    onTap: _ontapMarker,
                    onMapCreated: (GoogleMapController controller) {},
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(10, 10),
                      zoom: 0,
                    ),
                  )),
              // ),
            ],
          )
        ]));
  }

  getHint(String prompt, String model, LatLng location) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
          ''
      },
      body: jsonEncode({
        "messages": [
          {"role": "user", "content": "Give a hint to guess $location"}
        ],
        'model': 'gpt-3.5-turbo',
        'max_tokens': 50,
        'temperature': 0.7
      }),
    );
    setState(() {
      hint = jsonDecode(response.body)['choices'][0]['message']['content'];
    });
  }
}
