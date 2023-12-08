import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantchat/Presentation/screens/HomePage.dart';
import 'package:quantchat/Presentation/widgets/ReuseableButton.dart';
import 'package:quantchat/Presentation/widgets/ReuseableTextinput.dart';
import 'package:quantchat/Provider/Userdata.dart';

class welcomePage extends StatefulWidget {
  welcomePage({super.key});

  @override
  State<welcomePage> createState() => _LoginPageState();
}

class _LoginPageState extends State<welcomePage> {
  TextEditingController userinputcontroller = TextEditingController(text: "@");

  @override
  Widget build(BuildContext context) {
    return Consumer<userdata>(
      builder: (context, value, child) => Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "QuantChat",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(children: [
                  ReuseableTextInputField(
                      hide: false,
                      label: "username",
                      hint: "Enter username eg @tejas_02",
                      inputController: userinputcontroller),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ReuseableButton(
                          fun: () {
                            value.username = userinputcontroller.text.trim();
                            Navigator.of(context).push(DialogRoute(
                                context: context,
                                builder: (context) => HomePage(username: value.username,)));
                            print(value.username);
                          },
                          btncolor: Colors.black,
                          btntitle: "Lets chat")),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
