import 'package:cartaz/screens/navegation_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//import 'screens/device_list_screen.dart';

Future <void>  main() async{
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
   if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PROFISSIONAL -G',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NavegationScreen(),
      ),
    );
  }
}