class Messagedata {
  Messagedata(
      {required this.time, required this.message, required this.sender});

  String message;
  DateTime time;
  String sender;

  static Messagedata fromjson(data) {
    return Messagedata(
        time: DateTime.parse(data["date"]), message: data["msg"], sender: data["sender"]);
  }
}
