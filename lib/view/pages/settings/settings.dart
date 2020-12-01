import 'package:PassPuss/logic/localization.dart';
import 'package:PassPuss/view/pages/settings/Data.dart';
import 'package:PassPuss/view/pages/settings/ForYou.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Notification.dart';
import 'Privacy.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  var settingsIcon = Icon(
    Icons.settings,
    size: 32,
    color: Colors.white,
  );

  var notifcationIcon =
      Icon(Icons.notifications, color: Colors.yellowAccent, size: 32);

  var recommendationIcon = Icon(Icons.thumb_up, color: Colors.indigo, size: 32);

  var privacyIcon = Icon(Icons.lock, color: Colors.blueAccent, size: 32);

  var dataIcon = SvgPicture.asset("assets/images/storage-black-48dp.svg", height: 32, width: 32, color: Colors.blueAccent);

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        body: Column(
      children: <Widget>[
        SafeArea(
          child: Row(children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white, size: 32), onPressed: () => Navigator.pop<SettingsPage>(context),
              ))
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      LocalizationTool.of(context).settings,
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ))),
            Padding(
              child: Hero(tag: "settings", child: settingsIcon),
              padding: EdgeInsets.only(left: 30),
            )
          ]),
        ),
        Column(
          children: <Widget>[
            // ADD THIS CODE TO CREATE A NEW SETTINGS PART:
            //Row(children: <Widget>[

            //],
            // NOTIFICATIONS TAB
            _buildSettingsListTile(notifcationIcon, NotificationSettingsTab(), "notif", LocalizationTool.of(context).notifications),
            
            // RECOMMENDATION TAB
            _buildSettingsListTile(recommendationIcon, ForYouSettingsTab(), "forYou", LocalizationTool.of(context).forYou),
            
            _buildSettingsListTile(privacyIcon, PrivacySettingsTab(), "privacy", LocalizationTool.of(context).privacy),
            

            _buildSettingsListTile(dataIcon, DataSettingsTab(), "data", LocalizationTool.of(context).data),
          ],
        )
      ],
    ));
  }
  Widget _buildSettingsListTile(Widget icon, Widget settingsTab, String heroTag, String title){
     var listTileColor = Theme.of(context).cardColor;
    return Card(
              color: listTileColor, 
              child: ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => settingsTab));
                },
                leading: Hero(tag: heroTag, child: icon),
                title: Text(
                  title,
                  style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)
                )
              ),
              
            );
  }
}

class SettingsManager {
  static Future<void> changePref<T>(String key, T value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    switch (T) {
      case int:
        sharedPreferences.setInt(key, value as int);
        break;
      case String:
        sharedPreferences.setString(key, value as String);
        break;
      case bool:
        sharedPreferences.setBool(key, value as bool);
        break;
      case double:
        sharedPreferences.setDouble(key, value as double);
        break;
    }
  }

  static Future<T> getPref<T>(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key);
  }
}

class SettingsTab {
  void initSettings() {}
}
