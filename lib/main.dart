import 'package:cooperativeapp/calender_carousel.dart';
import 'package:cooperativeapp/login_widget.dart';
import 'package:cooperativeapp/payment_widget.dart';
import 'package:cooperativeapp/request_loan_widget.dart';
import 'package:cooperativeapp/splash_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:cooperativeapp/homepage_widget.dart';
import 'package:flutter/services.dart';

void main() {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //     statusBarColor: Colors.white.withOpacity(0.1),
  //     statusBarBrightness: Brightness.dark,
  //     statusBarIconBrightness: Brightness.dark));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primaryColor: Colors.blue,
        primaryColorDark: Colors.blue,
        brightness: Brightness.light,
//        colorScheme: ColorScheme(
//          primaryVariant: Colors.indigoAccent,
//          secondary: Colors.indigo,
//          secondaryVariant: Colors.lightBlue,
//          surface: Colors.white70,
//          background: Colors.indigoAccent,
//          primary: Colors.indigoAccent,
//          brightness: Brightness.light
//        )
      ),
      initialRoute: '/splashscreen',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new LoginWidget(),
        '/splashscreen': (BuildContext context) => new SplashScreen(),
        '/home': (BuildContext context) => new MyHomePage(),
        '/requestloan': (BuildContext context) => new RequestLoanWidget(),
        '/payment': (BuildContext context) => new PaymentWidget(),
        '/calender': (BuildContext context) => new CarouselCalender(),
      },
    );
  }
}
