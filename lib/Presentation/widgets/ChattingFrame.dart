import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quantchat/Data%20Model/Messagedata.dart';
import 'package:quantchat/Presentation/widgets/messageboxdesign.dart';
import 'package:quantchat/Provider/Userdata.dart';
import 'package:quantchat/Service/AudioService.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

// ignore: must_be_immutable
class ChattingFrame extends StatefulWidget {
  // Constructor for ChattingFrame
  ChattingFrame(
      {super.key,
      required this.msg,
      required this.socket,
      required this.listScrollController});
  
  // List to store chat messages
  List<Messagedata> msg = [];
  
  // Socket for communication
  io.Socket? socket;
  
  // Scroll controller for the chat list
  ScrollController listScrollController;

  @override
  State<ChattingFrame> createState() => _ChattingFrameState();
}

class _ChattingFrameState extends State<ChattingFrame> {
  // User's username
  late String username = "";

  // Audio service instance
  late AudioService audioservice;

  // Flag for audio playback status
  bool isPlaying = false;

  // AudioPlayer instance for playing audio
  late AudioPlayer player;

  // Currently playing message box
  Messagedata? currplayingmegbox;

  @override
  void initState() {
    super.initState();
    // Initialize instances and get the username
    audioservice = AudioService(socket: widget.socket, sender: username);
    final provider = Provider.of<userdata>(context, listen: false);
    username = provider.username;
    player = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            // Container decoration with background image
            decoration: const BoxDecoration(
                color: Colors.black,
                image:
                    DecorationImage(image: AssetImage("Assets/wallpaper.jpg"))),
            child: GroupedListView(
              // GroupedListView for displaying messages
              controller: widget.listScrollController,
              floatingHeader: true,
              reverse: true,
              stickyHeaderBackgroundColor: Colors.black,
              order: GroupedListOrder.DESC,
              elements: widget.msg,
              groupBy: (messages) => DateTime(
                  messages.time.day, messages.time.month, messages.time.year),
              groupHeaderBuilder: (element) => Center(
                // Group header showing date
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
                // Align message boxes based on the sender
                alignment: element.sender == username
                    ? Alignment.topRight
                    : Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display sender's name if the sender is not the current user
                    username != element.sender
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 5, bottom: 2),
                            child: Text(
                              '~ ${element.sender.substring(1)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          )
                        : const Text(""),

                    // Message box design
                    Card(
                      margin: element.sender == username
                          ? const EdgeInsets.only(left: 50, right: 5, bottom: 5)
                          : const EdgeInsets.only(
                              right: 50, top: 5, bottom: 5, left: 5),
                      elevation: 5,
                      child: MessageboxDesign(
                        curruser: element.sender == username,
                        child: Column(
                          crossAxisAlignment: element.sender == username
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            // Display audio playback or text message
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 2, top: 5),
                              child: element.message == ""
                                  ? SizedBox(
                                      width: 160,
                                      child: Row(
                                        children: [
                                          // Audio playback controls
                                          IconButton(
                                              onPressed: () async {
                                                bool audiostate;
                                                if (!isPlaying) {
                                                  // Start audio playback
                                                  audiostate =
                                                      await audioservice
                                                          .playaudio(
                                                              element
                                                                  .audiobs64!,
                                                              player);
                                                } else {
                                                  // Stop audio playback
                                                  audiostate = audioservice
                                                      .stopPlayer(player);
                                                }
                                                setState(() {
                                                  isPlaying = audiostate;
                                                  currplayingmegbox = element;
                                                });
                                              },
                                              icon: Icon(
                                                isPlaying &&
                                                        element ==
                                                            currplayingmegbox
                                                    ? Icons.stop_circle_outlined
                                                    : Icons.play_arrow_rounded,
                                                size: 40,
                                                color: const Color.fromARGB(
                                                    255, 255, 102, 0),
                                              )),
                                          // Display audio waves while playing
                                          isPlaying &&
                                                  currplayingmegbox == element
                                              ? Row(
                                                  children: [
                                                    Image.asset(
                                                      "Assets/audio_waves.gif",
                                                      width: 50,
                                                    ),
                                                    Image.asset(
                                                      "Assets/audio_waves.gif",
                                                      width: 50,
                                                    ),
                                                  ],
                                                )
                                              : Image.asset(
                                                  "Assets/audio_waves.png",
                                                  width: 100,
                                                ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      // Display text message
                                      element.message!,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                            ),
                            // Display message timestamp
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${element.time.hour}:${element.time.minute}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 255, 255, 255),
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
            )));
  }
}
