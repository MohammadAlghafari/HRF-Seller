import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helper/network_info.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/splash_provider.dart';
import '../../../utill/images.dart';
import '../auth/auth_screen.dart';
import '../dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    NetworkInfo.checkConnectivity(context);
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(context)
        .then((bool isSuccess) {
      if (isSuccess) {
        Timer(Duration(seconds: 3), () {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => DashboardScreen()));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => AuthScreen()));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Stack(
      clipBehavior: Clip.none,
      children: [
        /*  Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: /* Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : */ Colors.white,
          child: CustomPaint(
            painter: SplashPainter(),
          ),
        ), */
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Images.logo_splash,
                height: 300,
                fit: BoxFit.scaleDown,
                width: 300.0,
              ),
              /* SizedBox(
                height: 30,
              ),
              CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ), */
              /* Text(
                getTranslated('vendor', context), style: titilliumBold.copyWith(
                  color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : ColorResources.WHITE),
              ), */
            ],
          ),
        ),
      ],
    ));
  }
}
