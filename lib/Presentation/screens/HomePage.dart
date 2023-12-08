import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quantchat/Data%20Model/Messagedata.dart';
import 'package:quantchat/Presentation/widgets/messageboxdesign.dart';
import 'package:quantchat/Provider/Userdata.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key, required this.username});
  String username;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Messagedata> msg = [];
  Icon curricon = const Icon(Icons.send);
  io.Socket? socket;
  TextEditingController txtcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.username);
    openSocketConection();
    final provider = Provider.of<userdata>(context, listen: false);
    msg = provider.msg;
  }

  openSocketConection() {
    socket = io.io('http://10.0.2.2:3000', <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket?.connect();
    socket?.onConnect((_) {
      print("Connection established");
    });
    socket?.on('chat_message', (data) {
      final message = Messagedata.fromjson(jsonDecode(data));
      final provider = Provider.of<userdata>(context, listen: false);
      provider.setmessage(message);
      setState(() {
        msg = provider.msg;
      });
    });
    socket?.onDisconnect((_) => print("connection Disconnection"));
    socket?.onConnectError((err) => print(err));
    socket?.onError((err) => print(err));
  }

  sendmessage() {
    Map<String, dynamic> typedmsg = {
      "msg": txtcontroller.text.trim(),
      "date": DateTime.now().toIso8601String(),
      "sender": widget.username,
    };
    socket?.emit('chat_message', jsonEncode(typedmsg));
    txtcontroller.clear();
  }

  @override
  void dispose() {
    super.dispose();
    txtcontroller.dispose();
    socket!.disconnect();
    socket!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton.small(
            onPressed: () {},
            backgroundColor: Color.fromARGB(108, 146, 146, 146),
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
        backgroundColor: const Color.fromARGB(216, 0, 0, 0),
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
          Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                          image: AssetImage("Assets/wallpaper.jpg"))),
                  child: GroupedListView(
                    floatingHeader: true,
                    reverse: true,
                    stickyHeaderBackgroundColor: Colors.black,
                    order: GroupedListOrder.DESC,
                    elements: msg,
                    groupBy: (messages) => DateTime(messages.time.day,
                        messages.time.month, messages.time.year),
                    groupHeaderBuilder: (element) => Center(
                      child: Card(
                        color: const Color.fromARGB(108, 146, 146, 146),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            DateFormat.yMMMd().format(element.time),
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                      ),
                    ),
                    itemBuilder: (context, element) => Align(
                      alignment: element.sender == widget.username
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.username != element.sender
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 5, bottom: 2),
                                  child: Text(
                                    element.sender.substring(1),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                )
                              : const Text(""),
                          Card(
                            margin: element.sender == widget.username
                                ? const EdgeInsets.only(left: 50, right: 5,bottom: 5)
                                : const EdgeInsets.only(
                                    right: 50, top: 5, bottom: 5, left: 5),
                            elevation: 5,
                            child: MessageboxDesign(
                              curruser: element.sender == widget.username,
                              child: Column(
                                crossAxisAlignment:
                                    element.sender == widget.username
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, bottom: 2, top: 5),
                                    child: Text(
                                      element.message,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      '${element.time.hour}:${element.time.minute}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white60,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))),
          Container(
            color: const Color.fromARGB(216, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
                          hintText: "Message..",
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
                      icon: curricon,
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
