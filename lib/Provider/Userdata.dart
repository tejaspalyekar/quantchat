import 'package:flutter/material.dart';
import 'package:quantchat/Data%20Model/Messagedata.dart';

class userdata extends ChangeNotifier {
  String username = "";
  List<Messagedata> msg = [];

  String get usermobileno => username;
  String get msglist => msglist;

  set usermobileno(String name) {
    username = name;
    notifyListeners();
  }
  void setmessage(data) {
    msg.add(data);
    notifyListeners();
  }
}
