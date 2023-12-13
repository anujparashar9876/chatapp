import 'package:flutter/material.dart';

class ChatBottomSheetItems extends StatelessWidget {
  final String itemTitle;
  final Icon icon;
  final VoidCallback onTap;
  const ChatBottomSheetItems({super.key,required this.icon,required this.itemTitle,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>onTap(),
      child: Padding(
        padding: const EdgeInsets.only(left:10.0,bottom: 20,top: 10),
        child: Row(children: [
          icon,
          SizedBox(width: 10,),
          Text(itemTitle),  
        ],),
      ),
    );
  }
}