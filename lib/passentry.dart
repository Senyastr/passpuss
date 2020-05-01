 import 'dart:math';

import 'package:passpuss/Database.dart';

import 'main.dart';
 
 class PassEntry 
  {
    int id;
    String _username;
    String _password; // ""
    String _title; // e.g. google, facebook, instagram
    String _iconName = "";

    // ignore: non_constant_identifier_names

    PassEntry.noIcon(String username, String password, String title){
      if (PassEntriesPage.Pairs == null){
        id = 1;
      }
      else{
        id = PassEntriesPage.Pairs.length + 1;
      }

        this._username = username;
        this._password = password;
        this._title = title;
    }
    PassEntry.withIcon(String username, String password, String title, String iconName){
      if (PassEntriesPage.Pairs == null){
        id = 1;
      }
      else{
        id = PassEntriesPage.Pairs.length + 1;
      }

        this._username = username;
        this._password = password;
        this._title = title;
        this._iconName = iconName;

    }

    String getUsername(){
        return _username;
    }
    String getPassword(){
        return _password;
    }
    String getTitle() {
        return _title;
    }
    void setTitle(String title) {
        this._title = title;
    }
    String getIconId() {return _iconName;}
    void setIconId(String iconId) { this._iconName = iconId; }
    // this one is used to get char array and generate password
    static List<String> charinds = ['A', 'a','B', 'b','C', 'c','D', 'd','E', 'e','F', 'f','G', 'g','H', 'h','I', 
            'i','J', 'j','K', 'k','L', 'l','M', 'm','N', 'n','O', 'o','P', 'p','Q' ,'q','R', 'r','S' ,'s','T', 't','U',
            'u','V', 'v','W', 'w','X', 'x','Y', 'y','Z', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];

  static String generate_pass(int amount){
    Random random = new Random();
    StringBuffer builder = new StringBuffer();
    for(int i = 0; i <= amount; i++){
        builder.write(charinds[random.nextInt(charinds.length)]);
    }
    return builder.toString();
}
    static PassEntry GenerateUserPass(String username, String title, String iconId, int amount)
    {
        String password = generate_pass(amount);
        return new PassEntry.withIcon(username, password,title, iconId);
    }
     static String GeneratePassword(int amount)
    {
        String password = generate_pass(amount);
        return password;
    }

    Map<String, dynamic> toJson() => {
      "id": id,
      "USERNAME": _username,
      "PASSWORD": _password,
      "TITLE": _title,
      "ICONPATH": _iconName
    };
  }

