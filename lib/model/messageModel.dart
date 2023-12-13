class MessageModel{
  late String fromid;
  late String toid;
  late String message;
  late String sent;
  late String read;
  late Type type;
  bool isdelete=false;
  bool deleteother=false;
  bool isstar=false;
  
 
  MessageModel({
    required this.fromid,
    required this.message,
    required this.read,
    required this.sent,
    required this.toid,
    required this.type,
    required this.isdelete,
    required this.isstar,
    required this.deleteother,
    
    
  });
  MessageModel.fromMap(Map<String, dynamic> map) {
    fromid = map["fromid"].toString();
    toid = map["toid"].toString();
    message = map["message"].toString();
    sent = map["sent"].toString();
    read = map["read"].toString();
    type = map["type"].toString()==Type.image.name?Type.image:Type.text;
    isdelete=map["isdelete"];
    deleteother=map['deleteother'];
    isstar=map["isstar"];
    
    
  }
  Map<String, dynamic> toMap() {
    return {
      "fromid": fromid,
      "toid": toid,
      "message": message,
      "sent": sent,
      "read": read,
      "type": type.name,
      "isdelete":isdelete,
      "deleteother":deleteother,
      "isstar":isstar,
      
    };
  }
}
enum Type{text,image}