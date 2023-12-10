import 'package:flutter/material.dart';
import 'package:quantchat/Data%20Model/Messagedata.dart';

// ChangeNotifier class for managing user data and messages
class userdata extends ChangeNotifier {
  // User's username
  String username = "";

  // List to store chat messages
  List<Messagedata> msg = [];

  // Getter for msg
  List<Messagedata> get msglist => msg;

  // Setter for user's mobile number (username)
  set usermobileno(String name) {
    username = name;
    notifyListeners();
  }

  // Method to add a new message to the list
  void setmessage(data) {
    msg.add(data);
    notifyListeners();
  }
}