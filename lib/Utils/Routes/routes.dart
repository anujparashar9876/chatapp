import 'package:chatapp/Utils/Routes/route_name.dart';
import 'package:chatapp/screen/auth_screens/login_screen.dart';
import 'package:chatapp/screen/auth_screens/signUp_screen.dart';
import 'package:chatapp/screen/chat_screen.dart';
import 'package:chatapp/screen/complete_profile_screen.dart';
import 'package:chatapp/screen/home_screen.dart';
import 'package:chatapp/screen/partner_profile_screen.dart';
import 'package:chatapp/screen/profile.dart';
import 'package:chatapp/screen/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name) {
      case RouteName.splash:
        return MaterialPageRoute(builder: (context)=>SplashScreen());
      case RouteName.home:
      // Map<String,dynamic> home1=settings.arguments as Map<String,dynamic>;
        return MaterialPageRoute(builder: (context)=>HomeScreen(
          ));
      case RouteName.login:
        return MaterialPageRoute(builder: (context)=>LoginScreen());
      case RouteName.signup:
        return MaterialPageRoute(builder: (context)=>SignUpScreen());
      case RouteName.complete:
      Map<String, dynamic> map1 = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
            builder: (context) => CompleteProfileScreen(
                  chatuser: map1['chatuser'],
                  firebaseUser: map1['firebaseUser'],
                ));
      case RouteName.profile:
      Map<String, dynamic> profile = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context)=>ProfileView(user: profile['user'],));
      case RouteName.chat:
          Map<String, dynamic> chat= settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(builder: (context)=>ChatScreen(user: chat['user'],));
      case RouteName.partner:
        Map<String,dynamic> partner=settings.arguments as Map<String,dynamic>;
        return MaterialPageRoute(builder: (context)=>PartnerProfileScreen(user: partner['user']));
      default:
        return MaterialPageRoute(builder: (context){
          return const Scaffold(
            body: Center(child: Text("No Route Found!!"),),
          );
        });
    }
  }
}