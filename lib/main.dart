import 'dart:io';
import 'dart:ui';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:financas/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  runApp(Home());
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text('erro: ${snapshot.error.toString()}');
            } else if (snapshot.hasData) {
              return Scaffold(
                backgroundColor: Colors.black,
                body: Splash(),
              );
            } else {}
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
