import 'user.dart';

class Conversation {
  String? id;

  // conversation name for example chat with market name
  String name;

  // Chats messages
  String? lastMessage;

  int? lastMessageTime;

  // Ids of users that read the chat message
  List<String>? readByUsers;

  // Ids of users in this conversation
  List<String>? visibleToUsers;

  // users in the conversation
 List<User> users;
  Conversation(
    {
    required  this.users, 
     this.id,
    required this.name,
     this.lastMessage,
     this.lastMessageTime,
     this.readByUsers,
     this.visibleToUsers,
  });

  // Conversation(this.users, {this.id = null, this.name = ''}) {
  //   visibleToUsers = this.users.map((user) => user.id).toList();
  //   readByUsers = [];
  // }

  factory Conversation.fromJSON(Map<String, dynamic> jsonMap) {
    return Conversation(
     users: jsonMap['users'] != null
          ? List.from(jsonMap['users']).map((element) {
              element['media'] = [
                {'thumb': element['thumb']}
              ];
              return User.fromJson(element);
            }).toList()
          : [],id: jsonMap['id'].toString() ,
      lastMessage: jsonMap['message'] != null ? jsonMap['message'].toString() : '',
      lastMessageTime: jsonMap['time'] != null ? jsonMap['time'] : 0,
      visibleToUsers: jsonMap['visible_to_users'] != null
          ? List.from(jsonMap['visible_to_users'])
          : [],readByUsers: jsonMap['read_by_users'] != null
          ? List.from(jsonMap['read_by_users'])
          : [],name: jsonMap['name'] != null ? jsonMap['name'].toString() : '',
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["users"] = users.map((element) => element.toRestrictMap()).toSet().toList();
    map["visible_to_users"] = users.map((element) => element.id).toSet().toList();
    map["read_by_users"] = readByUsers;
    map["message"] = lastMessage;
    map["time"] = lastMessageTime;
    return map;
  }

  Map toUpdatedMap() {
    var map = new Map<String, dynamic>();
    map["message"] = lastMessage;
    map["time"] = lastMessageTime;
    map["read_by_users"] = readByUsers;
    return map;
  }
}
