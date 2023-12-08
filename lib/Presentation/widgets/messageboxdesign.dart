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
            gradient: LinearGradient(
                colors: curruser
                    ? [
                        Color.fromARGB(210, 22, 110, 0),
                        Color.fromARGB(234, 36, 172, 2),
                      ]
                    : [
                        Color.fromARGB(223, 0, 110, 201),
                        Color.fromARGB(255, 0, 70, 128),
                      ]),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: child);
  }
}
