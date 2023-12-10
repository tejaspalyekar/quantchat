class Messagedata {
  Messagedata(
      {required this.time,this.message, required this.sender,this.audiobs64});
  String? message;
  DateTime time;
  String sender;
  String? audiobs64;

  static Messagedata fromjson(data) {
    return Messagedata(
        time: DateTime.parse(data["date"]),
        message: data["msg"],
        sender: data["sender"],
         audiobs64: data["audio"]
        );
         
  }

}
