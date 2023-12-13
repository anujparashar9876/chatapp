import 'package:chatapp/model/chatUser.dart';
import 'package:flutter/foundation.dart';

class UserProvider4 with ChangeNotifier{
  ChatUser _user= ChatUser(uid: "", name: "", email: "", about: "", created_at: "", image: "", is_online: false, last_active: "", push_token: "", is_pin: false,isblock: false);

  get user => _user;
  setUser(ChatUser user){
    _user=user;
    notifyListeners();
  }

}