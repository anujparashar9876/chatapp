import 'dart:developer';

import 'dart:io';


import 'package:chatapp/Utils/Routes/route_name.dart';
import 'package:chatapp/Utils/utils.dart';
import 'package:chatapp/model/chatUser.dart';
import 'package:chatapp/res/app_colors.dart';
import 'package:chatapp/res/app_string.dart';
import 'package:chatapp/res/component/bottomSheetElement.dart';
import 'package:chatapp/res/component/button.dart';
import 'package:chatapp/res/component/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class CompleteProfileScreen extends StatefulWidget {
  final ChatUser chatuser;
  final User firebaseUser;

  const CompleteProfileScreen({super.key,required this.chatuser ,required this.firebaseUser});

  

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  TextEditingController nameController = TextEditingController();
  File? profilePic;
  


  Future image1() async {
     XFile? selectedImage= await ImagePicker().pickImage(source: ImageSource.camera);
                  if(selectedImage!=null){
                    File convertedFile=File(selectedImage.path);
                    setState(() {
                      profilePic=convertedFile;
                      Navigator.pop(context);
                    });
                    
                    log('Image selected');
                  }
                  else{
                    log('No image selected');
                  }
  }

  Future GalaryPicker() async {
    XFile? selectedImage= await ImagePicker().pickImage(source: ImageSource.gallery);
                  if(selectedImage!=null){
                    File convertedFile=File(selectedImage.path);
                    setState(() {
                      profilePic=convertedFile;
                      Navigator.pop(context);
                    });
                    log('Image selected');
                  }
                  else{
                    log('No image selected');
                  }
  }
  void saveData() async {
    String name = nameController.text.trim();
    nameController.clear();
    Utils.showLoadingDialog(context);
    try {
      if (name != '' && profilePic!=null) {
        UploadTask uploadTask=FirebaseStorage.instance.ref().child("profile_pic").child(widget.chatuser.uid.toString()).putFile(profilePic!);
        TaskSnapshot taskSnapshot=await uploadTask;
        String downloadUrl=await taskSnapshot.ref.getDownloadURL();
        widget.chatuser.name=name;
        widget.chatuser.image=downloadUrl;
        await FirebaseFirestore.instance.collection('users').doc(widget.chatuser.uid).set(widget.chatuser.toMap());
        Navigator.popUntil(context, (route) => route.isFirst);
        log('Data Created!');
        Navigator.pushReplacementNamed(context, RouteName.home,arguments: {
          "chatuser":widget.chatuser,
          "firebaseUser":widget.firebaseUser,
        });
      } else {
        log("Please fill the areas");
      }
      setState(() {
        profilePic=null;
      });
    } catch (ex) {
      log(ex.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    // final picProvider=Provider.of<PicProvider>(context);
    return Scaffold(
      // backgroundColor: AppColors.dark,
      appBar: AppBar(
        title: Text(AppString.completeProfile),
        // backgroundColor: AppColors.theme,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05,vertical: MediaQuery.of(context).size.height*0.1),
          child: Card(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                InkWell(
                      onTap: () async{
                        showModalBottomSheet(context: context, builder: (context){
                          return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Wrap(
                                          children: [
                                            Align(
                                              heightFactor: 5,
                                              child: Container(
                                                height: MediaQuery.of(context).size.height*0.001,
                                                width: MediaQuery.of(context).size.width*0.2,
                                                decoration: BoxDecoration(
                                                color: AppColors.white,
                                                borderRadius: BorderRadius.circular(8),
                                              ),),),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10.0,bottom: 30),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    AppString.profilePic,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  IconButton(icon: profilePic!=null?Icon(Icons.delete):Icon(null),onPressed: () {
                                                    setState(() {
                                                      profilePic = null;
                                                      Navigator.of(context).pop();
                                                    });
                                                  },)
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        // picProvider.Image1(context);
                                                        image1();
                                                      },
                                                      child: ProfileImageSelector(image: Image.asset('assets/camera.png'), title: "Camera")),
                                                  ],
                                                ),
                                                const Padding(padding: EdgeInsets.only(left: 40)),
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        // picProvider.GalaryPicker(context);
                                                        GalaryPicker();
                                                      },
                                                      child: ProfileImageSelector(image: Image.asset('assets/gallery.png'), title: "Gallery"))
                                                  ],
                                                ),
                                                const Padding(padding: EdgeInsets.only(left: 40)),
                                                Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          profilePic=null;
                                                          Navigator.of(context).pop();
                                                        });
                                                      },
                                                      child: ProfileImageSelector(image: Image.asset('assets/close.png'), title: 'Exit'))
                                                  ],
                                                )
                                              ],
                                            ),
                                            const Padding(padding: EdgeInsets.only(bottom: 100)),
                                          ],
                                        ),
                                      );
                        });
                      },
                      child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey,
                      backgroundImage: profilePic!=null?FileImage(profilePic!):null,
                      )
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height*0.025),
                    TextFieldCustom(
                      control: nameController,
                      preIcon: Icons.person,
                      hint: AppString.enterName,
                      labeltext: AppString.name,
                      obsecure: false, validate: null,),
                    
                    SizedBox(height: MediaQuery.of(context).size.height*0.05),
                    SubmitButton(
                      buttonLabel: AppString.save,
                      submitFuction: () => saveData(),
                      col: AppColors.theme,
                    )
              ],),
            ),
          ),
        ),
      ),
    );
  }
}