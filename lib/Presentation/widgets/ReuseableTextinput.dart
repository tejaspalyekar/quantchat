import 'package:flutter/material.dart';

class ReuseableTextInputField extends StatefulWidget {
  ReuseableTextInputField(
      {super.key,
      required this.hide,
      required this.label,
      required this.hint,
      required this.inputController});
  bool hide;
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
      controller: widget.inputController,
      obscureText: widget.hide,
      decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.black, fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          suffixIcon: 
                  widget.label == "enter password"
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      if (widget.hide == true) {
                        widget.hide = false;
                      } else {
                        widget.hide = true;
                      }
                    });
                  },
                  child: const Icon(Icons.remove_red_eye_outlined))
              : const Text(""),
          label: Text(widget.label),
          hintText: widget.hint),
    );
  }
}
