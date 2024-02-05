import 'dart:math';

import 'package:uuid/uuid.dart';

const uuid = Uuid();
final rnd = Random();

class UserInfo {
  final String id;
  String name;
  String password;

  UserInfo({required this.name, required this.password}) : id = uuid.v4();

  UserInfo.fromJson(Map<String, dynamic> userInfoJson)
      : id = userInfoJson["id"],
        name = userInfoJson["name"],
        password = userInfoJson["password"];

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "password": password};
}

class PasswordInfo {
  final String id;
  String title;
  String password;
  String about;
  final String userId;

  PasswordInfo(
      {required this.title,
      required this.password,
      required this.about,
      required this.userId})
      : id = uuid.v4();

  PasswordInfo.fromJson(Map<String, dynamic> passwordInfoJson)
      : id = passwordInfoJson["id"],
        title = passwordInfoJson["title"],
        password = passwordInfoJson["password"],
        about = passwordInfoJson["about"],
        userId = passwordInfoJson["userId"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "password": password,
        "about": about,
        "userId": userId
      };
}
