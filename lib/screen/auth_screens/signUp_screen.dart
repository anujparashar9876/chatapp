import 'dart:developer';

import 'package:chatapp/Utils/Routes/route_name.dart';
import 'package:chatapp/Utils/utils.dart';
import 'package:chatapp/model/chatUser.dart';
import 'package:chatapp/res/app_colors.dart';
import 'package:chatapp/res/app_string.dart';
import 'package:chatapp/res/component/button.dart';
import 'package:chatapp/res/component/text_field.dart';
import 'package:chatapp/res/firebaseInstance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  void createAccount() async {
    String email = emailController.text.trim().toString();
    String password = passController.text.trim().toString();
    String confirmPassword = confirmpasswordController.text.trim().toString();

    if (email == "" || password == "" || confirmPassword == "") {
      log('Please fill the Area\'s');
      // UIModel.showAlertDialog(context, "Error", 'Please fill the Fields');
    } else if (password != confirmPassword) {
      log('Password doesn\'t match');
      // UIModel.showAlertDialog(context, "Password Does\'t Match",
          // 'Password & Confirm Password are not match');
    } else {
      UserCredential? userCredential;
      Utils.showLoadingDialog(context);
      try {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (ex) {
        Navigator.pop(context);
        // UIModel.showAlertDialog(context, 'Error', ex.message.toString());
        log(ex.code.toString());
      }
      if (userCredential != null) {
        String uid = userCredential.user!.uid;
        final time = DateTime.now().millisecondsSinceEpoch.toString();
        ChatUser newUser = ChatUser(
          
          uid: uid,
          email: email,
          name: "",
          image: "",
          about: "Availble", 
          created_at: time, 
          is_online: false, 
          last_active: time, 
          push_token: '', 
          blockedUser: [],
          is_pin: false,
          isblock: false
          );
        await Instances.firestore
            .collection('users')
            .doc(uid)
            .set(newUser.toMap());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User Created')));
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacementNamed(context, RouteName.complete, arguments: {
          'chatuser': newUser,
          'firebaseUser': userCredential.user,
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.signup),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/chatAppLogo.png",scale: 0.5,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.05,
                    ),
                    Text(
                      AppString.appName,
                      style: TextStyle(color: AppColors.theme,fontSize: 35,fontWeight: FontWeight.bold)
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.05,
                    ),
                    TextFieldCustom(
                      control: emailController,
                      preIcon: Icons.email_outlined,
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
                      height: MediaQuery.of(context).size.height*0.025,
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
                      height: MediaQuery.of(context).size.height*0.025,
                    ),
                    TextFieldCustom(
                      control: confirmpasswordController,
                      preIcon: Icons.lock,
                      obsecure: true,
                      hint: AppString.cPass,
                      labeltext: AppString.cPass,
                      validate: (value) {
                        if (confirmpasswordController.text.isEmpty) {
                          return 'field must be filled';
                        } else if (confirmpasswordController.text !=
                            passController.text) {
                          return 'Password not Match';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.025,
                    ),
                    SubmitButton(
                      buttonLabel: AppString.signup,
                      col: AppColors.theme,
                      submitFuction: () {
                        createAccount();
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.06,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppString.doAccount,style: TextStyle(fontSize: 17),),
                        CupertinoButton(child: Text(AppString.login), onPressed:() {
                            Navigator.pushNamed(context, RouteName.login);
                          },)
                        
                      ],
                    ),]),
        ),
      ),
    );
  }
}