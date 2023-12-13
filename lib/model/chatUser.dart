class ChatUser {
  late String uid;
  late String name;
  late String email;
  late String about;
  late String created_at;
  late String image;
  late String last_active;
  late String push_token;
  late bool is_online;
  late bool is_pin;
  List<String>? blockedUser;
  bool isblock=false;
  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.about,
    required this.created_at,
    required this.image,
    required this.is_online,
    required this.last_active,
    required this.push_token,
    required this.is_pin,
    List<String> blockedUser=const [],
    required this.isblock,
  });
  ChatUser.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    name = map["name"];
    email = map["email"] ?? "";
    about = map["about"];
    created_at = map["created_at"];
    image = map["image"];
    last_active = map["last_active"];
    push_token = map["push_token"];
    is_online = map["is_online"];
    is_pin=map["is_pin"]?? false;
    blockedUser=List<String>.from(map['blockedUser']??[]);
    isblock=map["isblock"];
  }
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "about": about,
      "created_at": created_at,
      "image": image,
      "last_active": last_active,
      "push_token": push_token,
      "is_online": is_online,
      "is_pin":is_pin,
      "blockedUser":blockedUser,
      "isblock":isblock
    };
  }
}
