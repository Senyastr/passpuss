import 'dart:math';

import 'package:PassPuss/view/pages/homePage.dart';

enum Tags { red, green, yellow, orange, graphite, white }

class PassEntry {
  int id;
  String _username;
  String _password; // ""
  String _email;
  String _title; // e.g. google, facebook, instagram
  String _iconName = "";
  DateTime createdTime;
  Tags _tag;

  Tags get tag => _tag;


  // ignore: non_constant_identifier_names

  PassEntry.noIcon(String username, String password, String title, String email,
      DateTime createdTime, Tags tag) {
    if (HomePageState.Pairs == null) {
      id = 1;
    } else {
      id = HomePageState.Pairs.length + 1;
    }

    this._username = username;
    this._password = password;
    this._title = title;
    this.createdTime = createdTime;
    this._email = email;
    this._tag = tag;
  }

  PassEntry.withIcon(String username, String password, String title,
      String email, String iconName, Tags tag, DateTime createdTime) {
    if (HomePageState.Pairs == null) {
      id = 1;
    } else {
      id = HomePageState.Pairs.length + 1;
    }

    this._username = username;
    this._password = password;
    this._title = title;
    this._iconName = iconName;
    this.createdTime = createdTime;
    this._email = email;
    this._tag = tag;
  }

  PassEntry.fromDB(int id, String username, String password, String title,
      String iconName, DateTime createdTime, String email, Tags tag) {
    this.id = id;
    this._username = username;
    this._password = password;
    this._title = title;
    this._iconName = iconName;
    this.createdTime = createdTime;
    this._email = email;
    this._tag = tag;
  }

  String getUsername() {
    return _username;
  }

  String getPassword() {
    return _password;
  }

  String getTitle() {
    return _title;
  }

  void setTitle(String title) {
    this._title = title;
  }

  String getIconId() {
    return _iconName;
  }

  String getEmail() {
    return _email;
  }

  void setIconId(String iconId) {
    this._iconName = iconId;
  }

  // this one is used to get char array and generate password
  static List<String> charinds = [
    'A',
    'a',
    'B',
    'b',
    'C',
    'c',
    'D',
    'd',
    'E',
    'e',
    'F',
    'f',
    'G',
    'g',
    'H',
    'h',
    'I',
    'i',
    'J',
    'j',
    'K',
    'k',
    'L',
    'l',
    'M',
    'm',
    'N',
    'n',
    'O',
    'o',
    'P',
    'p',
    'Q',
    'q',
    'R',
    'r',
    'S',
    's',
    'T',
    't',
    'U',
    'u',
    'V',
    'v',
    'W',
    'w',
    'X',
    'x',
    'Y',
    'y',
    'Z',
    'z',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0'
  ];

  static String generatePass(int amount) {
    Random random = new Random();
    StringBuffer builder = new StringBuffer();
    for (int i = 0; i < amount; i++) {
      builder.write(charinds[random.nextInt(charinds.length)]);
    }
    return builder.toString();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "USERNAME": _username,
        "PASSWORD": _password,
        "TITLE": _title,
        "ICONPATH": _iconName,
        "CREATEDTIME": createdTime.toString(),
        "EMAIL": _email,
        "TAG": _tag,
      };
}
