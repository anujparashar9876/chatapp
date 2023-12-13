import 'package:chatapp/Utils/Routes/route_name.dart';
import 'package:chatapp/Utils/Routes/routes.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/res/app_colors.dart';
import 'package:chatapp/viewModel/providers/deleteforMe.dart';
import 'package:chatapp/viewModel/providers/userProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>UserProvider4()),
      ChangeNotifierProvider(create: (_)=>DeleteForMe()),
    ],
    child: MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.theme), 
        // useMaterial3: true,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(
            color: AppColors.white,
          ),
          titleTextStyle: TextStyle(color: AppColors.white,fontWeight: FontWeight.w500,fontSize: 20)
        )
      ),
      initialRoute: RouteName.splash,
      onGenerateRoute: Routes.generateRoute,
      
    ),
    );
  }
}