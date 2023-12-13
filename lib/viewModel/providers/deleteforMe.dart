import 'package:flutter/material.dart';

class DeleteForMe with ChangeNotifier{
  bool _issender=false;
  bool get isSender=>_issender;
  DeleteMeMessage(){
    _issender=true;
    notifyListeners();
  }
}