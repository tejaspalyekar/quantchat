import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReuseableButton extends StatelessWidget {
  ReuseableButton(
      {super.key,
      required this.fun,
      required this.btncolor,
      required this.btntitle});

  void Function() fun;
  Color btncolor;
  String btntitle;

  @override
  build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(btncolor),
            elevation: const MaterialStatePropertyAll(10)),
        onPressed: fun,
        child: Text(
          btntitle,
          style: GoogleFonts.openSans(
              color: const Color.fromARGB(255, 0, 0, 0), fontSize: 22, fontWeight: FontWeight.w500),
        ));
  }
}
