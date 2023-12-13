import 'package:chatapp/model/chatUser.dart';
import 'package:chatapp/model/messageModel.dart';
import 'package:chatapp/res/app_colors.dart';
import 'package:chatapp/res/component/button.dart';
import 'package:chatapp/viewModel/checkUser.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PartnerProfileScreen extends StatefulWidget {
  ChatUser user;
  PartnerProfileScreen({super.key,required this.user});

  @override
  State<PartnerProfileScreen> createState() => _PartnerProfileScreenState();
}

class _PartnerProfileScreenState extends State<PartnerProfileScreen> {
  MessageModel? message;
  bool isTap=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(widget.user.image),),
              SizedBox(height: 30,),
            Text(widget.user.email,style: TextStyle(fontWeight: FontWeight.w200),),
            SizedBox(height: 30,),
            Text(widget.user.about,style: TextStyle(fontWeight: FontWeight.w600),),
            SizedBox(height: MediaQuery.of(context).size.height*0.3,),
            
          ],
            ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        CheckUser.blockUser(widget.user.uid);
        CheckUser.isblocked(widget.user);
      }, label: Text('Block'),icon: Icon(Icons.block_rounded),),
    );
  }
}