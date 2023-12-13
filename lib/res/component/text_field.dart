import 'package:chatapp/res/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldCustom extends StatelessWidget {
  TextEditingController? control;
  bool obsecure;
  String? hint;
  String? labeltext;
  IconData? preIcon;
  final  validate;
  TextFieldCustom({super.key,this.control,this.hint,this.labeltext,required this.obsecure, required this.validate,this.preIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: control,
      validator: validate,
      textInputAction: TextInputAction.next,
      obscureText: obsecure,
          decoration: InputDecoration(
            prefixIcon: Icon(preIcon),
            prefixIconColor: AppColors.theme,
            filled: true,
            fillColor: AppColors.theme.withOpacity(0.2),
            hintText: hint,
            border: OutlineInputBorder(borderSide: BorderSide(width: 1),borderRadius: BorderRadius.circular(40)),
            label: Text('$labeltext'),
          ),
        );
  }
}