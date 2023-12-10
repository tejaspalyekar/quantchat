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
                        const Color.fromARGB(234, 15, 77, 0),
                        const Color.fromARGB(234, 20, 97, 0),
                        const Color.fromARGB(234, 24, 121, 0),
                      ]
                    : [
                        const Color.fromARGB(255, 0, 70, 128),
                        const Color.fromARGB(255, 0, 79, 143),
                        const Color.fromARGB(234, 0, 91, 165),
                      ]),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: child);
  }
}
