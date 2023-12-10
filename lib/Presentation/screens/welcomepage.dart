import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quantchat/Presentation/screens/HomePage.dart';
import 'package:quantchat/Presentation/widgets/ReuseableButton.dart';
import 'package:quantchat/Presentation/widgets/ReuseableTextinput.dart';
import 'package:quantchat/Provider/Userdata.dart';
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _LoginPageState();
}

class _LoginPageState extends State<WelcomePage> {
  TextEditingController userinputcontroller =
      TextEditingController(text: "@"); // Controller for the username input field

  @override
  Widget build(BuildContext context) {
    return Consumer<userdata>(
      builder: (context, value, _) => Scaffold(
        backgroundColor: const Color.fromARGB(216, 0, 0, 0),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // QuantChat logo
                Image.asset(
                  "Assets/quantchatlogo.png",
                  width: 100,
                ),
                const Text(
                  "QuantChat",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    // ReusableTextInputField for username input
                    ReuseableTextInputField(
                      label: "username",
                      hint: "Enter username eg @tejas_02",
                      inputController: userinputcontroller,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    // ReusableButton for initiating the chat
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ReuseableButton(
                        fun: () {
                          // Check if the username is valid and navigate to HomePage
                          if (userinputcontroller.text != "@" &&
                              userinputcontroller.text != "" &&
                              userinputcontroller.text != "") {
                            value.username = userinputcontroller.text.trim();
                            Navigator.of(context).push(
                              DialogRoute(
                                context: context,
                                builder: (context) => HomePage(
                                  username: value.username,
                                ),
                              ),
                            );
                          } else {
                            // Show a toast message for invalid username
                            Fluttertoast.showToast(
                              msg: "Username Invalid",
                              backgroundColor: Colors.black,
                              fontSize: 20,
                              textColor: Colors.white,
                            );
                          }
                        },
                        btncolor: Colors.white,
                        btntitle: "Lets chat",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
