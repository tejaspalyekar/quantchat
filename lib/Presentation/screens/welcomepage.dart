import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quantchat/Presentation/screens/HomePage.dart';
import 'package:quantchat/Presentation/widgets/ReuseableButton.dart';
import 'package:quantchat/Presentation/widgets/ReuseableTextinput.dart';
import 'package:quantchat/Provider/Userdata.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _LoginPageState();
}

class _LoginPageState extends State<WelcomePage> {
  TextEditingController userinputcontroller = TextEditingController(text: "@");
  @override
  Widget build(BuildContext context) {
    return Consumer<userdata>(
        builder: (context, value, child) => Scaffold(
            backgroundColor: const Color.fromARGB(216, 0, 0, 0),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "Assets/quantchatlogo.png",
                      width: 100,
                    ),
                    const Text(
                      "QuantChat",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Column(children: [
                      ReuseableTextInputField(
                          label: "username",
                          hint: "Enter username eg @tejas_02",
                          inputController: userinputcontroller),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ReuseableButton(
                              fun: () {
                                if (userinputcontroller.text != "@" &&
                                    userinputcontroller.text != "" &&
                                    userinputcontroller.text != "") {
                                  value.username =
                                      userinputcontroller.text.trim();
                                  Navigator.of(context).push(DialogRoute(
                                      context: context,
                                      builder: (context) => HomePage(
                                            username: value.username,
                                          )));
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Username Invalid",
                                      backgroundColor: Colors.black,
                                      fontSize: 20,
                                      textColor: Colors.white);
                                }
                              },
                              btncolor: Colors.white,
                              btntitle: "Lets chat")),
                    ]),
                  ],
                ),
              ),
            )));
  }
}
