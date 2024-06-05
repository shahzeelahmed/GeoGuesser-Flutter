import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:geo_guessr/views/home_page.dart';

import 'firebase_options.dart';

void main()async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: 
      const MainPage()
      //  WebViewPage(
        
      //   url: Uri.dataFromString(
      //     "<iframe src=\"https://www.google.com/maps/embed?pb=!1m0!3m2!1ses!2ses!4v1475148094565!6m8!1m7!1sF%3A-k265GybRcAQ%2FVH3MDcB3A9I%2FAAAAAAAAQTY%2FXZMeIk5IpDsLeewR7wwFhtS5wd6YqB9Gg!2m2!1d48.872337!2d2.777252!3f307.8785102665392!4f18.611126537609977!5f0.5032736111351279\" width=\"600\" height=\"450\" frameborder=\"0\" style=\"border:0\" allowfullscreen></iframe>"

      //     ),)
    );
  }
}

