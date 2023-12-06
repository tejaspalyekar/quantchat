import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:quantchat/Data%20Model/Messagedata.dart';
import 'package:quantchat/Presentation/widgets/messageboxdesign.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Icon curricon = const Icon(Icons.send);
  List<Messagedata> messages = [
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 3, minutes: 3)),
        message: "message",
        currUserMsg: true),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 3, minutes: 4)),
        message: "message",
        currUserMsg: false),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 3, minutes: 4)),
        message: "message",
        currUserMsg: true),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 3, minutes: 5)),
        message: "message",
        currUserMsg: false),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 3, minutes: 3)),
        message: "message",
        currUserMsg: true),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 4, minutes: 3)),
        message: "message",
        currUserMsg: false),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 4, minutes: 4)),
        message: "message",
        currUserMsg: true),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 4, minutes: 5)),
        message: "message",
        currUserMsg: true),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 4, minutes: 6)),
        message: "message",
        currUserMsg: false),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 4, minutes: 7)),
        message: "message",
        currUserMsg: true),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 5, minutes: 8)),
        message: "message",
        currUserMsg: false),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 5, minutes: 9)),
        message: "message",
        currUserMsg: true),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 5, minutes: 9)),
        message: "message",
        currUserMsg: false),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 5, minutes: 3)),
        message: "message",
        currUserMsg: true),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 6, minutes: 3)),
        message: "message",
        currUserMsg: true),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 6, minutes: 3)),
        message: "message",
        currUserMsg: false),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 6, minutes: 3)),
        message: "message",
        currUserMsg: true),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 6, minutes: 3)),
        message: "message",
        currUserMsg: false),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 6, minutes: 3)),
        message: "message",
        currUserMsg: true),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 6, minutes: 3)),
        message: "message",
        currUserMsg: false),
    Messagedata(
        time: DateTime.now().subtract(const Duration(days: 6, minutes: 3)),
        message: "message",
        currUserMsg: true),
  ];
  TextEditingController textcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textcontroller.dispose();
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
        title: const Text("QuantChat"),
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
            elements: messages,
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
              alignment:
                  element.currUserMsg ? Alignment.topRight : Alignment.topLeft,
              child: Card(
                
                margin: element.currUserMsg
                    ? const EdgeInsets.only(
                        left: 50, top: 5, bottom: 5, right: 5)
                    : const EdgeInsets.only(
                        right: 50, top: 5, bottom: 5, left: 5),
                elevation: 5,
                child: MessageboxDesign(
                  curruser: element.currUserMsg,
                  child: Column(
                    crossAxisAlignment: element.currUserMsg
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Text(element.message),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10),
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
                    controller: textcontroller,
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
                      if (textcontroller.text != "") {
                        final msg = Messagedata(
                            time: DateTime.now(),
                            message: textcontroller.text,
                            currUserMsg: true);
                        setState(() {
                          messages.add(msg);
                          textcontroller.clear();
                        });
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
