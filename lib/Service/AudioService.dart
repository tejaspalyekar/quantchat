import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:quantchat/Service/ClientSide.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

// Service class responsible for audio-related functionalities
class AudioService {
  // Constructor with required parameters: socket and sender
  AudioService({required this.socket, required this.sender});

  // Sender's username
  String sender;

  // Socket for communication
  io.Socket? socket;

  // Instance of ClientSide for sending messages
  ClientSide clientSide = ClientSide();

  // Method to play audio from base64-encoded string
  Future<bool> playaudio(String audiobs64, AudioPlayer player) async {
    // Decode base64 string to Uint8List
    Uint8List decodedbytes = base64.decode(audiobs64);
    print(decodedbytes);

    try {
      // Play audio using the Audioplayer package
      await player.play(BytesSource(decodedbytes));
      print("audio playing..");
      return true;
    } catch (e) {
      // Handle any errors during audio playback
      print('error while playing audio ${e.toString()}');
      return false;
    }
  }

  // Method to stop audio playback
  bool stopPlayer(AudioPlayer player) {
    player.stop();
    return false;
  }

  // Method to start recording audio
  Future<bool> startRecording(Record audioRecord) async {
    try {
      // Check and request permission before starting recording
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
      }
      return true;
    } catch (e) {
      // Handle errors during audio recording start
      print("error while recording");
      return false;
    }
  }

  // Method to stop recording audio
  Future<bool> stopRecording(Record audioRecord) async {
    try {
      // Stop recording and get the file path
      String? path = await audioRecord.stop();
      
      // Convert audio file to base64 and send as a message
      String bs64 = await convertaudio(path!);
      await clientSide.sendmessage("", sender, bs64, socket);
      return false;
    } catch (e) {
      // Handle errors during audio recording stop
      print("error while stopping recording");
      return true;
    }
  }

  // Method to convert audio file to base64-encoded string
  Future<String> convertaudio(String audiopath) async {
    // Read audio file as bytes and encode to base64
    File audiofile = File(audiopath);
    Uint8List audiobytes = await audiofile.readAsBytes();
    return base64.encode(audiobytes);
  }
}
