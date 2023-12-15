import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantchat/Data%20Model/Messagedata.dart';
import 'package:quantchat/Presentation/widgets/ChattingFrame.dart';
import 'package:quantchat/Provider/Userdata.dart';
import 'package:quantchat/Service/AudioService.dart';
import 'package:quantchat/Service/ClientSide.dart';
import 'package:record/record.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Current mode for audio recording or text messaging
  String currmode = "Message..";

  // Audio service instance
  late AudioService audioservice;

  // ClientSide instance for handling message sending
  late ClientSide clientside;

  // List to store chat messages
  List<Messagedata> msg = [];

  // Socket for communication
  io.Socket? socket;

  // Controller for text input
  TextEditingController txtcontroller = TextEditingController();

  // Record instance for audio recording
  late Record audioRecord;

  // String for bs4str
  //String bs4str = "";

  // Flag for recording status
  bool isRecording = false;

  late String username;
  // Scroll controller for chat list
  ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize instances and open socket connection
    audioRecord = Record();
    clientside = ClientSide();
    openSocketConnection();
    final provider = Provider.of<userdata>(context, listen: false);
    audioservice = AudioService(socket: socket, sender: provider.username);
    username = provider.username;
    msg = provider.msg;
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose resources when the widget is disposed
    txtcontroller.dispose();
    socket!.disconnect();
    socket!.dispose();
    audioRecord.dispose();
    audioRecord.dispose();
  }

  // Open socket connection
  openSocketConnection() {
    socket = io.io('http://10.0.2.2:3000', <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket?.connect();
    socket?.onConnect((_) {
      print("Connection established");
    });
    socket?.onDisconnect((_) => print("Connection Disconnection"));
    socket?.onConnectError((err) => print(err));
    socket?.onError((err) => print(err));
    listen();
  }

  // Listen for incoming chat messages
  listen() {
    socket?.on('chat_message', (data) {
      final message = Messagedata.fromjson(jsonDecode(data));
      final provider = Provider.of<userdata>(context, listen: false);
      provider.setmessage(message);
      setState(() {
        msg = provider.msg;
      });
    });
  }

  // Send text message
  sendmessage() {
    clientside.sendmessage(
        txtcontroller.text.trim(), username.trim(), "", socket);
    txtcontroller.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton.small(
            onPressed: () {
              final position = listScrollController.position.minScrollExtent;
              listScrollController.jumpTo(position);
            },
            backgroundColor: const Color.fromARGB(108, 146, 146, 146),
            elevation: 5,
            child: const Icon(
              Icons.keyboard_double_arrow_down_rounded,
              color: Color.fromARGB(255, 255, 255, 255),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text(
          "Quant Chat Room",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(215, 32, 32, 32),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: Colors.white,
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChattingFrame(
              msg: msg,
              socket: socket,
              listScrollController: listScrollController),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            color: const Color.fromARGB(255, 0, 0, 0),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color.fromARGB(255, 109, 72, 4),
                    child: IconButton(
                      onPressed: () async {
                        setState(() {
                          txtcontroller.clear();
                          if (!isRecording) {
                            currmode = "Recording...";
                          } else {
                            currmode = "Message...";
                          }
                        });
                        bool recordstate;
                        if (!isRecording) {
                          recordstate =
                              await audioservice.startRecording(audioRecord);
                        } else {
                          recordstate =
                              await audioservice.stopRecording(audioRecord);
                        }
                        setState(() {
                          isRecording = recordstate;
                        });
                      },
                      icon: isRecording
                          ? const Icon(Icons.stop_circle)
                          : const Icon(Icons.mic),
                      color: Colors.white,
                      alignment: Alignment.center,
                      iconSize: 25,
                    )),
                Expanded(
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(255, 90, 90, 90),
                    ),
                    child: TextField(
                      controller: txtcontroller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(left: 10, right: 10),
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          hintText: currmode,
                          border: InputBorder.none),
                      minLines: 1,
                      maxLines: 10,
                    ),
                  ),
                ),
                CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color.fromARGB(255, 68, 109, 70),
                    child: IconButton(
                      onPressed: () {
                        if (txtcontroller.text != "") {
                          sendmessage();
                        }
                      },
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                      alignment: Alignment.center,
                      iconSize: 25,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
