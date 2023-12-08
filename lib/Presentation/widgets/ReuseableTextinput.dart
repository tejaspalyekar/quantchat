import 'package:flutter/material.dart';

class ReuseableTextInputField extends StatefulWidget {
  ReuseableTextInputField(
      {super.key,
      required this.label,
      required this.hint,
      required this.inputController});
  String label;
  String hint;
  TextEditingController? inputController;
  @override
  State<ReuseableTextInputField> createState() =>
      _ReuseableTextInputFieldState();
}

class _ReuseableTextInputFieldState extends State<ReuseableTextInputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.white),
      controller: widget.inputController,
      decoration: InputDecoration(
          labelStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), 
          fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          
          label: Text(widget.label,style: TextStyle(color: Colors.white),),
          hintStyle: TextStyle(color: Colors.white),
          hintText: widget.hint),
    );
  }
}
