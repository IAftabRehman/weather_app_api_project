import 'package:flutter/material.dart';
import 'homeScreen.dart';


class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  Future<void> initializeApp() async {
    await Future.delayed(Duration(seconds: 7));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homeScreen()));
  }

  @override
  void initState() {
    super.initState();
    initializeApp();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/gift/splashScreen.gif', width: size.width, height: size.height, fit: BoxFit.fill),
          ],
        ),
      ),
    );
  }
}
