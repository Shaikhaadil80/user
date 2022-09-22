import 'package:flutter/material.dart';

import 'user.dart';

class Chat {
  String? id = UniqueKey().toString();
  // message text
  String text;
  // time of the message
  int time;
  // user id who send the message
  String? userId;

  User? user;

  Chat(this.id, this.text, this.time, this.userId);

  factory Chat.fromJSON(Map<String, dynamic> jsonMap) {
    return Chat(
        jsonMap['id'] != null ? jsonMap['id'].toString() : null,
        jsonMap['text'] != null ? jsonMap['text'].toString() : '',
        jsonMap['time'] != null ? jsonMap['time'] : 0,
        jsonMap['user'] != null ? jsonMap['user'].toString() : null);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["text"] = text;
    map["time"] = time;
    map["user"] = userId;
    return map;
  }
}
