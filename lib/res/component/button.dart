import 'package:chatapp/res/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SubmitButton extends StatelessWidget {
  String? buttonLabel;
  Function()? submitFuction;
  Color? col;
  SubmitButton({super.key,this.buttonLabel,this.submitFuction,this.col});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: submitFuction,
      child: Container(
        width: MediaQuery.of(context).size.width*0.9,
        height: MediaQuery.of(context).size.height*0.05,
        decoration: BoxDecoration(
          color: col,
          borderRadius: BorderRadius.circular(25)
        ),
        
        child: Center(child: Text('$buttonLabel',style: TextStyle(color: AppColors.white),)), 
        ),
    );
  }
}