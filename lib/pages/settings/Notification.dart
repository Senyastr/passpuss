import 'package:PassPuss/pages/settings/settings.dart';
import 'package:flutter/material.dart';

import '../../localization.dart';

class NotificationSettingsTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationSettingsTabState();
  }
}

class NotificationSettingsTabState extends State<NotificationSettingsTab>
    implements SettingsTab {
  bool turnedNotifcation = true;
  String expirationDays;
  final List<String> expirationItems = [
    "1 month",
    "2 weeks",
    "1 week",
  ];
  static const String notifcationsOn = "notificationsOn";
  static const String passwordEntryExpiration = "passwordEntryExpirationDays";

  var notificationIcon = Icon(
    Icons.notifications,
    size: 40,
    color: Colors.yellowAccent,
  );
  @override
  void initState() {
    super.initState();
    initSettings();
  }

  @override
  Widget build(BuildContext context) {
    var layout = Scaffold(
        appBar: AppBar(),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Hero(tag: "notif", child: notificationIcon),
                      Text(
                        LocalizationTool.of(context).notifications,
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: Colors.white),
                      ),
                      Container(
                          width: 60,
                          height: 40,
                          child: Switch(
                            onChanged: (bool changed) {
                              setState(() {
                                turnedNotifcation = changed;
                                SettingsManager.changePref(
                                    notifcationsOn, changed);
                                // print(SettingsManager.getPref(notifcationsOn));
                              });
                            },
                            value: turnedNotifcation,
                          )),
                    ])),
            SafeArea(
                child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Divider()),
                // !!!! HERE ARE SETTINGS !!!!
                // Password Expiration Notification Days
                ListTile(
                  leading: Icon(Icons.access_time, color: Colors.white),
                  title: Text(
                    LocalizationTool.of(context)
                        .settingsNotificationPasswordExpirationDays,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white),
                  ),
                  trailing: DropdownButton<String>(
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white),
                    value: expirationDays,
                    items:
                        expirationItems.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: turnedNotifcation
                        ? (String changed) async {
                            setState(() {
                              expirationDays = changed;
                            });
                            switch (changed) {
                              case "1 month":
                                {
                                  SettingsManager.changePref(
                                      passwordEntryExpiration,
                                      30); // 30 days = 1 month
                                  break;
                                }
                              case "2 weeks":
                                {
                                  SettingsManager.changePref(
                                      passwordEntryExpiration, 14);
                                  break;
                                }
                              case "1 week":
                                {
                                  SettingsManager.changePref(
                                      passwordEntryExpiration, 7);
                                }
                            }
                          }
                        : null,
                  ),
                ),
                Divider(),
                Column(
                  children: <Widget>[
                    Text(
                      LocalizationTool.of(context).soon,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: Colors.white),
                    ),
                    Icon(Icons.watch_later,
                        size: 50, color: Theme.of(context).accentColor),
                  ],
                ),
              ],
            )),
          ],
        )));
    return layout;
  }

  void initSettings() async {
    // NOTIFCATION ON OR OFF IN GENERAL
    dynamic temp = (await SettingsManager.getPref(notifcationsOn)) as bool;
    turnedNotifcation = (temp == null ? true : temp);

    temp = (await SettingsManager.getPref(passwordEntryExpiration)) as int;
    switch (temp) {
      case 30:
        {
          temp = "1 month";
          break;
        }
      case 14:
        {
          temp = "2 weeks";
          break;
        }
      case 7:
        {
          temp = "1 week";
          break;
        }
    }
    expirationDays = (temp == null ? "1 month" : temp);
    setState(() {});
  }
}
