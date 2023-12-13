import 'dart:developer';

import 'package:chatapp/Utils/Routes/route_name.dart';
import 'package:chatapp/Utils/utils.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/model/chatUser.dart';
import 'package:chatapp/res/app_colors.dart';
import 'package:chatapp/res/app_string.dart';
import 'package:chatapp/res/component/button.dart';
import 'package:chatapp/res/component/text_field.dart';
import 'package:chatapp/res/firebaseInstance.dart';
import 'package:chatapp/viewModel/checkUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  void checkValues() {
    String email = emailController.text.trim();
    String password = passController.text.trim();

    if (email == "" || password == "") {
      print("Please enter login details");
      Utils.showAlertDialog(context, "Error", "Field can't be empty",(){},'');
    } else {
      login(email, password);
    }
  }

  void login(String email, String password) async {
    UserCredential? userCredential;

    Utils.showLoadingDialog(context);

    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // Utils().closeLoader(context);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      Utils.showAlertDialog(
          context, "An error occoured", ex.message.toString(),(){},'');
      print(ex.code.toString());
    }

    if (userCredential != null) {
      String uid = userCredential.user!.uid;
      DocumentSnapshot userData =
          await Instances.firestore.collection('users').doc(uid).get();
      ChatUser chatuser =
          ChatUser.fromMap(userData.data() as Map<String, dynamic>);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamedAndRemoveUntil(
          RouteName.home, (route) => false, arguments: {
        'chatuser': chatuser,
        'firebaseUser': userCredential.user
      });
      print("login sucessfully");
    }
  }

  _handleGooglebtn() {
    Utils.showCircularProgress(context);
    signinWithGoogle().then((user) async {
      // user.
      // debugPrint(user.toString());
      Navigator.pop(context);
      if (user != null) {
        if ((await CheckUser.userExists())) {
          Navigator.pushReplacementNamed(context, RouteName.home);
        } else {
          await CheckUser.createUser().then((value) {
            Navigator.pushReplacementNamed(context, RouteName.home);
          });
        }
      }
    });
  }

  Future<UserCredential?> signinWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
              clientId: DefaultFirebaseOptions.currentPlatform.iosClientId)
          .signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log(e.toString());
      Utils.showSnackBar(context, 'Internet Connection error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.login),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/chatAppLogo.png',
                  scale: 0.5,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
                  AppString.appName,
                  style: TextStyle(
                      color: AppColors.theme,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                // Image.asset("assets/loginLogo.png",scale: 3,),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextFieldCustom(
                  control: emailController,
                  preIcon: Icons.email,
                  obsecure: false,
                  hint: AppString.emailHint,
                  labeltext: AppString.emailLabel,
                  validate: (value) {
                    if (emailController.text.isEmpty ||
                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(emailController.text)) {
                      return 'field must be filled';
                    } else if (!emailController.text.contains('@')) {
                      return "@ is required";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                TextFieldCustom(
                  control: passController,
                  preIcon: Icons.lock,
                  validate: (value) {
                    if (passController.text.isEmpty) {
                      return 'Password is Required';
                    } else if (RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                        .hasMatch(passController.text)) {
                      return 'Invalid Password';
                    } else {
                      return null;
                    }
                  },
                  obsecure: true,
                  hint: AppString.pass,
                  labeltext: AppString.pass,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SubmitButton(
                  buttonLabel: AppString.login,
                  col: AppColors.theme,
                  submitFuction: () {
                    // login();
                    checkValues();
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text('------OR------'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                InkWell(
                  onTap: () {
                    _handleGooglebtn();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/google.png"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text(
                          AppString.googleLogin,
                          style: TextStyle(color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppString.account,
                      style: TextStyle(fontSize: 17),
                    ),
                    CupertinoButton(
                        child: Text(AppString.signup),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, RouteName.signup);
                        }),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
