import 'dart:convert';

// Class responsible for handling client-side functionality related to sending messages
class ClientSide {
  // Method to send a message with optional audio data
  sendmessage(String message, String sender, String bs4str, socket) {
    // Create a map to represent the message with its metadata
    Map<String, dynamic> typedmsg = {
      "msg": message,
      "date": DateTime.now().toIso8601String(),
      "sender": sender,
      "audio": bs4str
    };

    // Emit the message to the server using socket.io, converting the map to a JSON string
    socket?.emit('chat_message', jsonEncode(typedmsg));
  }
}
