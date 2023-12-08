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
            backgroundColor: const Color.fromARGB(109, 39, 39, 39),
            elevation: 5,
            child: const Icon(
              Icons.keyboard_double_arrow_down_rounded,
              color: Color.fromARGB(255, 255, 255, 255),
            )),
      ),
      appBar: AppBar(
        title: const Text("Quant Chat Room"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: GroupedListView(
            floatingHeader: true,
            reverse: true,
            stickyHeaderBackgroundColor: Colors.black45,
            order: GroupedListOrder.DESC,
            elements: msg,
            groupBy: (messages) => DateTime(
                messages.time.day, messages.time.month, messages.time.year),
            groupHeaderBuilder: (element) => Center(
              child: Card(
                color: const Color.fromARGB(195, 0, 0, 0),
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
              child: Card(
                margin: element.sender == widget.username
                    ? const EdgeInsets.only(
                        left: 50, top: 5, bottom: 5, right: 5)
                    : const EdgeInsets.only(
                        right: 50, top: 5, bottom: 5, left: 5),
                elevation: 5,
                child: MessageboxDesign(
                  curruser: element.sender == widget.username,
                  child: Column(
                    crossAxisAlignment: element.sender == widget.username
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Text(
                          element.message,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${element.time.hour}:${element.time.minute}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromARGB(255, 54, 54, 54),
                  ),
                  child: TextField(
                    controller: txtcontroller,
                    style: TextStyle(color: Colors.grey[400]),
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
        ],
      ),
    );
  }
}
