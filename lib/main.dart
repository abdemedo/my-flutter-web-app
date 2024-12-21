import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/login.dart';
import 'package:flutter_application_2/pages/signup.dart';
import 'package:flutter_application_2/pages/welcome.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(apiKey: 'AIzaSyCzpyn97xFN6K0B9NlzbOxSIhkrf27EbSw', appId: "1:159035146252:web:bea3a415ecd59e04886e29", messagingSenderId: "1", projectId: "simomedo-12d8e"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => const Welcome(),

      },
    );
  }
}
