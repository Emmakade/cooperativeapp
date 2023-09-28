import 'dart:async';
import 'package:cooperativeapp/util/widget_stacked_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white.withOpacity(0.1),
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.3),
        image: DecorationImage(
            image: AssetImage("assets/moneyBg.jpg"),
            opacity: 0.1,
            fit: BoxFit.cover),
      ),
      child: Center(
        child: Container(
          width: animation.value * 145,
          height: animation.value * 145,
          child: ClipOval(
            child: CircleAvatar(
              radius: 75,
              child: Image.asset(
                'assets/icon.PNG',
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
