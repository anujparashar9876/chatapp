

import 'package:chatapp/Utils/Routes/route_name.dart';
import 'package:chatapp/res/app_colors.dart';
import 'package:chatapp/res/app_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 2000), () {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacementNamed(context, RouteName.home);
      } else {
        Navigator.pushReplacementNamed(context, RouteName.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [
                0.6,
                0.8
              ],
              colors: [
          AppColors.theme.shade900,
          AppColors.theme.shade700,
        ])),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/chatAppLogo.png',
              scale: 0.5,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              AppString.appName,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
