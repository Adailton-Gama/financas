import 'package:financas/pages/loginPage.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => LoginPage())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 285,
              width: 285,
              decoration: BoxDecoration(
                color: Color.fromRGBO(61, 61, 61, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child:
                  // Image.network(
                  //   'https://i.imgur.com/5E5NDoG.png',
                  //   filterQuality: FilterQuality.high,
                  //   width: 255,
                  //   height: 230,
                  // ),
                  Image.asset(
                'assets/app/logo.png',
                filterQuality: FilterQuality.high,
                width: 255,
                height: 230,
              ),
            ),
            Container(
              child: Image.asset(
                'assets/app/icon-man.png',
                width: 87,
                height: 94,
              ),
            ),
            const Text(
              'CONTROLE FINANCEIRO',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              'ACADEMIA',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              'SUPER TREINO',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
