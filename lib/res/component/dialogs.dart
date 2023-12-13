import 'package:chatapp/Utils/Routes/route_name.dart';
import 'package:chatapp/model/chatUser.dart';
import 'package:flutter/material.dart';

class DialogAlert extends StatelessWidget {
  final ChatUser user;
  const DialogAlert({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      contentPadding: EdgeInsets.all(0),
      content: Container(
        
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          Container(decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
          ),
              height: 20,
              width: double.maxFinite,
              child:Center(child: Text(user.name,style: TextStyle(color: Colors.white),))),
          Container(
            
            child: Image.network(user.image,scale:0.1,)),
          Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30))
              ),
              height: 50,
              width: double.maxFinite,
              child: Center(child: IconButton(onPressed: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteName.partner,arguments: {
                    "user":user
                  });
              }, icon: Icon(Icons.info,color: Colors.white,))),),
        ],),
      )
      
    );
  }
}