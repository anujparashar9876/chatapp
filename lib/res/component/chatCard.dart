

import 'package:chatapp/Utils/Routes/route_name.dart';
import 'package:chatapp/Utils/utils.dart';
import 'package:chatapp/model/chatUser.dart';
import 'package:chatapp/model/messageModel.dart';
import 'package:chatapp/res/app_colors.dart';
import 'package:chatapp/res/component/dialogs.dart';
import 'package:chatapp/viewModel/checkUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {
  final ChatUser user;
  const ChatCard({super.key, required this.user});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  MessageModel? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onLongPress: () {
          showPinUnpinDialog();
        },
        onTap: () {
          Navigator.pushNamed(context, RouteName.chat,
              arguments: {'user': widget.user});
        },
        child: StreamBuilder(
            stream: CheckUser.getlastmessage(widget.user),
            builder: (context, snapshot) {
              final data=snapshot.data?.docs;
              final list=data?.map((e)=>MessageModel.fromMap(e.data())).toList()??[];
              if (list.isNotEmpty) {
                _message=list[0];
              }
              int unreadMessageCount=list.where((_message){
                return _message.fromid!=FirebaseAuth.instance.currentUser!.uid && _message.read.isEmpty;
              }).length;
              return ListTile( 
                leading: InkWell(
                  onTap: () {
                    showDialog(context: context, builder: (_)=>DialogAlert(user: widget.user));
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(widget.user.image),
                  ),
                ),
                title: widget.user.is_pin?Row(
                  children: [
                    Text(widget.user.name),
                    SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                    Icon(Icons.push_pin_outlined,color: AppColors.theme,)
                  ],
                ):Text(widget.user.name),
                subtitle:
                 Text(_message!=null?_message!.type==Type.image?"Image":_message!.message:
                  widget.user.about,
                  maxLines: 1,
                ),
                trailing:_message==null?
                  null:
                  unreadMessageCount>0?
                  Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10))
                      ,
                      child: Center(child: Text(unreadMessageCount.toString())),
                      
                ):Text(Utils.getLastMessageTime(context: context, time:_message!.sent)),
              );
            }),
      ),
    );
  }
  void showPinUnpinDialog() {
 showDialog(
 context: context,
 builder: (context) {
 return AlertDialog(
 title: Text(widget.user.is_pin ? 'Unpin User' : 'Pin User'),
 content: Text(widget.user.is_pin
 ? 'Do you want to unpin this user?'
 : 'Do you want to pin this user?'),
 actions: <Widget>[
 TextButton(
 onPressed: () {
 Navigator.of(context).pop(); // Close the dialog
 },
 child: const Text('Cancel'),
 ),
 TextButton(
 onPressed: () {
 // Toggle the pin status locally
 CheckUser.toggleIsPin(widget.user);

 // Close the dialog
 Navigator.of(context).pop();
 },
 child: Text(widget.user.is_pin ? 'Unpin' : 'Pin'),
 ),
 ],
 );
 },
 );
}
}