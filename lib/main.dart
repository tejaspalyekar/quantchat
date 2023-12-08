import 'package:flutter/material.dart';
import 'package:quantchat/Presentation/screens/welcomepage.dart';
import 'package:quantchat/Provider/Userdata.dart';
import 'package:provider/provider.dart';
Future<void> main() async {
  runApp(const myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> userdata())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: welcomePage(),
        ),
      ),
    );
  }
}