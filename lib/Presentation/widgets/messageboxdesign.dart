import 'package:flutter/material.dart';

class MessageboxDesign extends StatelessWidget {
  MessageboxDesign({super.key, required this.curruser, required this.child});

  bool curruser;
  Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            color: curruser
                ? Color.fromARGB(181, 185, 255, 176)
                : Color.fromARGB(195, 177, 220, 255),
            borderRadius: const BorderRadius.all(Radius.circular(13))),
        child: child);
  }
}
