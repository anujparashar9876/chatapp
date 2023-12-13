import 'dart:developer';
import 'dart:io';

import 'package:chatapp/Utils/Routes/route_name.dart';
import 'package:chatapp/Utils/utils.dart';
import 'package:chatapp/model/chatUser.dart';
import 'package:chatapp/res/component/bottomSheetElement.dart';
import 'package:chatapp/res/firebaseInstance.dart';
import 'package:chatapp/viewModel/checkUser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  final ChatUser user;
  ProfileView({super.key, required this.user});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  String? profilePic;

  Future image1() async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (selectedImage != null) {
      
      setState(() {
        profilePic = selectedImage.path;
        Navigator.pop(context);
      });
      CheckUser.updateProfilePic(File(profilePic!));
      log('Image selected');
    } else {
      log('No image selected');
    }
  }

  Future GalaryPicker() async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        profilePic = selectedImage.path;
        Navigator.pop(context);
      });
      CheckUser.updateProfilePic(File(profilePic!));
      log('Image selected');
    } else {
      log('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      
                      profilePic!=null?ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: Image.file(File(profilePic!),
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                        ),
                      ):
                      
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(widget.user.image),
                        backgroundColor: Colors.teal,
                      ),
                      Positioned(
                          bottom: -3,
                          right: -3,
                          child: MaterialButton(
                            onPressed: () {
                              showBottomsheet1();
                            },
                            elevation: 1,
                            shape: CircleBorder(),
                            color: Colors.white,
                            child: Icon(Icons.edit),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(widget.user.email),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (Value) => CheckUser.info.name = Value ?? '',
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Required Field',
                    decoration: InputDecoration(
                        prefix: Icon(Icons.person),
                        label: Text('Name'),
                        hintText: 'Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (Value) => CheckUser.info.about = Value ?? '',
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Required Field',
                    decoration: InputDecoration(
                        prefix: Icon(Icons.info),
                        label: Text('About'),
                        hintText: 'About',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        CheckUser.updateUserInfo().then((value) =>
                            Utils.showSnackBar(context, 'Update Successful'));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                    ),
                    icon: Icon(Icons.edit),
                    label: Text('Update'),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async{
              await CheckUser.activeStatusUpdate(false);
                await Instances.auth.signOut().then((value)async{
                  Navigator.pop(context);
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, RouteName.login);
                });
            },
            icon: Icon(Icons.logout),
            label: Text('Logout')),
      ),
    );
  }

  void showBottomsheet1() async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Wrap(
              children: [
                Align(
                  heightFactor: 5,
                  child: Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Profile photo",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: profilePic != null
                            ? Icon(Icons.delete)
                            : Icon(null),
                        onPressed: () {
                          setState(() {
                            profilePic = null;
                            Navigator.of(context).pop();
                          });
                        },
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        InkWell(
                            onTap: () {
                              // picProvider.Image1(context);
                              image1();
                            },
                            child: ProfileImageSelector(
                                image: Image.asset('assets/camera.png'), title: "Camera")),
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
                            child: ProfileImageSelector(
                                image: Image.asset('assets/gallery.png'),
                                title: "Gallery"))
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(left: 40)),
                    Column(
                      children: [
                        InkWell(
                            onTap: () {
                              setState(() {
                                profilePic = null;
                                Navigator.of(context).pop();
                              });
                            },
                            child: ProfileImageSelector(
                                image: Image.asset('assets/close.png'), title: 'Exit'))
                      ],
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.only(bottom: 100)),
              ],
            ),
          );
        });
  }
}
